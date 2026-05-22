---
name: "sent_gmail_message"
description: "Sent message via `gmailr`"
params:
  - log_message
  - to
  - subject
  - message
---

- Before using the skill you need to have the following R packages installed:
  - `logger`;
  - `gmailr`;
  - `stringr`;
  - `litedown`;
  - `gmailr`.
- Before using the skill you need to set up Google OAuth client, see the [following page](https://gmailr.r-lib.org/articles/oauth-client.html). 
- Before using the skill check the Internet connection.
- Check whether all parameters can be filled.
- Through log message from the `log_message` parameter.
- Render the `message` parameter to the HTML formatl
- Send an email using all parameters: converted to HTML format `message` as body of the mail, `to` as to, `subject` as subject.
