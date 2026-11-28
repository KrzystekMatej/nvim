vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionCreate",
  callback = function(args)
    local path = args.data.to

    if not path:match("%.ipynb$") or vim.fn.getfsize(path) ~= 0 then
      return
    end

    local template = [[
{
  "cells": [
    {
      "cell_type": "code",
      "execution_count": null,
      "id": "initial",
      "metadata": {},
      "outputs": [],
      "source": []
    }
  ],
  "metadata": {
    "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
    },
    "language_info": {
      "name": "python"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 5
}
]]

    vim.fn.writefile(vim.split(template, "\n"), path)
  end,
})

local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

local function should_autosave(buf)
  if not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end

  local opts = vim.bo[buf]
  return opts.buftype == ""
    and opts.modified
    and opts.modifiable
    and not opts.readonly
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function autosave(buf)
  if not should_autosave(buf) then
    return
  end

  local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
    vim.cmd.update({ mods = { silent = true } })
  end)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR, { title = "Autosave" })
  end
end

vim.api.nvim_create_autocmd("InsertLeave", {
  group = autosave_group,
  desc = "Save changes on leaving Insert mode",
  nested = true,
  callback = function(event)
    autosave(event.buf)
  end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  group = autosave_group,
  desc = "Save changes after a pause in Normal-mode editing",
  callback = function(event)
    local buf = event.buf
    if not should_autosave(buf) then
      return
    end

    local changedtick = vim.api.nvim_buf_get_changedtick(buf)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_loaded(buf) or vim.api.nvim_buf_get_changedtick(buf) ~= changedtick then
        return
      end
      if vim.api.nvim_get_current_buf() == buf and vim.fn.mode():match("^[iR]") then
        return
      end
      autosave(buf)
    end, 500)
  end,
})
