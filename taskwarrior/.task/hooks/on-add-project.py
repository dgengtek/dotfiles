#!/bin/env python3
import tasklib
import intent_manager


def main():
    tw = tasklib.TaskWarrior()
    task = tasklib.Task.from_input()

    if intent_manager.utilities.task_is_project(task):
        # make sure the project name always matches the description
        task["project"] = task["description"]
    elif task["project"] and not task.deleted:
        project_tasks = tw.tasks.filter("+project and project:'{}'".format(
            task["project"]))
        if not project_tasks:
            # create a new project task if this task was created quickly for inbox
            new_project_task = intent_manager.utilities.get_project_from_task(tw, task)
            new_project_task.save()
            print("--created project task: ", intent_manager.utilities.print_task_oneline(new_project_task))
            if not new_project_task.saved:
                print("Could not create new project task: {}".format(
                    intent_manager.utilities.print_task_detailed(new_project_task)))
                return

    print(task.export_data())


if __name__ == "__main__":
    main()
