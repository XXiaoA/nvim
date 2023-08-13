local mason_lspconfig = require("utils").require("mason-lspconfig")
local lspconfig = require("utils").require("lspconfig")
if not mason_lspconfig or not lspconfig then
    return
end

-- set diagnostic icons for signcolumn
local diagnostic_icon = require("utils.lspkind").diagnostic
for name, icon in pairs(diagnostic_icon) do
    local sign_name = "DiagnosticSign" .. name
    vim.fn.sign_define(sign_name, { texthl = sign_name, text = icon, numhl = "" })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { underline = true, update_in_insert = false }
)

vim.diagnostic.config({
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = {
        spacing = 4,
        prefix = "●",
    },
    float = {
        focusable = false,
        style = "minimal",
        border = "single",
        source = "always",
        header = "",
        prefix = "",
    },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
})

local function on_attach(client, bufnr)
    require("config.lsp.attach").on_attach(client, bufnr)
end

local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

local servers = {
    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
        },
        capabilities = { offsetEncoding = "utf-8" },
    },

    lua_ls = {
        settings = {
            Lua = {
                hint = {
                    enable = true,
                    arrayIndex = "Disable",
                    paramName = "Literal",
                    setType = true,
                },
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library",
                    },
                },
                telemetry = { enable = false },
            },
        },
    },
}

local setup = {
    ["rust_analyzer"] = function(_, opts)
        require("rust-tools").setup({
            server = opts,
            tools = {
                inlay_hints = {
                    auto = false,
                },
            },
        })
        return true
    end,

    clangd = function(_, opts)
        require("clangd_extensions").setup({
            server = opts,
            memory_usage = {
                border = "rounded",
            },
            symbol_info = {
                border = "rounded",
            },
            ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                    type = "",
                    declaration = "",
                    expression = "",
                    specifier = "",
                    statement = "",
                    ["template argument"] = "",
                },
                kind_icons = {
                    Compound = "",
                    Recovery = "",
                    TranslationUnit = "",
                    PackExpansion = "",
                    TemplateTypeParm = "",
                    TemplateTemplateParm = "",
                    TemplateParamObject = "",
                },
            },
        })
        return false
    end,
    -- ["*"] = function(server, opts)
    --     require("lspconfig")[server].setup(opts)
    --     return true
    -- end,
}

mason_lspconfig.setup_handlers({
    function(server)
        local server_opts = vim.tbl_deep_extend("force", {
            capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        server_opts.on_attach = on_attach

        if setup[server] then
            if setup[server](server, server_opts) then
                return
            end
        elseif setup["*"] then
            if setup["*"](server, server_opts) then
                return
            end
        end
        require("lspconfig")[server].setup(server_opts)
    end,
})
