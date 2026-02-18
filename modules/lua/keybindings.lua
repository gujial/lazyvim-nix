-- 设置 leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 基础快捷键配置
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 窗口导航
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- 窗口大小调整
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- 缓冲区导航
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- DAP 调试快捷键
local dap = require("dap")
keymap("n", "<F5>", function() dap.continue() end, vim.tbl_extend("force", opts, { desc = "DAP Continue" }))
keymap("n", "<F10>", function() dap.step_over() end, vim.tbl_extend("force", opts, { desc = "DAP Step Over" }))
keymap("n", "<F11>", function() dap.step_into() end, vim.tbl_extend("force", opts, { desc = "DAP Step Into" }))
keymap("n", "<S-F11>", function() dap.step_out() end, vim.tbl_extend("force", opts, { desc = "DAP Step Out" }))
keymap("n", "<leader>db", function() dap.toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
keymap("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, vim.tbl_extend("force", opts, { desc = "Conditional Breakpoint" }))
keymap("n", "<leader>dc", function() dap.clear_breakpoints() end, vim.tbl_extend("force", opts, { desc = "Clear Breakpoints" }))
keymap("n", "<leader>dr", function() dap.repl.open() end, vim.tbl_extend("force", opts, { desc = "Open REPL" }))
keymap("n", "<leader>dl", function() dap.run_last() end, vim.tbl_extend("force", opts, { desc = "Run Last" }))
