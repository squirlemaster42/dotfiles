-- Rust Language Server Configuration
return {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", ".git" },
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = {
                command = "clippy",
            },
            procMacro = {
                enable = true,
            },
        }
    }
}
