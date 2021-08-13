function fish_prompt
end

status is-interactive || exit

_tide_remove_unusable_items

set -g _tide_prompt_var _tide_prompt_$fish_pid

function _tide_refresh_prompt --on-variable $_tide_prompt_var
    set -g _tide_self_repainting # prevents us from creating a second background job
    set -g _tide_prompt_data $$_tide_prompt_var # First element in _tide_prompt_data is 'actual' right prompt
    commandline --function repaint
end

function fish_prompt
    _tide_last_status=$status _tide_last_pipestatus=$pipestatus if not set -e _tide_self_repainting
        jobs --query
        fish --command "_tide_jobs_status=$status CMD_DURATION=$CMD_DURATION COLUMNS=$COLUMNS \
            fish_bind_mode=$fish_bind_mode set -U $_tide_prompt_var (_tide_prompt)" &
        builtin disown

        command kill $_tide_last_pid 2>/dev/null
        set -g _tide_last_pid $last_pid
    end

    test "$tide_prompt_add_newline_before" = true && echo
    string unescape $_tide_prompt_data[2..]
end

function _tide_on_fish_exit --on-event fish_exit
    set -e $_tide_prompt_var $_tide_right_prompt_display_var
end
