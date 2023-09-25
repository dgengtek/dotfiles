#!/bin/env python3
import tasklib
import intent_manager


def main():
    tw = tasklib.TaskWarrior()
    task = tasklib.Task.from_input()

    if intent_manager.utilities.task_is_project(task):
        # make sure the project name always matches the description
        task["project"] = task["description"]
    else:
        # no project set, ignore
        if not task["project"]:
            print(task.export_data())
            return
        # get project with filter, if none add new task with project
        tasks = tw.tasks.filter(
            "+project", description=task["project"], project=task["project"]
        )
        # there exists already a project task for this project exit
        if tasks:
            print(task.export_data())
            return

        # no project task with that project name found, add a new one
        new_task = tasklib.Task(tw)
        new_task["project"] = task["project"]
        new_task["description"] = task["project"]
        new_task["tags"] = task["tags"].union(["project"])
        new_task["state"] = "pending"
        new_task.save()

    print(task.export_data())


if __name__ == "__main__":
    main()
