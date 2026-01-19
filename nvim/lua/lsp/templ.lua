-- Templ Language Server Configuration
return {
    cmd = { "templ", "lsp" },
    root_markers = { "go.mod", ".git" },
    filetypes = { "templ" },
    settings = {
        templ = {
        }
    }
}
