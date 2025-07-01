#!/usr/bin/env python3

import sys

from i3ipc import Connection



i3 = Connection()

workspaces = i3.get_workspaces()
focused_workspace = [w for w in workspaces if w.focused][0]
output = focused_workspace.output


option = sys.argv[1]
workspace_id = sys.argv[2]


out_idd = str(output).split('-')[1]
workspace_name = f"{out_idd}:{workspace_id}"
# print(f"Workspace name: {workspace_name}")

if option == 'move':
    # Move the focused window to the specified workspace
    i3.command(f'move container to workspace "{workspace_name}"')
elif option == 'to':
    # Focus the specified workspace
    i3.command(f'workspace "{workspace_name}"')
