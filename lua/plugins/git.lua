-- git plugins

return {
  -- { 'sindrets/diffview.nvim' },
  {
    'esmuellert/vscode-diff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    keys = {
      { '<leader>gd', ':CodeDiff<cr>', desc = '[G]it [D]iff' },
    },
    opts = {
      diff = {
        disable_inlay_hints = true,
        max_computation_time_ms = 5000,
      },
    },
  },

  -- handy git ui
  {
    'NeogitOrg/neogit',
    lazy = true,
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', ':Neogit<cr>', desc = 'neo[g]it' },
    },
    opts = {
      disable_commit_confirmation = true,
      integrations = {
        diffview = false,
      },
      mappings = {
        popup = {
          ['L'] = false,
          ['H'] = false,
        },
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    opts = {},
  },
  {
    'spacedentist/resolve.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'f-person/git-blame.nvim',
    init = function()
      require('gitblame').setup {
        enabled = false,
      }
      vim.g.gitblame_display_virtual_text = 1
      -- vim.g.gitblame_enabled = 0
    end,
  },

  { -- github PRs and the like with gh - cli
    'pwntester/octo.nvim',
    enabled = true,
    cmd = 'Octo',
    config = function()
      require('octo').setup()
      vim.keymap.set('n', '<leader>gpl', ':Octo pr list<cr>', { desc = 'octo [p]r list' })
      vim.keymap.set('n', '<leader>gpr', ':Octo review start<cr>', { desc = 'octo [r]eview' })
    end,
  },
}
