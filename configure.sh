#!/bin/bash

# Unicode characters not rendering
sudo dnf install dejavu-sans-fonts

rsync -a ./ .config/
