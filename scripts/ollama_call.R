suppressMessages(library(ollamar))

log_info("🦙  Скрипт по вызову Ollama запущен")

ollamar::test_connection(logical = TRUE) |> 
  stopifnot("🦙  Ollama не запущена" = _)
log_info("🦙  Ollama запущена")

ollamar::model_avail(ollama_model) |> 
  stopifnot("🦙  Модели нет в списке доступных моделей" = _)
log_info("🦙  Модель {ollama_model} есть в списке доступных моделей")
log_info("🦙  Жду ответа от Ollama")
ollama_message |>
  ollamar::generate(model = ollama_model) |>
  ollamar::resp_process("text") ->
  result

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
  log_info("🦦  Интернета нет, так что я не отправил ответа модели")
}
