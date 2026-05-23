setwd("~/work/my_R_assistant")
suppressPackageStartupMessages(library(tidyverse))
library(logger)

path_to_logs <- str_c(getwd(), "/logs/assistant_logs.txt")
path_to_scripts <- str_c(getwd(), "/scripts/")
path_to_skills <- str_c(getwd(), "/skills/")
path_to_tasks <- str_c(getwd(), "/tasks/tasks.csv")

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

log_info("📋  Читаю список задач")

path_to_tasks |> 
  read_csv(show_col_types = FALSE,
           progress = FALSE) |> 
  filter(is.na(ignore)) ->
  tasks

if(sum(duplicated(tasks$id)) > 0) {
  log_info("🧮  Обнаружены повторяющиеся индексы, переиндексирую список задач")
  
  path_to_tasks |> 
    read_csv(show_col_types = FALSE,
             progress = FALSE) |> 
    mutate(id = 1:n()) |> 
    write_csv(file = path_to_tasks, na = "")
  
  path_to_tasks |> 
    read_csv(show_col_types = FALSE,
             progress = FALSE) |> 
    filter(is.na(ignore)) ->
    tasks
}

n_tasks <- nrow(tasks)

log_info("🦦  Количество задач в файле: {n_tasks}")

seq_along(tasks$id) |> 
  walk(function(task_id){
    
    run_task(current_task = tasks$task[task_id], 
             skill = tasks$skill[task_id], 
             schedule = tasks$schedule[task_id],
             params = tasks$params[task_id],
             task_id = task_id,
             path_to_tasks = path_to_tasks)
    })

log_info("🧮  Задачи выполнены, переиндексирую список задач")

path_to_tasks |>
  read_csv(show_col_types = FALSE,
           progress = FALSE) |>
  nrow() ->
  n_tasks

if(n_tasks > 0) {
  path_to_tasks |> 
    read_csv(show_col_types = FALSE,
             progress = FALSE) |> 
    mutate(id = 1:n()) |> 
    write_csv(file = path_to_tasks, na = "")
}  