#!/usr/bin/env python3

import sys

from i3ipc import Connection



i3 = Connection()

workspaces = i3.get_workspaces()
focused_workspace = [w for w in workspaces if w.focused][0]
output = focused_workspace.output


option = sys.argv[1]
workspace_name = sys.argv[2]

out_mapping = {
    'HDMI-0': '2',
    'HDMI-1': '1',
}

# See i3/config for more info on workspace naming
ws_mapping = {
    'x': '00',
    '1': '01',
    '2': '02',
    '3': '03',
    '4': '04',
    '5': '05',
    '6': '06',
    '7': '07',
    '8': '08',
    '9': '09',
    '0': '10',
    'n': '11',
    'm': '12',
    'g': '13',
    'u': '14',
}

out_id = out_mapping.get(output, '1')
workspace_id = f"{out_id}{ws_mapping[workspace_name]}"
# Remove leading zeros for workspace ID
workspace_id = workspace_id.lstrip('0')
full_workspace_name = f"{workspace_id}:{workspace_name}"


if option == 'move':
    # Move the focused window to the specified workspace
    i3.command(f'move container to workspace "{full_workspace_name}"')
elif option == 'to':
    # Focus the specified workspace
    i3.command(f'workspace "{full_workspace_name}"')
