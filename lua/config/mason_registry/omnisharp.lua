-- Official v2 release assets: https://github.com/OmniSharp/omnisharp-roslyn/releases/tag/v2.0.0
return {
  name = "omnisharp",
  description = "OmniSharp language server based on Roslyn workspaces. Requires .NET 10.",
  homepage = "https://github.com/OmniSharp/omnisharp-roslyn",
  licenses = { "MIT" },
  languages = { "C#" },
  categories = { "LSP" },
  source = {
    id = "pkg:github/OmniSharp/omnisharp-roslyn@v2.0.0",
    asset = {
      { target = "win_x64", file = "omnisharp-win-x64.zip:libexec/" },
      { target = "win_arm64", file = "omnisharp-win-arm64.zip:libexec/" },
    },
  },
  schemas = {
    lsp = "vscode:https://raw.githubusercontent.com/OmniSharp/omnisharp-vscode/master/package.json",
  },
  bin = { OmniSharp = "dotnet:libexec/OmniSharp.dll" },
  neovim = { lspconfig = "omnisharp" },
}
