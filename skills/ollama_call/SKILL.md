---
name: ollama_call
description: Sent message via `gmailr`
params:
  - log_message
  - to
  - subject
  - message
---

- Before using the skill you need to go
- Before using the skill check the Internet connection.
- Check whether all parameters can be filled.
- Through log message from the `log_message` parameter
- Render the `message` parameter to the HTML format
- Send an email using all parameters: converted to HTML format `message` as body of the mail, `to` as to, `subject` as subject
