#!/bin/env python3
from tasklib import Task

def main():
    task = Task.from_input()
    if task["state"] == "proj" or "project" in task["tags"]:
        # make sure the project name always matches the description
        task["project"] = task["description"]
    print(task.export_data())

if __name__ == "__main__":
    main()
