-- HTML Language Server Configuration
return {
    cmd = { "vscode-html-language-server", "--stdio" },
    root_markers = { "package.json", ".git" },
    filetypes = { "html", "templ" },
    settings = {
        html = {
            validate = {
                scripts = true,
                styles = true,
            },
            format = {
                enable = true,
                wrapAttributes = "auto",
                wrapAttributesIndentSize = 2,
            },
        }
    }
}
