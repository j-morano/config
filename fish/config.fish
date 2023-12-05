if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_mode_prompt; end

set -U fish_greeting

# Rust utilities to PATH
set PATH $HOME/.cargo/bin $PATH

# Add standard .local/bin to PATH
set PATH $HOME/.local/bin $PATH

# Set locale to avoid issues with some non-ascii chars
set -gx  LC_ALL en_US.UTF-8

set TERM xterm-256color

set IPYTHONDIR $HOME/.config/ipython
