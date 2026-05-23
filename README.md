## This is a setup for an R based assistant

- `tasks/tasks.csv` --- `.csv` file with tasks. Possible fields are:
  - `id` --- id number. Should be different for different tasks.
  - `task` --- task name. Appears only in logs/mails etc.
  - `skill` --- name from the `skills` folder.
  - `schedule` --- if `once` then task will be removed from the `task.csv` after completion.
  - `ignore` --- this task is ignored. It is made for the problems detection.
  - `params` --- `.yml` which define skill parameters to start with.

