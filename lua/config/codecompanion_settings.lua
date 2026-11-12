local M = {}
local pending = {}

local setting_names = {
  reasoning_effort = "Reasoning effort",
  model = "Model",
  mode = "Permission mode",
}

local function notify(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.WARN, { title = "CodeCompanion settings" })
  end)
end

-- Target the chat under the cursor, or the most recently used chat when editing code.
function M.open(config_id)
  local codecompanion = require("codecompanion")
  local chat = codecompanion.buf_get_chat(0) or codecompanion.last_chat()
  if not chat or not vim.api.nvim_buf_is_valid(chat.bufnr) then
    return notify("Open a CodeCompanion chat first.")
  end
  if chat.adapter.type ~= "acp" then
    return notify("These session settings require an ACP chat, such as Codex.")
  end
  if pending[chat.bufnr] then
    return notify("Waiting for this chat's session settings.")
  end
  pending[chat.bufnr] = true

  require("codecompanion.utils.async").sync(function()
    local ok, err = pcall(function()
      local handler = require("codecompanion.interactions.chat.acp.handler").new(chat)
      if not handler:ensure_connection() or not handler:ensure_session() then
        return notify("Could not connect to this chat's agent. See :messages for details.")
      end
      local connection = chat.acp_connection
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(chat.bufnr) or chat.acp_connection ~= connection then
          return
        end
        local picker = require("codecompanion.interactions.chat.slash_commands.builtin.acp_session_options").new({
          Chat = chat,
        })
        if not config_id then
          return picker:execute()
        end
        for _, option in ipairs(connection:get_config_options()) do
          if option.id == config_id then
            return picker:show_values(option)
          end
        end
        notify((setting_names[config_id] or config_id) .. " is unavailable for this chat's agent/model.")
      end)
    end)
    pending[chat.bufnr] = nil
    if not ok then
      notify("Could not open session settings: " .. tostring(err))
    end
  end)()
end

return M
