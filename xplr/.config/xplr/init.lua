version = "0.21.9"

local home = os.getenv("HOME")
package.path = home .. "/.config/xplr/plugins/?/init.lua;" .. home .. "/.config/xplr/plugins/?.lua;" .. package.path

---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
---@diagnostic enable
xplr.config.modes.custom.fzxplr = {
	name = "fzxplr",
	key_bindings = {
		on_key = {
			c = {
				help = "search in current directory",
				messages = {
					{
						BashExec = [===[
              PTH=$(cat "${XPLR_PIPE_DIRECTORY_NODES_OUT:?}" | awk -F/ '{print $NF}' | fzf)
              if [ -d "$PTH" ]; then
                "$XPLR" -m 'ChangeDirectory: %q' "$PTH"
              else
                "$XPLR" -m 'FocusPath: %q' "$PTH"
              fi
            ]===],
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

xplr.config.modes.builtin.switch_layout.key_bindings.on_key["t"] = {
	help = "inspect directories with broot print tree",
	messages = {
		"PopMode",
		{ SwitchLayoutCustom = "inspectdir" },
	},
}

xplr.config.general.initial_layout = "default"

xplr.config.layouts.custom.inspectdir = {
	Horizontal = {
		config = {
			constraints = {
				{ Percentage = 60 },
				{ Percentage = 40 },
			},
		},
		splits = {
			"Table",
			"Selection",
		},
	},
}

xplr.config.general.table.header.cols = {
	{ format = "index", style = {} },
	{ format = "path", style = {} },
	{ format = "perm", style = {} },
	{ format = "size", style = {} },
	{ format = "modified", style = {} },
}

xplr.config.general.default_ui.prefix = " "
xplr.config.general.default_ui.suffix = ""

xplr.config.general.focus_ui.prefix = "▍"
xplr.config.general.focus_ui.suffix = ""

xplr.config.general.selection_ui.prefix = "│"
xplr.config.general.selection_ui.suffix = ""

xplr.config.general.focus_selection_ui.prefix = "▌"
xplr.config.general.focus_selection_ui.suffix = ""

xplr.config.general.table.tree = {
	{},
	{},
	{},
}

xplr.config.general.panel_ui.default.borders = { "Top", "Right", "Bottom", "Left" }
xplr.config.general.panel_ui.default.border_type = "Plain"
-- xplr.config.general.panel_ui.default.border_style.fg = "Black"
-- xplr.config.general.panel_ui.default.border_style.bg = "Gray"

require("context-switch").setup()
require("map").setup()

-- local function stat(node)
--   local type = node.mime_essence
--   if node.is_symlink then
--     if node.is_broken then
--       type = "broken symlink"
--     else
--       type = "symlink to: " .. node.symlink.absolute_path
--     end
--   end
-- end
--
--
-- local function render_right_pane(ctx)
--   local n = ctx.app.focused_node
--
--   if n then
--     if n.is_file then
--         BashExec [===[
--             bat n.absolute_path
--             echo "What's your name?"
--
--             read name
--             greeting="Hello $name!"
--             message="$greeting You are inside $PWD"
--
--             "$XPLR" -m "LogSuccess: %q" "$message"
--           ]===]
--     elseif n.is_dir then
--       local listing = list(n.absolute_path, nil, ctx.app.explorer_config)
--       return table.concat(tree_view(listing, ctx.layout_size.height), "\n")
--     else
--       return stat(n)
--     end
--   else
--     return ""
--   end
-- end
--
-- local right_pane = {
--   CustomContent = {
--     body = {
--       DynamicParagraph = {
--         render = "custom.tri_pane.render_right_pane",
--       },
--     },
--   },
-- }
--
--
--   xplr.fn.custom.tri_pane = {}
--   xplr.fn.custom.tri_pane.render_right_pane = render_right_pane
--
--   local layout = {
--     Horizontal = {
--       config = {
--         constraints = {
-- 				{ Percentage = 70 },
-- 				{ Percentage = 30 },
--         },
--       },
--       splits = {
--         "Table",
--         right_pane,
--       },
--     },
--   }
--
--   local full_layout = {
--     Vertical = {
--       config = {
--         constraints = {
--           { Length = 3 },
--           { Min = 1 },
--           { Length = 3 },
--         },
--       },
--       splits = {
--         "SortAndFilter",
--         layout,
--         "InputAndLogs",
--       },
--     },
--   }
--
--   xplr.config.layouts.custom.tri_pane = full_layout

xplr.config.modes.builtin.default.key_bindings.on_key.T = {
	help = "broot navigation",
	messages = {
		{
			BashExec0 = [===[
dir=$(broot --conf "$HOME/.config/broot/conf.hjson;$HOME/.config/broot/selectd.toml")
"$XPLR" -m 'ChangeDirectory: %q' "$dir"
]===],
		},
	},
}

local m = require("command-mode")

-- Setup with default settings
m.setup()

-- Type `:hello-bash` and press enter to know your location
local broot_ls = m.silent_cmd("broot-ls", "Print tree with broot")(m.BashExec([===[
    broot --cmd ':print_tree' -sdp
    read -p "Press enter to continue"
    "$XPLR" -m "LogSuccess: %q" ""
  ]===]))
xplr.config.modes.builtin.default.key_bindings.on_key.b = broot_ls.action

local function stat(node)
	return xplr.util.to_yaml(xplr.util.node(node.absolute_path))
end

local function read(path, height)
	local p = io.open(path)

	if p == nil then
		return nil
	end

	local i = 0
	local res = ""
	for line in p:lines() do
		if line:match("[^ -~\n\t]") then
			p:close()
			return
		end

		res = res .. line .. "\n"
		if i == height then
			break
		end
		i = i + 1
	end
	p:close()

	return res
end

xplr.fn.custom.preview_pane = {}
xplr.fn.custom.preview_pane.render = function(ctx)
	local title = nil
	local body = ""
	local n = ctx.app.focused_node
	if n and n.canonical then
		n = n.canonical
	end

	if n then
		title = { format = n.absolute_path, style = xplr.util.lscolor(n.absolute_path) }
		if n.is_file then
			body = xplr.util.shell_execute("bat", { n.absolute_path }).stdout
		else
			body = stat(n)
		end
	end

	return { CustomParagraph = { ui = { title = title }, body = body } }
end

local preview_pane = { Dynamic = "custom.preview_pane.render" }
local split_preview = {
	Horizontal = {
		config = {
			constraints = {
				{ Percentage = 60 },
				{ Percentage = 40 },
			},
		},
		splits = {
			"Table",
			preview_pane,
		},
	},
}
xplr.config.layouts.custom.split_preview = split_preview
xplr.config.modes.builtin.switch_layout.key_bindings.on_key["p"] = {
	help = "split preview",
	messages = {
		"PopMode",
		{ SwitchLayoutCustom = "split_preview" },
	},
}
