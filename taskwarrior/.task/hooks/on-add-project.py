#!/bin/env python3
import tasklib
import intent_manager


def main():
    tw = tasklib.TaskWarrior()
    task = tasklib.Task.from_input()

    if intent_manager.utilities.task_is_project(task):
        # make sure the project name always matches the description
        task["project"] = task["description"]

    print(task.export_data())


if __name__ == "__main__":
    main()
