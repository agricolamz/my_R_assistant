suppressPackageStartupMessages(library(tidyverse))
library(logger)
library(gmailr)

path_to_logs <- "~/work/my_R_assistant/logs/assistant_logs.txt"
path_to_scripts <- "~/work/my_R_assistant/scripts/"
path_to_skills <- "~/work/my_R_assistant/skills/"
path_to_tasks <- "~/work/my_R_assistant/tasks/tasks.csv"

list.files(path_to_skills, 
           recursive = TRUE,
           pattern = "\\.R",
           full.names = TRUE) |> 
  str_subset("/scripts/") ->
  skills_function

skills_function |> 
  walk(source)

path_to_logs |> 
  appender_tee(file = _, 
               max_lines = 1000L, 
               max_files = 10L) |> 
  log_appender()

log_threshold(INFO)

log_info("📋 Читаю список задач")

path_to_tasks |> 
  read_csv(show_col_types = FALSE,
           progress = FALSE) |> 
  filter(is.na(ignore)) ->
  tasks

n_tasks <- nrow(tasks)

log_info("Количество задач в файле: {n_tasks}")

seq_along(tasks$id) |> 
  walk(function(task_id){
    current_task <- tasks$task[task_id]
    log_info("{current_task} начинается, запускаю {tasks$script[task_id]}")
    script <- str_c(path_to_scripts, tasks$script[task_id])
    if(file.access(script) == 0){
      log_debug("✔️   Скрипт существует, запускаю")
      
      if(tools::file_ext(script) == "R"){
        
        if(!is.na(tasks$params[task_id])){
          tasks$params[task_id] |>
            jsonlite::fromJSON() ->
            params

          seq_along(params) |>
            walk(function(i){
              assign(names(params)[[i]],
                     params[[i]],
                     envir = parent.frame(n = 4))
            })
        }
        
        source(script, local = TRUE)  
      } else {
        log_error("🫣  Пока поддерживаются только R скрипты")
      }
      
      if(tasks$after_finished[task_id] == "remove"){
        log_info("🗑  Удаляю задачу {current_task} из списка.")

        path_to_tasks |> 
          read_csv(show_col_types = FALSE,
                   progress = FALSE) |> 
          filter(id != task_id) |> 
          write_csv(file = path_to_tasks, na = "")
      }
      
    } else {
      log_error("⚠️   Скрипт {tasks$script[task_id]} не найден")
      log_info("🙈️   Меняю статус задачи {tasks$script[task_id]} на ignore.")

      path_to_tasks |> 
        read_csv(show_col_types = FALSE,
                 progress = FALSE) |> 
        mutate(ignore = if_else(id == task_id, "ignore", ignore)) |> 
        write_csv(file = path_to_tasks, na = "")
      
      if(curl::has_internet()){
        
        sent_gmail_message(subject = "Нет скрипта для задачи",
                           message = str_glue("Я не нашел скрипт {tasks$script[task_id]} для задачи {tasks$task[task_id]} и поменял ее статус на `ignore`."),
                           log_message = "Отправляю письмо на gmail с сообщением об ошибке")
        
      } else {
        log_error("🦦  Интернета нет, так что я не сообщил о проблеме")
        log_info("🦦  Добавляю отправку письма с сообщением о проблеме в список задач")
      }
    }
    log_info("{current_task} закончена")
  })

log_info("🧮  Задачи выполнены, переиндексирую список задач")
path_to_tasks |> 
  read_csv(show_col_types = FALSE,
           progress = FALSE) |> 
  mutate(id = 1:n()) |> 
  write_csv(file = path_to_tasks, na = "")