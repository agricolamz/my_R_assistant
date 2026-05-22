#' @param ollama_model Specifies an Ollama model to call.
#' @param ollama_message Text of the prompt.

suppressMessages(library(ollamar))

log_info("🦙  Скрипт по вызову Ollama запущен")


# проверка параметров -----------------------------------------------------

log_debug("🦙  проверка параметров")

if(exists("ollama_model")){
  log_debug("🦙  параметр `ollama_model` есть")  
} else {
  log_error("🦙  нет параметра `ollama_model`")
  stop()
}

if(exists("ollama_message")){
  log_debug("🦙  параметр `ollama_message` есть")  
} else {
  log_error("🦙  нет параметра `ollama_message`")
  stop()
}

if(ollamar::test_connection(logical = TRUE)){
  log_debug("🦙  Ollama запущена")  
} else {
  log_error("🦙  Ollama не запущена")
  stop()
}

if(ollamar::model_avail(ollama_model)){
  log_debug("🦙  Модель {ollama_model} есть в списке доступных моделей")  
} else {
  log_error("🦙  Модели {ollama_model} нет в списке доступных моделей")
  stop()
}

# вызов функции -----------------------------------------------------------

ollama_message |>
  ollamar::generate(model = ollama_model) |>
  ollamar::resp_process("text") ->
  result

# отправка результата на почту --------------------------------------------

if(curl::has_internet()){
  log_info("🦦  Отправляю письмо на gmail с ответом модели")

  str_glue("
Привет!

Вот ответ модели:

{result}

🦦
") |>
    litedown::mark() ->
    message_body

  gm_mime() |>
    gm_to("agricolamz+from_bot@gmail.com") |>
    gm_subject("Ответ модели Ollama") |>
    gm_text_body(message_body,
                 content_type = "text/html",
                 charset = "utf-8",
                 encoding = "base64") |>
    gm_send_message()
} else {
  log_error("🦦  Интернета нет, так что я не отправил ответа модели")
  log_info("🦦   Добавляю отправку письма с ответом модели в список задач")
}
