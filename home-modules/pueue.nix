{ config, options, lib, inputs, pkgs, ... }:
{
  services.pueue = {
    enable = true;
    settings =
      {
        client = {
          restart_in_place = false;
          read_local_logs = true;
          show_confirmation_questions = false;
          show_expanded_aliases = false;
          dark_mode = false;
          max_status_lines = null;
          status_time_format = "%H:%M:%S";
          status_datetime_format = "%Y-%m-%d\n%H:%M:%S";
        };

        daemon = {
          default_parallel_tasks = 1;
          pause_group_on_failure = false;
          pause_all_on_failure = false;
          callback = "notify-send -u critical \"Task {{ id }}\nCommand: {{ command }}\nPath: {{ path }}\nFinished with status '{{ result }}'\nTook: $(bc <<< \"{{end}} - {{start}}\") seconds\"";
          callback_log_lines = 10;
          groups = {
            alarm = 1000;
            default = 1000;
            pomodoro = 1;
            q = 1;
          };
        };

        shared = {
          use_unix_socket = true;
        };
      };
  };
}
