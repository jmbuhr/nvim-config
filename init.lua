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

-- use latest treesitter
vim.api.nvim_create_autocmd('FileType', {
  -- pattern = { '<filetype>' },
  callback = function(event)
    local ft = event.match
    -- test if treesitter is available for this filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft 
    local ok = pcall(vim.treesitter.get_parser, event.buf, lang)
    if not ok then
      return
    end
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    -- unfold everything by default
    vim.cmd('normal! zR')

  end,
})

local use_minimal_default_colors = false

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

-- transparent background if needed
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
  highlight CursorLineNr ctermbg=none
  highlight CursorLineNr guibg=none
]]
