local M = {}

M.config = function()
    function on_attach(client, bufnr)
        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        local opts = {noremap = true, silent = true}

	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
	buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
	buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>Telescope lsp_code_actions<cr>', opts)
	buf_set_keymap('v', '<space>cr', "<cmd>'<,'> lua vim.lsp.buf.range_code_action()<cr>", opts)
	buf_set_keymap('n', '<space>es', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '<space>el', '<cmd>Telescope lsp_document_diagnostics<cr>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap("n", "<space>lo", '<cmd>Telescope lsp_document_symbols<cr>', opts)
	buf_set_keymap("n", "<space>lwo", '<cmd>Telescope lsp_workspace_symbols<cr>', opts)
    end

    local function setup_servers()
--         require "lspinstall".setup()
-- 
        local lspconf = require("lspconfig")
--         local servers = require "lspinstall".installed_servers()

        local servers = {'gopls', 'tsserver'}
        for _, lang in ipairs(servers) do
            if lang ~= "lua" then
                lspconf[lang].setup {
                    on_attach = on_attach,
                    root_dir = vim.loop.cwd
                }
            elseif lang == "lua" then
                lspconf[lang].setup {
                    on_attach = on_attach,
                    root_dir = vim.loop.cwd,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {"vim"}
                            },
                            workspace = {
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                                }
                            },
                            telemetry = {
                                enable = false
                            }
                        }
                    }
                }
            end
        end
    end

    setup_servers()

    -- -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
    -- require "lspinstall".post_install_hook = function()
    --     setup_servers() -- reload installed servers
    --     vim.cmd("bufdo e") -- triggers FileType autocmd that starts the server
    -- end

    -- replace the default lsp diagnostic letters with prettier symbols
    vim.fn.sign_define("LspDiagnosticsSignError", {text = "???", numhl = "DiagnosticError"})
    vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "???", numhl = "DiagnosticWarn"})
    vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "???", numhl = "DiagnosticInfo"})
    vim.fn.sign_define("LspDiagnosticsSignHint", {text = "???", numhl = "DiagnosticHint"})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = false,
    -- Enable virtual text, override spacing to 4
    virtual_text = false,
    -- Use a function to dynamically turn signs off
    -- and on, using buffer local variables
    -- signs = function(bufnr, client_id)
    --   return vim.bo[bufnr].show_signs == false
    -- end,
    -- Disable a feature
    -- update_in_insert = false,
  }
)
return M
