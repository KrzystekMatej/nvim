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
