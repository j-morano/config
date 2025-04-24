#!/usr/bin/env python3

"""
This script has different modes:
    - "promote": Promotes the focused window by swapping it with the
        master window (the leftmost window).
    - "focus": Focuses the leftmost window. If the leftmost window is
        already focused, then focuses the window to the right of
        the leftmost window.
    - "next": if the layout is tabbed, then focuses the next window.
        Otherwise, focuses the window below the focused window.
    - "prev": if the layout is tabbed, then focuses the previous window.
        Otherwise, focuses the window above the focused window.
    - "next-container": focuses the next first-level container.
    - "prev-container": focuses the previous first-level container.
    - "prev-workspace": focuses the previous workspace in the same
        output. The previous workspace is the one that was last
        focused. See the "trace.py" script for more information.

Copyright: 2023 José Morano
License: MIT

Dependencies: python-i3ipc>=2.0.1 (i3ipc-python)
"""

import sys
# import os
import json

from i3ipc import Connection, Con


from utils import SOCKET_FILE_WIN, SOCKET_FILE_WOR


def find_master(container, mark):
    master = None
    second = None
    previous = None
    focused = None
    for leaf in container.leaves():
        if not master:
            master = leaf
        elif master and not second:
            second = leaf
        if leaf.focused:
            focused = leaf
        if mark in leaf.marks:
            previous = leaf
    if not previous:
        previous = second
    return master, focused, previous


option = sys.argv[1]

i3 = Connection()

root = i3.get_tree()
focused = root.find_focused()
assert focused is not None
workspace = focused.workspace()
assert isinstance(workspace, Con)
layout = focused.parent.layout
workspaces = i3.get_workspaces()
output = None
for w in workspaces:
    if w.name == workspace.name:
        output = w.output
        break


if option == 'next' or option == 'prev':
    # os.system("notify-send 'next'")
    focus_next_leaf = False
    if option == 'prev':
        leaves = reversed(workspace.leaves())
    else:
        leaves = workspace.leaves()
    current_container_leaves = []
    for leaf in leaves:
        if focused.parent == leaf.parent:
            current_container_leaves.append(leaf)
    for leaf in current_container_leaves:
        # os.system(f"notify-send 'len {len(workspace.leaves())}'")
        if focus_next_leaf and focused.parent == leaf.parent:
            leaf.command("focus")
            exit(0)
        if leaf.focused:  #type: ignore
            focus_next_leaf = True
    current_container_leaves[0].command("focus")
elif option == 'next-container' or option == 'prev-container':
    containers = []
    for leaf in workspace.leaves():
        if leaf.parent not in containers:
            containers.append(leaf.parent)
    if len(containers) < 2:
        if option == 'next-container':
            i3.command(f"focus right")
        else:
            i3.command(f"focus left")
    else:
        focus_next_container = False
        assert isinstance(containers, list)
        focused_index = 0
        for focused_index, container in enumerate(containers):
            if focused.parent == container:
                break
        if option == 'next-container':
            target_index = (focused_index + 1) % len(containers)
        else:
            target_index = (focused_index - 1) % len(containers)
        # Get the focused child of the target container
        container = containers[target_index]
        # The focus stack for this container as a list of container
        #  ids. The “focused inactive” is at the top of the list which
        #  is the container that would be focused if this container
        #  recieves focus.
        i3.command(f"[con_id=\"{container.focus[0]}\"] focus")
elif option == 'last-workspace':
    # os.system("notify-send 'prev-workspace'")
    with open(SOCKET_FILE_WOR, 'r') as f:
        data = json.load(f)
    w_id, w_name = data[output]
    i3.command(f"workspace \"{w_name}\"")
elif option == 'last-window':
    with open(SOCKET_FILE_WIN, 'r') as f:
        data = json.load(f)
    if len(data) > 1:
        i3.command(f"[con_id=\"{data[1]}\"] focus")
else:
    prev_mark = workspace.name  # type: ignore
    master, focused, previous = find_master(workspace, prev_mark)
    assert master is not None and focused is not None and previous is not None
    if previous.id == focused.id == master.id:
        i3.command(f"focus right")
    elif focused.id == master.id:
        # Focus the previous window (the one with 'p' mark),
        #   to replace master window with it.
        i3.command(f"[con_id=\"{previous.id}\"] focus")
    if option == "promote":
        # Mark master window as previous ('p'), since it will be
        #   replaced.
        i3.command(f"[con_id=\"{master.id}\"] mark {prev_mark}")
        i3.command(f"swap container with con_id {master.id}")
    elif option == "focus":
        if focused.id == master.id:
            # Mark master window as previous.
            i3.command(f"[con_id=\"{master.id}\"] mark {prev_mark}")
        else:
            # Mark focused window as previous and focus master.
            i3.command(f"[con_id=\"{focused.id}\"] mark {prev_mark}")
            i3.command(f"[con_id=\"{master.id}\"] focus")
