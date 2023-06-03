version = '0.21.2'
---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
xplr.config.modes.custom.fzxplr = {
  name = "fzxplr",
  key_bindings = {
    on_key = {
      F = {
        help = "search",
        messages = {
          {
            BashExec = [===[
              PTH=$(cat "${XPLR_PIPE_DIRECTORY_NODES_OUT:?}" | awk -F/ '{print $NF}' | fzf)
              if [ -d "$PTH" ]; then
                "$XPLR" -m 'ChangeDirectory: %q' "$PTH"
              else
                "$XPLR" -m 'FocusPath: %q' "$PTH"
              fi
            ]===]
          },
          "PopMode",
        },
      },
    },
    default = {
      messages = {
        "PopMode",
      },
    },
  },
}

xplr.config.modes.builtin.default.key_bindings.on_key["F"] = {
  help = "fzf mode",
  messages = {
    { SwitchModeCustom = "fzxplr" },
  },
}
