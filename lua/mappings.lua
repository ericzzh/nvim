local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them
--[[ remove this line

map("n", "dd", [=[ "_dd ]=], opt)
map("v", "dd", [=[ "_dd ]=], opt)
map("v", "x", [=[ "_x ]=], opt)

 this line too ]]
--

-- OPEN TERMINALS --
-- ZZH Change begin
-- map("n", "<C-l>", [[<Cmd>vnew term://bash <CR>]], opt) -- term over right
-- map("n", "<C-x>", [[<Cmd> split term://bash | resize 10 <CR>]], opt) --  term bottom
-- map("n", "<C-t>t", [[<Cmd> tabnew | term <CR>]], opt) -- term newtab

map("n", "<M-l>", [[<Cmd>vnew term://bash <CR>]], opt) -- term over right
map("n", "<M-x>", [[<Cmd> split term://bash | resize 10 <CR>]], opt) --  term bottom
map("n", "<M-t>t", [[<Cmd> tabnew | term <CR>]], opt) -- term newtab
-- ZZH Change end
-- copy whole file content
map("n", "<C-a>", [[ <Cmd> %y+<CR>]], opt)

-- toggle numbers
map("n", "<leader>n", [[ <Cmd> set nu!<CR>]], opt)

-- Truezen.nvim
map("n", "<leader>z", ":TZAtaraxis<CR>", opt)
map("n", "<leader>m", ":TZMinimalist<CR>", opt)

map("n", "<C-s>", ":w <CR>", opt)
-- vim.cmd("inoremap jh <Esc>")

-- Commenter Keybinding
map("n", "<leader>/", ":CommentToggle<CR>", opt)
map("v", "<leader>/", ":CommentToggle<CR>", opt)

-- map("n", "<C-q>", ":bp<bar>sp<bar>bn<bar>bd! <CR>", opt) ZZH Move the <S-x>

-- compe stuff

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn["compe#complete"]()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

function _G.completions()
    local npairs = require("nvim-autopairs")
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"]("<CR>")
        end
    end
    return npairs.check_break_line_char()
end

--  compe mappings
map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("i", "<CR>", "v:lua.completions()", {expr = true})

-- nvimtree
-- map("n", "<C-n>", ":NvimTreeToggle<CR>", opt) --ZZH DEL
map("n", "<Leader>nt", ":NvimTreeToggle<CR>", opt) --ZZH ADD

-- format code
map("n", "<Leader>fm", [[<Cmd> Neoformat<CR>]], opt)

-- dashboard stuff
map("n", "<Leader>fw", [[<Cmd> Telescope live_grep<CR>]], opt)
map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)

-- Telescope
map("n", "<Leader>gt", [[<Cmd> Telescope git_status <CR>]], opt)
map("n", "<Leader>cm", [[<Cmd> Telescope git_commits <CR>]], opt)
map("n", "<Leader>ff", [[<Cmd> Telescope find_files <CR>]], opt)
map("n", "<Leader>fp", [[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]], opt)
map("n", "<Leader>fb", [[<Cmd>Telescope Buffers<CR>]], opt)
map("n", "<Leader>fh", [[<Cmd>Telescope help_tags<CR>]], opt)
map("n", "<Leader>fo", [[<Cmd>Telescope oldfiles<CR>]], opt)

-- bufferline tab stuff
map("n", "<S-t>", ":tabnew<CR>", opt) -- new tab
-- map("n", "<S-x>", ":bd!<CR>", opt) -- close tab
map("n", "<S-x>", ":bp<bar>sp<bar>bn<bar>bd! <CR>", opt) -- ZZH Add 
-- move between tabs
map("n", "<TAB>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
map("n", "<S-TAB>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)

-- ZZH Add begin
-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- resize with arrows
-- **** Must set the Option key as Meta key in the xterm preference
-- **** Or use iterm2
vim.api.nvim_set_keymap('n', '<M-UP>', ':resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<M-DOWN>', ':resize +2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<M-LEFT>', ':vertical resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<M-RIGHT>', ':vertical resize +2<CR>', {silent = true})

map('n', '<F5>', ":lua require'dap'.continue()<CR>",opt)
map('n', '<F10>', ":lua require'dap'.step_over()<CR>",opt)
map('n', '<F11>', ":lua require'dap'.step_into()<CR>",opt)
map('n', '<F12>', ":lua require'dap'.step_out()<CR>",opt)
map('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>",opt)
map('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",opt)
map('n', '<leader>lp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",opt)
map('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>",opt)
map('n', '<leader>dl', ":lua require'dap'.run_last()<CR>",opt)
-- ZZh Add end
