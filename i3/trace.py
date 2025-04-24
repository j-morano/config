#!/usr/bin/env python3

import json
# import os

import i3ipc

from utils import SOCKET_FILE_WIN, SOCKET_FILE_WOR, MAX_WIN_HISTORY



with open(SOCKET_FILE_WIN, 'w') as f:
    json.dump([], f)
with open(SOCKET_FILE_WOR, 'w') as f:
    json.dump({}, f)

i3 = i3ipc.Connection()
workspaces = i3.get_workspaces()



def on_window(i3, e):
    with open(SOCKET_FILE_WIN, 'r') as f:
        data = json.load(f)
    if e.change == 'focus':
        if e.container.id in data:
            data.remove(e.container.id)
        data.insert(0, e.container.id)
        if len(data) > MAX_WIN_HISTORY:
            data.pop()
    if e.change == 'close':
        try:
            data.remove(e.container.id)
        except ValueError:
            pass
    with open(SOCKET_FILE_WIN, 'w') as f:
        json.dump(data, f)


def on_workspace(i3, e):
    with open(SOCKET_FILE_WOR, 'r') as f:
        data = json.load(f)
    if e.change == 'focus':
        output = None
        old_output = None
        for w in workspaces:
            if w.name == e.current.name:
                output = w.output
            elif w.name == e.old.name:
                old_output = w.output
        # os.system(f'notify-send "current:{output}, old:{old_output}"')
        if output is None:
            output = old_output
        if ((old_output != output)
            and (None not in [output, old_output])
        ):
            # Scratchpad or empty workspaces
            return
        data[output] = [e.old.id, e.old.name]
    with open(SOCKET_FILE_WOR, 'w') as f:
        json.dump(data, f)



i3.on('window', on_window)
i3.on('workspace', on_workspace)

i3.main()
