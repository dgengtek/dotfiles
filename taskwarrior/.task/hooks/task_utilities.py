#!/bin/env python3
import task_tags_relation_mapping as taskmap
import sys


def canonize_task(task):
    try:
        tags = set(task["tags"])
    except TypeError:
        tags = set()

    tags_to_check = tags.copy()
    while tags_to_check:
        tag = tags_to_check.pop().lower()
        relation = taskmap.tag_relations.get(tag, "")
        stags = taskmap.get_tag_mapping(
            {
                tag,
            },
            taskmap.tag_alias_map,
        )
        if not tags.issuperset(stags):
            tags_to_check = tags_to_check.union(stags)
            tags = tags.union(stags)
        if relation and not tags.issuperset(relation):
            tags_to_check = tags_to_check.union(relation)
            tags = tags.union(relation)
    task["tags"] = list(tags)
    return task
