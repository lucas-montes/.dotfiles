require("which-key").setup({
  -- "classic" | "modern" | "helix" | false
  preset = "classic",

  -- Delay before showing the popup (ms). Can be a function.
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,

  -- Filter which mappings are shown in the popup
  filter = function(mapping)
    return true
  end,

  -- Add mappings directly in setup
  spec = {},

  -- Show warnings about issues with mappings
  notify = true,

  -- Auto-setup triggers for keypress detection
  triggers = {
    { "<auto>", mode = "nxso" },
  },

  -- Start hidden and wait for key press before showing popup (visual/operator modes)
  defer = function(ctx)
    return ctx.mode == "V" or ctx.mode == "<C-V>"
  end,

  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },

  win = {
    no_overlap = true,
    padding = { 1, 2 },
    title = true,
    title_pos = "center",
    zindex = 1000,
    bo = {},
    wo = {},
  },

  layout = {
    width = { min = 20 },
    spacing = 3,
  },

  keys = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },

  sort = { "local", "order", "group", "alphanum", "mod" },

  expand = 0,

  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
    },
    desc = {
      { "<Plug>%(?(.*)%)?", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
    },
  },

  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
    ellipsis = "…",
    mappings = true,
    rules = {},
    colors = true,
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "󰁮",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
  },

  show_help = true,
  show_keys = true,

  disable = {
    ft = {},
    bt = {},
  },

  debug = false,
})


require("which-key").add {
  { "<leader><leader>", group = "buffer" },
  { "<leader><leader>_", hidden = true },
  { "<leader>c", group = "code" },
  { "<leader>c_", hidden = true },
  { "<leader>d", group = "document" },
  { "<leader>d_", hidden = true },
  { "<leader>g", group = "git" },
  { "<leader>g_", hidden = true },
  { "<leader>m", group = "markdown" },
  { "<leader>m_", hidden = true },
  { "<leader>r", group = "rename" },
  { "<leader>r_", hidden = true },
  { "<leader>s", group = "search" },
  { "<leader>s_", hidden = true },
  { "<leader>t", group = "toggle" },
  { "<leader>t_", hidden = true },
  { "<leader>w", group = "workspace" },
  { "<leader>w_", hidden = true },
  { "<leader>l", group = "LSP" },
  { "<leader>l_", hidden = true },
  { "<leader>x", group = "diagnostics" },
  { "<leader>x_", hidden = true },
}
