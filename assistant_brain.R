suppressPackageStartupMessages(library(tidyverse))
library(logger)
library(gmailr)

path_to_logs <- "~/work/assistant/logs/assistant_logs.txt"
path_to_scripts <- "~/work/assistant/scripts/"
path_to_tasks <- "~/work/assistant/tasks/tasks.csv"

path_to_logs |> 
  appender_tee(file = _, 
               max_lines = 1000L, 
               max_files = 10L) |> 
  log_appender()

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
      log_info("✔️   Скрипт существует, запускаю")
      
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
        log_info("🫣  Пока поддерживаются только R скрипты")
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
      log_info("⚠️   Скрипт {tasks$script[task_id]} не найден")
      log_info("🙈️   Меняю статус задачи {tasks$script[task_id]} на ignore.")

      path_to_tasks |> 
        read_csv(show_col_types = FALSE,
                 progress = FALSE) |> 
        mutate(ignore = if_else(id == task_id, "ignore", ignore)) |> 
        write_csv(file = path_to_tasks, na = "")
      
      if(curl::has_internet()){
        log_info("🦦  Отправляю письмо на gmail с результатом работы Ollama")
        
        str_glue("
Привет!

Я не нашел скрипт {tasks$script[task_id]} для задачи {tasks$task[task_id]} и поменял ее статус на `ignore`.

🦦 
") |> 
          litedown::mark() ->
          message_body
        
        gm_mime() |>
          gm_to("agricolamz+from_bot@gmail.com") |>
          gm_subject("Нет скрипта для задачи") |>
          gm_text_body(message_body,
                       content_type = "text/html",
                       charset = "utf-8",
                       encoding = "base64") |> 
          gm_send_message()
      } else {
        log_info("🦦  Интернета нет, так что я не сообщил о проблеме")
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