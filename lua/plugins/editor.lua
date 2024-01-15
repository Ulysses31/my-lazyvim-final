return {
  "telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    {
      "<leader>fP",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
    {
      ";f", -- Lists files in your current working directory, respects .gitignore
      function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          no_ignore = false,
          hidden = true,
        })
      end,
    },
    {
      ";r", -- Search for a string in your current working directory and get results live as you type, respects .gitignore
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep()
      end,
    },
    {
      "\\\\", -- Lists open buffers
      function()
        local builtin = require("telescope.builtin")
        builtin.buffers()
      end,
    },
    {
      ":t", -- Lists available help tags and opens a new window with the relevant help info on <cr>
      function()
        local builtin = require("telescope.builtin")
        builtin.help_tags()
      end,
    },
    {
      ";;", -- Resume the previous telescope picker
      function()
        local builtin = require("telescope.builtin")
        builtin.resume()
      end,
    },
    {
      ";e", -- Lists Diagnostics for all open buffers or a specific buffer
      function()
        local builtin = require("telescope.builtin")
        builtin.diagnostics()
      end,
    },
    {
      ";s", -- Lists Function names, variables, from Treesitter
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
    },
    {
      "sf", -- Open File Browser with the path of the current buffer
      function()
        local telescope = require("telescope")
        local function telescope_buffer_dir()
          return vim.fn.expand("%:p:h")
        end

        telescope.extensions.file_browser.file({
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
        })
      end,
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local fb_actions = require("telescope").extensions.file_browser.actions

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {},
      },
    })
    opts.pickers = {
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
        layout_config = {
          preview_cutoff = 9999,
        },
      },
    }
    opts.extensions = {
      file_browser = {
        theme = "dropdown",
        hijack_netrw = true,
        mappings = {
          ["n"] = {
            ["N"] = fb_actions.create, -- Create a new file
            ["h"] = fb_actions.goto_parent_dir, -- Go to parent directory
            ["/"] = function() -- Enter the insert mode to search files
              vim.cmd("startInsert")
            end,
            ["<C-u>"] = function(prompt_bufnr) -- Move the selection 10 lines up
              for i = 1, 10 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            ["<C-d>"] = function(prompt_bufnr) -- Move the selection 10 lines down
              for i = 1, 10 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            ["<PageUp>"] = actions.preview_scrolling_up, -- Scroll up the preview pane
            ["<PageDown>"] = actions.preview_scrolling_down, -- Scroll down the preview pane
          },
        },
      },
    }
    telescope.setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
  end,
}
