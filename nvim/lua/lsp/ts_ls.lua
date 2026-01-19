-- TypeScript/JavaScript Language Server Configuration
return {
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    settings = {
        typescript = {
            preferences = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
            }
        },
        javascript = {
            preferences = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
            }
        }
    }
}
