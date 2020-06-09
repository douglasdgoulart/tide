function _tide_pwd_var_change -v PWD
    set -l blah_pwd (string replace $HOME '~' $PWD)
    set -l blah_split_pwd (string split --no-empty '/' $blah_pwd)

    set -g _tide_split_pwd $blah_split_pwd[(math -$tide_pwd_max_dirs)..-1]
    set -g _tide_pwd (string join '/' $_tide_split_pwd)

    set -g _tide_git_dir (git rev-parse --show-toplevel 2>/dev/null)

    set -g _tide_pwd_anchors

    if contains 'first' $tide_pwd_anchors
        set -a _tide_pwd_anchors $_tide_split_pwd[1]
    end
    if contains 'last' $tide_pwd_anchors
        set -a _tide_pwd_anchors $_tide_split_pwd[-1]
    end
    if contains 'git' $tide_pwd_anchors
        set -a _tide_pwd_anchors (string replace $HOME '~' $_tide_git_dir | string split --no-empty -r -m1 '/')
    end

    _tide_pwd
end