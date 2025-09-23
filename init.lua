-- vim.treesitter.language.add('pandoc_markdown', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown.so" })
-- vim.treesitter.language.add('pandoc_markdown_inline', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown-inline.so" })
-- vim.treesitter.language.register('pandoc_markdown', { 'quarto', 'rmarkdown' })

-- vim.treesitter.language.add('quarto_markdown', { path = "/usr/local/lib/libtree-sitter-markdown.so" })
-- vim.treesitter.language.add('quarto_markdown_inline', { path = "/usr/local/lib/libtree-sitter-markdown-inline.so" })
-- vim.treesitter.language.register('quarto_markdown', { 'quarto', 'rmarkdown' })

require 'config.global'
require 'config.lazy'
require 'config.autocommands'
require 'config.redir'

local use_minimal_default_colors = true

if use_minimal_default_colors then
  vim.cmd.colorscheme 'default'

  -- reload colors module if it was already loaded
  local mod = 'utils.colors'
  if package.loaded[mod] then
    package.loaded[mod] = nil
  end

  require(mod)
else
  vim.cmd.colorscheme 'kanagawa'
end

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight ColorColumn ctermbg=none
  highlight ColorColumn guibg=none
  highlight SignColumn ctermbg=none
  highlight SignColumn guibg=none
  highlight LineNr ctermbg=none
  highlight LineNr guibg=none
  highlight CursorLine ctermbg=none
  highlight CursorLine guibg=none
  highlight CursorLineNr ctermbg=none
  highlight CursorLineNr guibg=none
]]

