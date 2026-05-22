---
name: ollama_call
description: Post a messages to Ollama and send the result via mail
params:
  - ollama_model
  - ollama_message
---

- Before using the skill you need to have the following R packages installed:
  - `ollamar`;
  - `utils`;
  - `logger`.
- Before using the skill you need to have the following skills installed:
  - `sent_gmail_message`;
  - `add_to_backlog`.
- Check whether all parameters can be filled.
- Check whether Ollama is running.
- Check whether the model from `ollama_model` is present in the system.
- Generate the Ollama response using `ollama_model` and `ollama_message`, don't foget to set response process to "text".
- Check the Internet connection.
- Send the Ollama reponse via mail using the `sent_gmail_message` skill.