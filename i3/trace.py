#!/usr/bin/env python3

import json
import os

import i3ipc

from utils import SOCKET_FILE_WOR, SOCKET_FILE_WIN, MAX_HISTORY


def init_win_file():
    with open(SOCKET_FILE_WIN, 'w') as f:
        json.dump([], f)


def init_wor_file():
    with open(SOCKET_FILE_WOR, 'w') as f:
        json.dump({}, f)


def on_window(i3, e):
    if not os.path.exists(SOCKET_FILE_WIN):
        init_win_file()
    with open(SOCKET_FILE_WIN, 'r') as f:
        data = json.load(f)
    if e.change == 'focus':
        if e.container.id in data:
            data.remove(e.container.id)
        data.insert(0, e.container.id)
        if len(data) > MAX_HISTORY:
            data.pop()
    if e.change == 'close':
        try:
            data.remove(e.container.id)
        except ValueError:
            pass
    with open(SOCKET_FILE_WIN, 'w') as f:
        json.dump(data, f)


def on_workspace(i3, e):
    if not os.path.exists(SOCKET_FILE_WOR):
        init_wor_file()
    with open(SOCKET_FILE_WOR, 'r') as f:
        data = json.load(f)
    if e.change == 'focus':
        output = None
        old_output = None
        if e.current.name.startswith('__') or e.old.name.startswith('__'):
            return
        for w in i3.get_workspaces():
            if w.name == e.current.name:
                output = w.output
            elif w.name == e.old.name:
                old_output = w.output
        # os.system(f'notify-send "current:{output}, old:{old_output}"')
        if output is None:
            output = old_output
        elif old_output is None:
            old_output = output
        if old_output == output:
            if old_output not in data:
                data[old_output] = []
            data[old_output].insert(0, [e.old.id, e.old.name])
            if len(data[old_output]) > MAX_HISTORY:
                data[old_output].pop()
        else:
            return
    with open(SOCKET_FILE_WOR, 'w') as f:
        json.dump(data, f)


if __name__ == '__main__':
    i3 = i3ipc.Connection()

    init_win_file()
    init_wor_file()

    i3.on('window', on_window)
    i3.on('workspace', on_workspace)

    i3.main()
