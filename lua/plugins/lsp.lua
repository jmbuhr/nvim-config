return {
  {
    'jmbuhr/otter.nvim',
    dev = true,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    ---@type OtterConfig
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          automatic_enable = false,
          ensure_installed = {
            'lua_ls',
            'bashls',
            'cssls',
            'html',
            'pyright',
            'r_language_server',
            'texlab',
            'dotls',
            'svelte',
            'ts_ls',
            'yamlls',
            'clangd',
            -- 'ltex',
            -- 'sqlls',
            -- 'emmet_language_server',
            -- 'hls',
            -- 'julia-lsp'
            -- 'rust-analyzer',
            -- 'marksman',
          },
        },
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
          ensure_installed = {
            'black',
            'stylua',
            'shfmt',
            'isort',
            'tree-sitter-cli',
            'jupytext',
          },
        },
      },
      {
        {
          'folke/lazydev.nvim',
          ft = 'lua',
          opts = {
            library = {
              { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
          },
        },
        { 'Bilal2453/luvit-meta', lazy = true },
      },
      { 'folke/neoconf.nvim', opts = {}, enabled = false },
    },
    config = function()
      local util = require 'lspconfig.util'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local function map(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          assert(client, 'LSP client not found')

          ---@diagnostic disable-next-line: inject-field
          client.server_capabilities.document_formatting = true

          map('gd', vim.lsp.buf.definition, '[g]o to [d]efinition')
          map('gD', vim.lsp.buf.type_definition, '[g]o to type [D]efinition')
          map('<leader>lq', vim.diagnostic.setqflist, '[l]sp diagnostic [q]uickfix')
        end,
      })

      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }

      local capabilities
      local has_blink, blink = pcall(require, 'blink')
      if has_blink then
        capabilities = blink.get_lsp_capabilities({}, true)
      else
        capabilities = vim.lsp.protocol.make_client_capabilities()
      end

      -- set defaults for all clients
      vim.lsp.config('*', {
        capabilities = capabilities,
        flags = lsp_flags,
        root_markers = { '.git/' },
      })

      -- also needs:
      -- $home/.config/marksman/config.toml :
      -- [core]
      -- markdown.file_extensions = ["md", "markdown", "qmd"]
      -- vim.lsp.config.marksman = {
      --   filetypes = { 'markdown', 'quarto' },
      --   root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml'),
      -- }

      vim.lsp.config.r_language_server = {
        filetypes = { 'r', 'rmd', 'rmarkdown' }, -- not directly using it for quarto (as that is handled by otter and often contains more languanges than just R)
        settings = {
          r = {
            lsp = {
              rich_documentation = true,
            },
          },
        },
      }

      vim.lsp.config.yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = '',
            },
          },
        },
      }

      vim.lsp.config.ts_ls = {
        filetypes = { 'js', 'javascript', 'typescript', 'ojs' },
      }

      local function get_quarto_resource_path()
        local function strsplit(s, delimiter)
          local result = {}
          for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
            table.insert(result, match)
          end
          return result
        end

        local f = assert(io.popen('quarto --paths', 'r'))
        local s = assert(f:read '*a')
        f:close()
        return strsplit(s, '\n')[2]
      end

      local lua_library_files = vim.api.nvim_get_runtime_file('', true)
      local lua_plugin_paths = {}
      local resource_path = get_quarto_resource_path()
      if resource_path == nil then
        vim.notify_once 'quarto not found, lua library files not loaded'
      else
        table.insert(lua_library_files, resource_path .. '/lua-types')
        table.insert(lua_plugin_paths, resource_path .. '/lua-plugin/plugin.lua')
      end

      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              disable = { 'trailing-space' },
            },
            workspace = {
              checkThirdParty = false,
            },
            doc = {
              privateName = { '^_' },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      vim.lsp.bashls = {
        filetypes = { 'sh', 'bash' },
      }

      vim.lsp.config.hls = {
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
      }

      -- See https://github.com/neovim/neovim/issues/23291
      -- disable lsp watcher.
      -- Too lags on linux for python projects
      -- because pyright and nvim both create too many watchers otherwise
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      vim.lsp.config.pyright = {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        },
        root_markers = { '.git', 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt' },
      }

      vim.lsp.config.ltex = {
        settings = {
          ltex = {
            language = 'en-US',
            markdown = {
              nodes = {
                CodeBlock = "ignore",
                FencedCodeBlock = "ignore",
              },
            },
            additionalRules = {
              enablePickyRules = false,
              motherTongue = 'de-DE',
            },
            disabledRules = {
              ['en-US'] = { 'FILE_EXTENSIONS_CASE', 'COMMA_PARENTHESIS_WHITESPACE', 'MORFOLOGIK_RULE_EN_US', 'WHITESPACE_RULE', 'UPPERCASE_SENTENCE_START' },
            }
          },
        },
      }

      -- enable the servers
      vim.lsp.enable 'r_language_server'
      vim.lsp.enable 'cssls'
      vim.lsp.enable 'html'
      vim.lsp.enable 'emmet_language_server'
      vim.lsp.enable 'svelte'
      vim.lsp.enable 'jsonls'
      vim.lsp.enable 'texlab'
      -- vim.lsp.enable 'dotls'
      vim.lsp.enable 'ts_ls'
      vim.lsp.enable 'yamlls'
      vim.lsp.enable 'clangd'
      -- vim.lsp.enable 'ltex'
      -- vim.lsp.enable 'marksman'
      -- vim.lsp.enable 'sqlls'
      -- vim.lsp.enable 'hls'
      -- vim.lsp.enable 'julia-lsp'
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'bashls'
      vim.lsp.enable 'pyright'
      vim.lsp.enable 'rust_analyzer'
      -- vim.lsp.enable 'ruff_lsp'

      -- android development
      vim.lsp.enable 'kotlin_language_server'
      vim.lsp.enable 'jdtls'

    end,
  },
}
