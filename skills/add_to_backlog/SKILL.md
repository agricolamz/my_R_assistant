---
name: add_to_backlog
description: Add task to the current task list
params:
  - task
  - skill
  - schedule
  - ignore
  - params
  - path_to_tasks
  - log_message
---

- Before using the skill you need to have the following R packages installed:
  - `yaml`;
  - `readr`;
  - `dplyr`;
  - `tibble`;
  - `logger`.
- Check whether all parameters can be filled.
- Check whether the file with tasks from the `path_to_tasks` exists.
- Check whether the file with tasks is a `.csv` file with the following columns:
  - `id`
  - `task`
  - `skill`
  - `schedule`
  - `ignore`
  - `params`
- Through log message from the `log_message` parameter.
- Calculate a `new_id` variable with sum of all `id` values from the task file + 1.
- Add new line to the file with tasks filling from the skill's parameters.
