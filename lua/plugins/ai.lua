return {

  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ 'n', 'x' }, '<leader>aO', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ao', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 't' }, '<leader>at', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })

      vim.keymap.set({ 'n', 'x' }, 'go', function()
        return require('opencode').operator '@this '
      end, { desc = 'Add range to opencode', expr = true })
      vim.keymap.set('n', 'goo', function()
        return require('opencode').operator '@this ' .. '_'
      end, { desc = 'Add line to opencode', expr = true })

      vim.keymap.set('n', '<S-C-f>', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<S-C-b>', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'Scroll opencode down' })
    end,
  },

  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    enabled = true,
    opts = {},
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      { '<leader>ac', '<cmd>ClaudeCodeSend<cr><cmd>ClaudeCode<cr>', mode = 'v', desc = 'Send to Claude & Open Chat' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
  { -- gh copilot
    'zbirenbaum/copilot.lua',
    enabled = true,
    event = 'InsertEnter',
    cmd = { 'Copilot' },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<c-a>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      filetypes = {
        markdown = false,
        quarto = function()
          -- disable if file is index.qmd and directory is phd-thesis
          local filename = vim.fn.expand '%:t'
          local dir = vim.fn.expand '%:p:h:t'
          if filename == 'index.qmd' and dir == 'phd-thesis' then
            return false
          else
            return true
          end
        end,
      },
      panel = { enabled = false },
    },
  },

  { -- LLMs
    'olimorris/codecompanion.nvim',
    version = '*',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      -- { '<leader>ac', ':CodeCompanionChat Toggle<cr>', desc = '[a]i [c]hat' },
      -- { '<leader>aa', ':CodeCompanionActions<cr>', desc = '[a]i [a]actions' },
    },
    config = function()
      require('codecompanion').setup {
        display = {
          diff = {
            enabled = true,
          },
        },
        strategies = {
          chat = {
            -- adapter = "ollama",
            adapter = 'copilot',
          },
          inline = {
            -- adapter = "ollama",
            adapter = 'copilot',
          },
          agent = {
            -- adapter = "ollama",
            adapter = 'copilot',
          },
        },
      }
    end,
  },
}
