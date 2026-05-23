---
name: "run_task"
description: "Runs task"
params:
  - log_message
  - to
  - subject
  - message
---

- Before using the skill you need to have the following R packages installed:
  - `yaml`;
  - `readr`;
  - `dplyr`;
  - `tibble`;
  - `logger`.
- Before using the skill you need to have the following skills installed:
  - `sent_gmail_message`;
  - `add_to_backlog`.
- Before using the skill you need to set up Google OAuth client, see the [following page](https://gmailr.r-lib.org/articles/oauth-client.html). 
- Check whether all parameters can be filled.
- Check whether the `skill` is available for running.
- If the `skill` is not available run `sent_gmail_message` skill in order to notify user about the problem and use `add_to_backlog` mailing task, if there is no Internet connection.
- Check whether `params` is in the valid yaml format.
- If the `skill` is available through log message from the `log_message` parameter.
- Run the `skill` using `params` parameters.

