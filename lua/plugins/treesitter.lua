return {
  {
    'nvim-treesitter/nvim-treesitter',
    dev = false,
    branch = 'main',

    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
          -- Disable entire built-in ftplugin mappings to avoid conflicts.
          -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
          vim.g.no_plugin_maps = true

          -- Or, disable per filetype (add as you like)
          -- vim.g.no_python_maps = true
          -- vim.g.no_ruby_maps = true
          -- vim.g.no_rust_maps = true
          -- vim.g.no_go_maps = true
        end,
        config = function()
          require('nvim-treesitter-textobjects').setup {
            select = {
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
            },
          }

          -- select
          vim.keymap.set({ 'x', 'o' }, 'am', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'x', 'o' }, 'im', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
          end)
          vim.keymap.set({ 'x', 'o' }, 'ac', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
          end)
          vim.keymap.set({ 'x', 'o' }, 'ic', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
          end)
          -- You can also use captures from other query groups like `locals.scm`
          vim.keymap.set({ 'x', 'o' }, 'as', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
          end)

          -- move
          vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@class.inner', 'textobjects')
          end)
          -- You can also pass a list to group multiple queries.
          vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
            require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
          end)
          -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
          vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
          end)

          vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@class.inner', 'textobjects')
          end)

          vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@class.inner', 'textobjects')
          end)

          vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@class.inner', 'textobjects')
          end)
        end,
      },
    },

    run = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ---@diagnostic disable-next-line: missing-fields
      ts.setup {}
      ts.install {
        'r',
        'python',
        'markdown',
        'markdown_inline',
        'julia',
        'bash',
        'yaml',
        'lua',
        'vim',
        'query',
        'vimdoc',
        'latex', -- requires tree-sitter-cli (installed automatically via Mason)
        'html',
        'css',
        'dot',
        'javascript',
        'mermaid',
        'typescript',
      }
    end,
  },
}
