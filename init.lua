-- vim.treesitter.language.add('pandoc_markdown', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown.so" })
-- vim.treesitter.language.add('pandoc_markdown_inline', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown-inline.so" })
-- vim.treesitter.language.register('pandoc_markdown', { 'quarto', 'rmarkdown' })

require 'config.global'
require 'config.lazy'
require 'config.autocommands'
require 'config.redir'

-- require 'utils.keys'

vim.cmd.colorscheme 'default'

-- reload colors module if it was already loaded
local mod = 'utils.colors'
if package.loaded[mod] then
  package.loaded[mod] = nil
end

require(mod)
