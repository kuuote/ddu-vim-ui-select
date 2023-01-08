lua << EOF
  vim.ui = vim.ui or {}
  vim.ui.select = require("ddu-vim-ui-select").select
EOF
