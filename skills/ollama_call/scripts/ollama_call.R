#' @param ollama_model Specifies an Ollama model to call.
#' @param ollama_message Text of the prompt.
#' 
#' @importFrom logger log_debug
#' @importFrom logger log_error
#' @importFrom utils installed.packages
#' @importFrom ollamar test_connection
#' @importFrom ollamar model_avail

ollama_call <- function(ollama_model = "gemma4b26",
                        ollama_message){
  
  logger::log_debug("🦦  Запуск умения `ollama_call`")
  
  # проверка параметров -----------------------------------------------------
  
  packages <- c("ollamar", "utils", "logger")
  
  if(sum(packages  %in% utils::installed.packages()) == length(packages)){
    logger::log_debug("🦙  Все необходимые пакеты установлены.")  
  } else {
    logger::log_error("🦙  Один из следующих пакетов не установлен: {packages}")
    stop()
  }
  
  skills <- c("sent_gmail_message")
  
  if(sum(skills |> map_lgl(exists)) == length(skills)){
    logger::log_debug("🦙  Все необходимые умения есть.")  
  } else {
    logger::log_error("🦙  Один из следующих умений не установлен: {skills}")
    stop()
  }

  if(exists("ollama_model")){
    logger::log_debug("🦙  параметр `ollama_model` есть")  
  } else {
    logger::log_error("🦙  нет параметра `ollama_model`")
    stop()
  }
  
  if(exists("ollama_message")){
    logger::log_debug("🦙  параметр `ollama_message` есть")  
  } else {
    logger::log_error("🦙  нет параметра `ollama_message`")
    stop()
  }
  
  if(ollamar::test_connection(logical = TRUE)){
    logger::log_debug("🦙  Ollama запущена")  
  } else {
    logger::log_error("🦙  Ollama не запущена")
    stop()
  }
  
  if(ollamar::model_avail(ollama_model)){
    logger::log_debug("🦙  Модель {ollama_model} есть в списке доступных моделей")  
  } else {
    logger::log_error("🦙  Модели {ollama_model} нет в списке доступных моделей")
    stop()
  }
  
  # вызов функции -----------------------------------------------------------
  
  ollama_message |>
    ollamar::generate(model = ollama_model) |>
    ollamar::resp_process("text") ->
    result
  
  # отправка результата на почту --------------------------------------------
  
  if(curl::has_internet()){
    sent_gmail_message(log_message = "Отправляю письмо с ответом модели",
                       subject = "Ответ модели Ollama",
                       message = str_glue("Вот ответ модели:\n\n{result}\n\n---\n\n### Промпт\n\n{ollama_message}"))
  } else {
    logger::log_warning("🦦  Нет интернет соединения, так что я не отправил ответа модели")
    logger::log_info("🦦   Добавляю отправку письма с ответом модели в список задач")
  }
  
  logger::log_debug("🦦  Завершение запуска умения `ollama_call`")
}
