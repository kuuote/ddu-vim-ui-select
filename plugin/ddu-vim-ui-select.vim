lua << EOF
  vim.ui = vim.ui or {}
  vim.ui.select = function(...)
    vim.ui.select = require('ddu-vim-ui-select').select
    vim.ui.select(...)
  end
EOF
