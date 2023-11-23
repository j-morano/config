#!/usr/bin/env python3

import os
from pathlib import Path
import sys
import subprocess
from subprocess import Popen



dirs_only = False
pattern = ""
if len(sys.argv) > 1:
    arg = sys.argv[1]
    if arg == "/":
        dirs_only = True
    else:
        pattern = arg
if len(sys.argv) == 3:
    if dirs_only:
        pattern = sys.argv[2]
    else:
        raise ValueError("Invalid arguments")
if len(sys.argv) > 3:
    raise ValueError("Invalid arguments")


# Get output of fd command
command = ["fd"]
if dirs_only:
    command.append("--type")
    command.append("d")
    if len(pattern) > 0:
        command.append(pattern)
command.append(".")
command.append("/run/media/morano/SW1000")
command.append("/home/morano")
directories = subprocess.run(
    command,
    stdout=subprocess.PIPE,
)

# Feed output to fzf
file = subprocess.run(
    ["fzf"],
    input=directories.stdout,
    stdout=subprocess.PIPE,
).stdout.decode("utf-8").rstrip()


# Open in default file manager detached from current process.
if Path(file).exists() and Path(file) != Path.cwd() and file != "":
    command = []
    # print(file)
    if Path(file).is_dir():
        command.append("/bin/nautilus")
        command.append("--new-window")
    elif file.endswith(".pdf"):
        # Unset environment variable SESSION_MANAGER to avoid
        #   Qt: Session management error: Could not open network socket
        try:
            del os.environ['SESSION_MANAGER']
        except KeyError:
            # It is already unset
            pass
        command.append("/bin/okular")
    else:
        command.append("/bin/wezterm")
        command.append("start")
        command.append("--")
        command.append("/bin/nvim")
    # check if is binary
    command.append(file)
    print(" ".join(command))
    Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
