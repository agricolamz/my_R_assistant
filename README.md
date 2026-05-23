## Rule based personal assistant for R

I would like to use a `cron` starting `assistnat_brain.R` script that will run my assistant. Assistant 

- goes through the list of the tasks;
- evaluates whether it is possible to solve them;
- run predefined scripts (called skills);
- and mark some tasks as solved.

For now I wrote just two meaningful skills, but I plan to write more:

- `add_to_backlog` --- add task to the task list;
- `run_task` --- run task from the task list;
- `sent_gmail_message` --- sent message via `gmailr`;
- `ollama_call` --- post a messages to Ollama and send the result via mail.

## Tasks

Assistant works around simple `.csv` file with the following structure.

- `tasks/tasks.csv` --- `.csv` file with tasks. Possible fields are:
  - `id` --- id number. Should be different for different tasks.
  - `task` --- task name. Appears only in logs/mails etc.
  - `skill` --- name from the `skills` folder.
  - `schedule` --- if `once` then task will be removed from the `task.csv` after completion.
  - `ignore` --- this task is ignored. It is made for the problems detection.
  - `params` --- `.yml` which define skill parameters to start with.

## Secrets

Store your secrets outside the assistant, for example putting in `.Rprofile`:

```
options(my_R_assistant_preferred_out_mail = "put your value here",
        my_R_assistant_preferred_to_mail = "put your value here")
```

It makes sense to put there everything about `gmailr` configuration such as `gmailr::gm_auth_configure()` and `gmailr::gm_auth()` functions.