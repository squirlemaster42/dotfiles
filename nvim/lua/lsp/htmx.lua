-- HTMX Language Server Configuration
return {
    cmd = { "htmx-lsp" },
    root_markers = { "package.json", ".git" },
    filetypes = { "html", "templ" },
    settings = {
        htmx = {
        }
    }
}
