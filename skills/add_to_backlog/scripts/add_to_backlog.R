#' @param task
#' @param skill
#' @param schedule
#' @param ignore
#' @param params
#' @param path_to_tasks
#' @param log_message message for adding to logs
#' 
#' @importFrom logger log_debug
#' @importFrom logger log_info
#' @importFrom yaml as.yaml
#' @importFrom readr read_csv
#' @importFrom readr write_csv
#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble

add_to_backlog <- function(task = "новое задание",
                           skill,
                           schedule = "once",
                           ignore = NA,
                           params = NA,
                           path_to_tasks,
                           log_message = "Добавляю задание в список задач"){
  
  logger::log_debug("🦦  Запуск умения `add_to_backlog`")
  
  # проверка параметров -----------------------------------------------------
  
  if(exists("task")){
    logger::log_debug("🦦  параметр `task` есть")  
  } else {
    logger::log_error("🦦  нет параметра `task`")
    stop()
  }
  
  if(exists("skill")){
    logger::log_debug("🦦  параметр `skill` есть")  
  } else {
    logger::log_error("🦦  нет параметра `skill`")
    stop()
  }
  
  if(exists("schedule")){
    logger::log_debug("🦦  параметр `schedule` есть")  
  } else {
    logger::log_error("🦦  нет параметра `schedule`")
    stop()
  }
  
  if(exists("ignore")){
    logger::log_debug("🦦  параметр `ignore` есть")  
  } else {
    logger::log_error("🦦  нет параметра `ignore`")
    stop()
  }
  
  if(exists("params")){
    logger::log_debug("🦦  параметр `params` есть")  
  } else {
    logger::log_error("🦦  нет параметра `params`")
    stop()
  }
  
  if(exists("log_message")){
    logger::log_debug("🦦  параметр `log_message` есть")  
  } else {
    logger::log_error("🦦  нет параметра `log_message`")
    stop()
  }
  
  if(file.exists(path_to_tasks)){
    logger::log_debug("🦦  файл с заданиями существует")  
  } else {
    logger::log_error("🦦  нет параметра `log_message`")
    stop()
  }
  
  readr::read_csv(path_to_tasks, show_col_types = FALSE, progress = FALSE) |> 
    colnames() ->
    task_colnames
  
  expected_colnames <- c("id", "task", "хуй", "skill", "schedule", "ignore", "params")
  
  absent_colnames <- expected_colnames[which(!(expected_colnames %in% task_colnames))]
  
  if(length(absent_colnames) == 0){
    logger::log_debug("🦦  в файле с заданиями правильные колонки")  
  } else {
    logger::log_error("🦦  в файле с заданиями нет колонки {absent_colnames}")
    stop()
  }
  
  # начало работы функции ---------------------------------------------------
  
  logger::log_info("🦦  {log_message}")
  
  path_to_tasks |> 
    readr::read_csv(show_col_types = FALSE,
                    progress = FALSE) |> 
    dplyr::bind_rows(
      tibble::tibble(id = 0,
                     task = task,
                     skill = skill,
                     schedule = schedule,
                     ignore = ignore,
                     params = params |> yaml::as.yaml())) |>
    readr::write_csv(file = path_to_tasks, na = "")
  
  logger::log_debug("🦦  Завершение запуска умения `sent_gmail_message`")
}
