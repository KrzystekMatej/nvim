local M = {}

local function command(name, entry)
  if vim.fn.has("win32") == 0 then
    return { name }
  end

  local executable = vim.fn.exepath(name .. ".exe")
  if executable ~= "" then
    return { executable }
  end

  -- Neovim spawns processes directly; npm's .cmd wrappers need a shell.
  -- Launch their JavaScript entry through Node instead.
  local shim = vim.fn.exepath(name .. ".cmd")
  local npm_dir = shim ~= "" and vim.fs.dirname(shim) or vim.fs.joinpath(vim.env.APPDATA, "npm")
  return { "node", vim.fs.joinpath(npm_dir, "node_modules", entry) }
end

function M.acp()
  return command("codex-acp", "@agentclientprotocol/codex-acp/dist/index.js")
end

function M.cli()
  return command("codex", "@openai/codex/bin/codex.js")
end

return M
