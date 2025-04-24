#!/usr/bin/env python3

import i3ipc
import json
from time import strftime, gmtime

SOCKET_FILE_WIN = '/tmp/i3-win.json'
SOCKET_FILE_WOR = '/tmp/i3-wor.json'
MAX_WIN_HISTORY = 16

# with open(SOCKET_FILE_WIN, 'w') as f:
#     json.dump([], f)
with open(SOCKET_FILE_WOR, 'w') as f:
    json.dump([], f)

i3 = i3ipc.Connection()
workspaces = i3.get_workspaces()


def print_separator():
    print('-----')


def print_time():
    print(strftime(strftime("%Y-%m-%d %H:%M:%S", gmtime())))


def print_con_info(con):
    if con:
        print('Id: %s' % con.id)
        print('Name: %s' % con.name)
    else:
        print('(none)')


def on_window(i3, e):
    # print_separator()
    # print('Got window event:')
    # print_time()
    # print('Change: %s' % e.change)
    # print_con_info(e.container)
    with open(SOCKET_FILE_WIN, 'r') as f:
        data = json.load(f)
    if e.change == 'focus':
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
    # print_separator()
    # print('Got workspace event:')
    # print_time()
    # print('Change: %s' % e.change)
    # print('Current:')
    # print_con_info(e.current)
    # print('Old:')
    # print_con_info(e.old)
    with open(SOCKET_FILE_WOR, 'r') as f:
        data = json.load(f)
    if e.change == 'focus':
        output = None
        for w in workspaces:
            if w.name == e.current.name:
                output = w.output
                break
        data.insert(0, (e.current.id, e.current.name, output))
        if len(data) > MAX_WIN_HISTORY:
            data.pop()
    with open(SOCKET_FILE_WOR, 'w') as f:
        json.dump(data, f)


# TODO subscribe to all events

# i3.on('window', on_window)
i3.on('workspace', on_workspace)

i3.main()
