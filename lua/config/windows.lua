-- Make Visual Studio's compiler and SDK available to parser builds even when
-- Neovim starts outside a Developer PowerShell. This only changes Neovim's env.
if vim.fn.has("win32") == 0 then
  return
end

if vim.env.CC or (vim.fn.executable("cl") == 1 and vim.env.INCLUDE and vim.env.LIB) then
  return
end

if vim.fn.executable("gcc") == 1 then
  vim.env.CC = "gcc"
  return
end

local vswhere = (vim.env["ProgramFiles(x86)"] or "C:/Program Files (x86)")
  .. "/Microsoft Visual Studio/Installer/vswhere.exe"
if vim.fn.executable(vswhere) == 0 then
  vswhere = vim.fn.exepath("vswhere")
end
if vswhere == "" then
  return
end

local found, installation = pcall(function()
  return vim
    .system({
      vswhere,
      "-latest",
      "-products",
      "*",
      "-requires",
      "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
      "-property",
      "installationPath",
    }, { text = true })
    :wait(5000)
end)
if not found then
  return
end

local path = vim.trim(installation.stdout or "")
if installation.code ~= 0 or path == "" then
  return
end

local devcmd = path .. "\\Common7\\Tools\\VsDevCmd.bat"
local arch = vim.fn.has("win64") == 1 and "amd64" or "x86"
-- system() handles cmd.exe quoting; vim.system() applies C-runtime escaping.
local initialized, output = pcall(vim.fn.system, {
  vim.env.COMSPEC or "cmd.exe",
  "/d",
  "/s",
  "/c",
  '""' .. devcmd .. '" -no_logo -arch=' .. arch .. " -host_arch=" .. arch .. ' >nul && set"',
})

if initialized and vim.v.shell_error == 0 then
  for line in output:gmatch("[^\r\n]+") do
    local name, value = line:match("^([^=]+)=(.*)$")
    if name then
      vim.env[name] = value
    end
  end
else
  vim.schedule(function()
    vim.notify(
      "Could not initialize Visual Studio's compiler environment. Run :LazyHealth for details.",
      vim.log.levels.WARN
    )
  end)
end
