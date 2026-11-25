# LazyVim Config Cheat Sheet

## Reading this sheet

| Notation | Meaning |
| --- | --- |
| `<leader>` | Press Space. |
| `<C-x>` / `<A-x>` | Hold Ctrl / Alt while pressing `x`. |
| `<CR>` / `<Esc>` | Enter / Escape. |
| Uppercase letter | Use Shift; `gU` means `g`, then uppercase `U`. |
| `{motion}`, `{object}`, `{pattern}`, `{label}` | Replace the placeholder with the appropriate input. |
| `3dd`, `ciw`, `<leader>cf` | Sequential keys, not chords. |
| Commands beginning with `:` | Type the command, then Enter. |

Shortcuts start in **Normal mode** unless another mode or interface is specified. `/` between separately formatted shortcuts means alternatives; a slash *inside* a shortcut is literal. Flash labels are generated dynamically.

**Configuration assumed:** MiniFiles; Spider's `w`/`e`/`b`; the book's `;` surround mappings; Yanky; counted buffer navigation; custom buffer-close keys; Smart Splits on Alt plus `h/j/k/l`; rip-substitute; text-case; Dial; Git hunk shortcuts and git-conflict; DAP and Neotest with relevant language adapters. Insert-mode `jk` and `;;` are included. MiniFiles keeps `h/l`: the author's arrow-key substitution is explicitly a personal preference. Version-dependent behavior and conflicting mappings are marked locally.

| Book chapter | Shortcuts | General overview |
| --- | --- | --- |
| 2. Modal editing | [Keys](#shortcuts-2-modal-editing) | [Overview](#overview-2-modal-editing) |
| 3. Getting around | [Keys](#shortcuts-3-getting-around) | [Overview](#overview-3-getting-around) |
| 4. Opening files | [Keys](#shortcuts-4-opening-files) | [Overview](#overview-4-opening-files) |
| 6. Basic editing | [Keys](#shortcuts-6-basic-editing) | [Overview](#overview-6-basic-editing) |
| 7. Objects and operators | [Keys](#shortcuts-7-objects-and-operators) | [Overview](#overview-7-objects-and-operators) |
| 8. Clipboard, registers, visual modes | [Keys](#shortcuts-8-clipboard-registers-and-visual-modes) | [Overview](#overview-8-clipboard-registers-and-visual-modes) |
| 9. Buffers, windows, tabs, sessions | [Keys](#shortcuts-9-buffers-windows-tabs-and-sessions) | [Overview](#overview-9-buffers-windows-tabs-and-sessions) |
| 10. Language support | [Keys](#shortcuts-10-language-support) | [Overview](#overview-10-language-support) |
| 11. Navigating source files | [Keys](#shortcuts-11-navigating-source-files) | [Overview](#overview-11-navigating-source-files) |
| 12. Searching | [Keys](#shortcuts-12-searching) | [Overview](#overview-12-searching) |
| 13. Replacing and bulk editing | [Keys](#shortcuts-13-replacing-and-bulk-editing) | [Overview](#overview-13-replacing-and-bulk-editing) |
| 14. Miscellaneous editing | [Keys](#shortcuts-14-miscellaneous-editing) | [Overview](#overview-14-miscellaneous-editing) |
| 15. Source control | [Keys](#shortcuts-15-source-control) | [Overview](#overview-15-source-control) |
| 17. Debugging | [Keys](#shortcuts-17-debugging) | [Overview](#overview-17-debugging) |
| 18. Testing | [Keys](#shortcuts-18-testing) | [Overview](#overview-18-testing) |

## Part I: Shortcuts

### Shortcuts 2: Modal editing

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-2/) · [Insert-mode reference](https://neovim.io/doc/user/insert/)

| Shortcut | Action |
| --- | --- |
| `<Esc>` | Return to Normal mode; cancel a pending command. |
| `i` / `a` | Insert before / after the cursor. |
| `I` / `A` | Insert at first nonblank character / after end of line. |
| `o` / `O` | Open a line below / above and start inserting. |
| `gi` | Resume inserting at the last insertion position. |
| `jk` in Insert | Return to Normal mode; book mapping. |
| `;;` in Insert | Perform one Normal-mode command, then resume inserting. |
| `:` | Enter an Ex command. |
| `<leader>`; `g`; `z`; `[`; `]` | Pause after a prefix to inspect which-key's available commands. |
| `:w` / `:w filename` | Save / write to the specified filename. |
| `:wq` / `:x` | Save and close; `:x` writes only when modified. |
| `:q` / `:q!` | Close the window / discard its buffer changes if abandoned. |
| `:help {topic}` | Open built-in documentation. |
| `<Tab>` / `<S-Tab>` in command completion | Cycle candidates forward / backward. |
| `<C-y>` in command completion | Accept completion and continue editing the command. |

### Shortcuts 3: Getting around

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-3/) · [Motions](https://neovim.io/doc/user/motion/) · [Scrolling](https://neovim.io/doc/user/scroll/) · [Spider](https://github.com/chrisgrieser/nvim-spider)

#### Cursor movement and Flash

| Shortcut | Action |
| --- | --- |
| `h` / `j` / `k` / `l` | Left / down / up / right. |
| `5j`, `12k` | Move by a count; relative line numbers provide the count. |
| `w` / `e` / `b` | Next word start / word end / previous word start. With Spider, also stop at subwords in `camelCase` and `snake_case`. |
| `ge` | Previous word end; the book's Spider configuration leaves this native. |
| `W` / `E` / `B` / `gE` | Corresponding movements over whitespace-delimited WORDs. |
| `0` / `^` | Column one / first nonblank character. |
| `$` / `g_` | Last character / last nonblank character. |
| `gg` / `G` | First / last line. |
| `42G` / `:42` | Go to line 42. |
| `s{search}{label}` | Flash: jump to a visible match, including another window. |
| `f{character}` / `F{character}` | Find a character forward / backward. |
| `t{character}` / `T{character}` | Move toward a character, stopping just before reaching it. |
| `3f{character}` | Find the third occurrence. |
| `f` / `F` while Flash character-find is active | Repeat forward / backward; counts work. `t/T` have analogous repeats. |
| `<C-o>` / `<C-i>` | Older / newer location in the jump list. |

Flash extends character-find beyond native Vim's single-line behavior. With the surround remapping, **`;` is a surround prefix**; use Flash's active `f/F/t/T` repeats.

#### View positioning

| Shortcut | Action |
| --- | --- |
| `<C-d>` / `<C-u>` | Move down / up approximately half a window. |
| `<C-f>` / `<C-b>` | Page forward / backward. |
| `<C-e>` / `<C-y>` | Scroll the view down / up one line. |
| `zt` / `zz` / `zb` | Place the cursor's line near the top / middle / bottom. |

### Shortcuts 4: Opening files

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-4/) · [MiniFiles](https://nvim-mini.org/mini.nvim/doc/mini-files.html) · [Snacks picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)

#### Find and open

| Shortcut | Action |
| --- | --- |
| `<leader><Space>` / `<leader>ff` | Find files in the detected project root. |
| `<leader>fF` | Find files in the current working directory. |
| `<leader>fc` | Find files in the Neovim configuration directory. |
| `:e path` | Open a file directly; Tab completes paths. |
| `:pwd` | Show the current working directory. |
| `:cd path` / `:lcd path` | Change the global / window-local working directory. |
| `<leader>e` | MiniFiles at the current file's directory; book mapping. |
| `<leader>E` / `<leader>fM` | MiniFiles at the current working directory. |
| `<leader>fm` | MiniFiles at the project root; book mapping. |

#### Inside a Snacks picker

| Shortcut | Action |
| --- | --- |
| Type a query | Filter results; file pickers use fuzzy matching. |
| Space between query terms | Add another fuzzy condition, regardless of term order in the path. |
| `<Down>` / `<Up>` or `<C-n>` / `<C-p>` | Select next / previous result. |
| `<A-s>`, then a label | Jump to a result; Enter then opens it. |
| `<Tab>` / `<S-Tab>` | Toggle selection and move down / up. |
| `<CR>` | Confirm the current result or selected results. |
| `<C-v>` / `<C-s>` | Open in a vertical / horizontal split. |
| `<C-d>` / `<C-u>` | Scroll the results list down / up. |
| `<C-f>` / `<C-b>` | Scroll the preview down / up. |
| `<C-q>` / `<A-t>` | Send selected results, or all results, to Quickfix / Trouble. |
| `<Esc>` | Leave input Insert mode; a second Escape closes the picker. |
| `<leader>sR` after leaving | Resume the previous picker. |

**Exceptions:** live grep sends spaces to the search engine; the Git status picker's Tab stages/unstages files.

#### Inside MiniFiles

| Shortcut | Action |
| --- | --- |
| `j` / `k` | Move through entries. |
| `l` / `h` | Enter a directory or open a file / go to the parent. |
| `L` | Enter; close MiniFiles when opening a file. |
| `q` / `g?` | Close / display help. |
| `o`, then a name | Add a file; a trailing `/` creates a directory. |
| Edit an existing name | Rename the entry. |
| `dd` | Mark an entry for deletion. |
| `yy`, navigate, `p` | Copy an entry. |
| `dd`, navigate, `p` | Move an entry. |
| `=` | Review and synchronize filesystem changes; confirm with `y` or decline with `n`. |
| `<C-w>v` / `<C-w>s` | Open the selected file in a vertical / horizontal split. |
| `<C-w>V` / `<C-w>S` | Open in a split and close MiniFiles. |
| `g.` / `gc` | Toggle hidden files / set cwd to the entry's containing directory. |

The split and `g.`/`gc` mappings come from the [LazyVim MiniFiles extra](https://www.lazyvim.org/extras/editor/mini-files). Editing the listing stages changes; `=` applies them.

### Shortcuts 6: Basic editing

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-6/) · [Editing](https://neovim.io/doc/user/change/) · [Repetition](https://neovim.io/doc/user/repeat/)

**Grammar:** optional register → optional count → operator → optional count → motion or text object. Counts multiply: `2d3w` covers six `w` motions.

| Shortcut | Action |
| --- | --- |
| `d{motion}` / `c{motion}` | Delete / delete and enter Insert mode. |
| `dd` / `cc` | Delete / change the current line. |
| `3dd` / `3cc` | Delete / change three lines. |
| `D` / `C` | Delete / change from cursor to end of line. |
| `d0` / `d^` | Delete back to column one / first nonblank. |
| `dt,` / `df,` | Delete up to a comma / through the comma. |
| `x` / `X` | Delete the character under / before the cursor. |
| `r{character}` | Replace one character without remaining in Insert mode. |
| `3r_` | Replace three characters with underscores. |
| `J` / `gJ` | Join with normalized intervening space / without inserting space. |
| `gU{motion}` / `gu{motion}` | Uppercase / lowercase the affected text. |
| `gUU` / `guu` | Uppercase / lowercase the line. |
| `~` / `g~{motion}` | Toggle case of a character / a region. |
| `.` | Repeat the last change, including text entered by `c`. |
| `2.` | Repeat with count replaced by 2; after `3dd`, deletes two lines. |
| `u` / `<C-r>` | Undo / redo. |
| `:UndotreeToggle` | Inspect branching undo history with Undotree installed. |

#### Macros

| Shortcut | Action |
| --- | --- |
| `qa` … `q` | Record into register `a`; stop with `q` in Normal mode. |
| `qA` … `q` | Append to the recording in `a`. |
| `@a` / `10@a` | Play register `a` once / ten times. |
| `@@` | Replay the last executed register. |

`qq` and `@q` are the same pattern using register `q`. Prefer stable motions/searches inside macros; generated Flash labels may point elsewhere on replay. **`Q` is version-dependent:** older Neovim replays the last recording; the multicursor builds described in chapter 13 use it to place cursors.

### Shortcuts 7: Objects and operators

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-7/) · [mini.ai](https://nvim-mini.org/mini.nvim/doc/mini-ai.html) · [mini.surround](https://nvim-mini.org/mini.nvim/doc/mini-surround.html) · [Flash](https://github.com/folke/flash.nvim)

#### Structural movement

| Shortcut | Action |
| --- | --- |
| `(` / `)` | Previous / next sentence boundary. |
| `{` / `}` | Previous / next paragraph boundary. |
| `%` | Jump between matching delimiters; native lookup searches on the current line when not on one. |
| `[(` / `])`; `[{` / `]}` | Move to unmatched opening / closing parentheses or braces. |
| `[%` / `]%` | Move to the surrounding matching construct's beginning / end, through match-up. |
| `[i` / `]i` | Beginning / end of the current indentation scope. |
| `[f` / `]f`; `[F` / `]F` | Previous / next function start; uppercase targets ends. |
| `[c` / `]c`; `[C` / `]C` | Previous / next class start; uppercase targets ends. |
| `[m` / `]m`; `[M` / `]M` | Native method-start / method-end motions; language and syntax dependent. |
| `g[{delimiter}` / `g]{delimiter}` | Move to the left / right edge of the corresponding mini.ai object. |

Reference jumps are under chapter 11, diagnostics under 10, Git hunks under 15, and spelling under 14. Not every plugin's navigation mapping also works after an operator.

#### Text objects

Use `i` for **inside**, `a` for **around**: `ciw`, `daw`, `yaf`, `vi(`. These prefixes apply after an operator or in Visual mode.

| Object suffix | What it selects |
| --- | --- |
| `w` / `W` | Word / whitespace-delimited WORD; `a` also includes adjacent spacing. |
| `s` / `p` | Sentence / paragraph; `a` includes surrounding whitespace or blank lines. |
| `"`, `'`, or a backtick | Contents of matching quotes; `a` includes quotes. |
| `(`, `[`, `{`, `<` | Delimited region; `a` includes delimiters. |
| `q` / `b` | Nearby quote pair / bracket pair without naming its type. |
| `f` / `c` | Function or method / class or type. |
| `o` | Code block, conditional, or loop. |
| `t` | HTML/XML-style tag region. |
| `i` | Indentation scope. |
| `g` | Whole buffer; `ig` omits outer blank lines. |

| Example | Action |
| --- | --- |
| `ci"` / `da"` | Replace quoted contents / delete contents and quotes. |
| `d2i{` | Delete inside the second enclosing brace pair. |
| `cin(` / `cil(` | Change inside the next / previous parenthesized object. |
| `dan{` / `dal{` | Delete around the next / previous brace object. |
| `yag` | Yank the entire buffer. |

#### Flash object selection and remote operations

| Shortcut | Action |
| --- | --- |
| `S{label}` | Select a surrounding Tree-sitter node. |
| `dS{label}` / `cS{label}` / `yS{label}` | Delete / change / yank the chosen surrounding node. |
| `yr{search}{label}iw` | Temporarily jump to a remote word, yank it, then return. |
| `dr{search}{label}{motion}` | Apply a deletion at a remote location, then return. |
| `yR{search}{label}` | Find a remote Tree-sitter node and yank it. |

`r` and `R` here follow an operator; Normal-mode `r` still replaces a character. `R` chooses structural ranges; lowercase `r` lets you supply the motion/object after jumping.

#### Surrounds — the book's remapped keys

| Shortcut | Action |
| --- | --- |
| `;;{motion}{surround}` | Add a surrounding pair. |
| `;;iw"` | Put double quotes around the word. |
| `;;i[)` / `;;i[(` | Add parentheses inside brackets, without / with padding spaces. |
| `;;{surround}` in Visual | Surround the selection. |
| `;d{surround}` | Remove surrounding characters; retain contents. |
| `;r{old}{new}` | Replace the surrounding pair; e.g. `;r"'`. |
| `2;d{` | Remove the second enclosing brace pair. |
| `;f{surround}` / `;F{surround}` | Find a surrounding character rightward / leftward. |
| `;h{surround}` | Highlight the pair that would be affected. |
| `;n` | Change the surrounding search's line limit. |
| `;;apt`, then a tag name and Enter | Wrap a paragraph in an HTML/XML tag. |
| `;dt` / `;rtt` | Delete a surrounding tag / replace it via a tag-name prompt. |

When adding brackets, an opening bracket generally adds inner spaces; a closing bracket omits them. These commands replace the book's initial `gsa`, `gsd`, `gsr`, and related mappings.

### Shortcuts 8: Clipboard, registers, and visual modes

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-8/) · [Visual mode](https://neovim.io/doc/user/visual/) · [Yanky mappings](https://www.lazyvim.org/extras/coding/yanky)

#### Copy and put

| Shortcut | Action |
| --- | --- |
| `y{motion}` / `y{object}` | Yank the affected text. |
| `yy` / `Y` | Yank the line / cursor to end of line. |
| `p` / `P` | Put after / before; linewise text goes below / above. |
| `"ayiw` / `"ap` | Yank a word into register `a` / put from `a`. |
| `"Ay{motion}` | Append the yank to register `a`. |
| `"_d{motion}` | Delete without changing text registers or the clipboard. |
| `<C-r>a` in Insert or command line | Insert register `a`; use `+` for the clipboard. |
| `"` then pause / `<leader>s"` | Inspect registers / search them in a picker. |
| `:let @a = @+` | Preserve the system clipboard in register `a`. |
| `:let @+ = @%` | Copy the current buffer's filename to the clipboard. |
| `<leader>p` | Search Yanky's yank history. |
| `[y` / `]y` immediately after putting | Replace that put with an older / newer history entry. |
| `[p` / `]p` | Put on a new line above / below, adapting indentation. |
| `>p` / `<p` | Put after and increase / decrease indentation. |
| `>P` / `<P` | Put before and increase / decrease indentation. |

#### Registers to remember

| Register name | Contents or behavior |
| --- | --- |
| `"` | Unnamed register: ordinary yank/delete/change target. |
| `a`–`z` | Named storage; uppercase appends to the lowercase register. |
| `0` | Latest yank made without an explicit register. |
| `1`–`9` | Recent linewise or larger deletions/changes; some motions are exceptions. |
| `-` | Small deletion, normally less than one line. |
| `.` | Last inserted text. |
| `%` | Current buffer's filename. |
| `+` | System clipboard. |
| `*` | Selection clipboard on systems that distinguish it from `+`. |
| `_` | Black hole: discard text. |

Prefix with `"` to select one: `"0p`, `".p`, `"+yap`. With LazyVim's clipboard integration, ordinary operations use the system clipboard; `*` and `+` are not universally identical.

#### Visual selection

| Shortcut | Action |
| --- | --- |
| `v` / `V` / `<C-v>` | Characterwise / linewise / rectangular selection. |
| Motions or text objects | Extend or reshape the selection. |
| `o` | Switch to the opposite end of the selection. |
| `gv` | Restore the previous selection. |
| `d` / `c` / `y` with a selection | Delete / change / yank immediately. |
| `<C-v>`, select lines, `$` | Extend each selected row through its own end. |
| `I` / `A` in a block selection | Insert before / after the block; Escape applies text to all rows. |

### Shortcuts 9: Buffers, windows, tabs, and sessions

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-9/) · [Windows and buffers](https://neovim.io/doc/user/windows/) · [Folds](https://neovim.io/doc/user/fold/) · [Sessions](https://github.com/folke/persistence.nvim) · [Smart Splits](https://github.com/smart-splits-nvim/smart-splits.nvim)

#### Buffers

| Shortcut | Action |
| --- | --- |
| `H` / `L` or `[b` / `]b` | Previous / next buffer; the book's remapping supports counts. |
| `3L` | Advance three buffers. |
| ``<leader>` `` / `<leader>bb` | Switch to the alternate buffer. |
| `<leader>,` | Pick an open buffer. |
| `<C-x>` in the buffer picker | Close the highlighted buffer. |
| `<leader>bd` / `<leader><Del>` | Close the buffer while preserving the window layout. |
| `<leader>bD` | Close the buffer and its window. |
| `<leader>bo` | Close other buffers. |
| `<leader><CR>` | Close all buffers; book mapping to `:%bd`. |
| `<leader>bp` / `<leader>bP` | Pin/unpin / close unpinned buffers; Bufferline required. |
| `<leader>bl` / `<leader>br` | Close buffers left / right in Bufferline. |
| `<leader>.` / `<leader>S` | Toggle a persistent scratch buffer / select a saved scratch buffer. |

#### Windows

The standard window prefix is `<C-w>`; the book also uses `<leader>w` through which-key.

| Shortcut | Action |
| --- | --- |
| `<leader>wv` / `<leader>ws` | Split vertically / horizontally. |
| `<leader>\|` / `<leader>-` | Same split actions with shape-based shortcuts. |
| `<leader>wh` / `<leader>wj` / `<leader>wk` / `<leader>wl` | Move left / down / up / right. |
| `<C-h>` / `<C-j>` / `<C-k>` | Move left / down / up directly. |
| `<A-h>` / `<A-j>` / `<A-k>` / `<A-l>` | Smart Splits navigation, including configured terminal panes. |
| `<leader>wc` / `<leader>wd` | Close a split; retain its buffer. |
| `<leader>wq` | Close the window; quit if it was the last one. |
| `<leader>wo` | Keep only the current window. |
| `<leader>w+` / `<leader>w-` | Increase / decrease height. |
| `<leader>w>` / `<leader>w<` | Increase / decrease width. |
| `<leader>w=` | Equalize window dimensions. |
| `<leader>w<Space>` | Keep the window menu open for repeated actions; Escape exits. |
| `<leader>uz` / `<leader>uZ` | Toggle Zen / maximized-window mode. |

`<C-l>` normally moves right, but the book's multicursor mapping replaces it. Use `<A-l>` or `<C-w>l` for rightward window movement with that configuration.

#### Tabs, folds, and sessions

| Shortcut | Action |
| --- | --- |
| `<leader><Tab><Tab>` | Create a tab page. |
| `<leader>wT` | Move the current split to a new tab. |
| `gt` / `gT` | Next / previous tab. |
| `3gt` | Go to tab number 3. |
| `<leader><Tab>]` / `<leader><Tab>[` | Next / previous tab. |
| `<leader><Tab>d` | Close the tab and its windows; buffers remain. |
| `zc` / `zo` / `za` | Close / open / toggle a fold. |
| `zC` / `zO` / `zA` | Corresponding recursive fold actions. |
| `zM` / `zR` | Close / open all folds. |
| `zm` / `zr` | Fold one level more / less. |
| `<leader>qs` | Restore the session for the current directory. |
| `<leader>qS` | Select a saved session. |
| `<leader>ql` | Restore the last session. |
| `<leader>qd` | Stop saving the current session. |
| `<leader>qq` | Quit Neovim. |
| `s` / `S` on the dashboard | Restore / select a session; uppercase uses the book's dashboard addition. |

### Shortcuts 10: Language support

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-10/) · [LazyVim keymaps](https://www.lazyvim.org/keymaps) · [Trouble](https://github.com/folke/trouble.nvim)

#### Tools and troubleshooting

| Shortcut | Action |
| --- | --- |
| `<leader>cm` | Open Mason's tool manager. |
| `i` / `U` / `g?` in Mason | Install the selected tool / update installed tools / show help. |
| `<leader>cl` | Inspect language-server information. |
| `:checkhealth vim.lsp` / `:checkhealth mason` | Check LSP / tool-installation health. |
| `:LazyHealth` | LazyVim's health overview. |
| `<leader>sna` / `<leader>snl` | Show Noice message history / the last message. |
| `<leader>snd` / `:messages` | Dismiss notifications / inspect message history. |

Restarting a server is version-dependent: the current book uses `:lsp restart`; older nvim-lspconfig installations expose `:LspRestart`. Use command completion to identify yours.

#### Diagnostics and fixes

| Shortcut | Action |
| --- | --- |
| `[d` / `]d` | Previous / next diagnostic. |
| `[e` / `]e` | Previous / next error. |
| `[w` / `]w` | Previous / next warning. |
| `<leader>cd` | Show diagnostics for the current line. |
| `<leader>xx` | Toggle workspace diagnostics in Trouble. |
| `<leader>xX` | Toggle current-buffer diagnostics in Trouble. |
| `<leader>xq` / `<leader>xQ` | Open Quickfix / its Trouble view. |
| `<leader>xl` / `<leader>xL` | Open the location list / its Trouble view. |
| `[q` / `]q` | Previous / next Trouble item when open, otherwise Quickfix item. |
| `<CR>` on a Trouble result | Jump to its source location. |
| `[t` / `]t` | Previous / next TODO-style comment. |
| `<leader>xt` / `<leader>xT` | TODO list in Trouble / restricted TODO, FIXME, FIX list. |
| `<leader>ca` | Show available code actions. |
| `<leader>cf` | Format the buffer or selection. |
| `<leader>uf` / `<leader>uF` | Toggle automatic formatting globally / for this buffer. |

**Correction:** chapter 10 swaps the descriptions of `xx` and `xX`. The table follows LazyVim's actual mappings. Workspace diagnostics include only what the servers have reported.

### Shortcuts 11: Navigating source files

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-11/) · [LazyVim LSP mappings](https://www.lazyvim.org/keymaps#lsp) · [Marks](https://neovim.io/doc/user/motion/#mark-motions)

| Shortcut | Action |
| --- | --- |
| `gd` / `gD` | Go to definition / declaration. |
| `gr` | Find references. |
| `gI` / `gy` | Go to implementation / type definition. |
| `K` | Show documentation for the symbol under the cursor. |
| `[[` / `]]` | Previous / next highlighted reference in this buffer. |
| `<leader>ss` / `<leader>sS` | Find document / workspace symbols. |
| `<leader>cs` | Toggle Trouble's symbol outline. |
| `<leader>cS` | Show LSP locations in Trouble. |
| `<leader>ut` | Toggle Tree-sitter context lines. |
| `<C-o>` | Return after following a definition or other jump. |
| `ma` / `mA` | Set a buffer-local / global mark. |
| `'a` / `'A` | Jump to the marked line; uppercase marks cross files. |
| `` `a `` / `` `A `` | Jump to the exact marked position. |
| `'` then pause / `<leader>sm` | Inspect marks / find one in a picker. |
| `'<` / `'>` | First / last line of the previous visual selection. |
| `'.` / `` `. `` | Line / exact position of the last change. |
| `:delmarks a` | Remove mark `a`. |

Use `<C-q>` or `<A-t>` from reference/symbol pickers to keep a navigable results list. A symbol query such as `function parse` can filter by kind and name when both appear in picker text.

### Shortcuts 12: Searching

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-12/) · [Vim patterns](https://neovim.io/doc/user/pattern/)

| Shortcut | Action |
| --- | --- |
| `/{pattern}<CR>` / `?{pattern}<CR>` | Search forward / backward in the buffer. |
| `n` / `N` | Next match down / previous match up in LazyVim. |
| `3n` | Advance three matches. |
| `*` / `#` | Search the word under the cursor forward / backward. |
| `<Esc>` in Normal mode | Clear search highlighting. |
| `<leader>/` / `<leader>sg` | Search project-root file contents with live grep. |
| `<leader>sG` | Live grep in cwd. |
| `<leader>sw` / `<leader>sW` | Search the current word or selection in root / cwd. |

#### Vim regex reminders

| Pattern | Meaning |
| --- | --- |
| `\c` / `\C` | Force case-insensitive / case-sensitive matching. |
| `.` / `\.` | Any character / a literal period. |
| `\s` / `\S` | Whitespace / non-whitespace. |
| `\d` | Digit. |
| `*` / `\+` / `\=` | Previous atom repeated zero-or-more / one-or-more / zero-or-one times. |
| `^` / `$` | Start / end of line. |
| `\<name\>` | Whole word `name`. |
| `[abc]` / `[^abc]` | One listed / one unlisted character. |
| `\(pattern\)` | Capture a group. |
| `\\` / `\/` | Literal backslash / slash when `/` is the delimiter. |
| `\Vliteral.text` | Very nomagic search; still escape backslashes and the command delimiter. |

Default smart case ignores case for lowercase-only searches and becomes sensitive when capitals appear. Live grep and Grug-far use ripgrep's regex syntax, so Vim's `\+`, `\(`, and `\C` are not interchangeable with their syntax.

### Shortcuts 13: Replacing and bulk editing

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-13/) · [Substitution](https://neovim.io/doc/user/change/#substitute) · [Ex ranges](https://neovim.io/doc/user/cmdline/#cmdline-ranges)

#### Native substitution

Form: `:[range]s/{pattern}/{replacement}/[flags]`.

| Command | Action |
| --- | --- |
| `:s/old/new/` | Replace the first match on the current line. |
| `:%s/old/new/g` | Replace every match throughout the buffer. |
| `:%s/old/new/gc` | Ask before each replacement. |
| `:'<,'>s/old/new/g` | Replace on the lines covered by the previous selection. |
| `:s//new/` | Reuse the last search pattern. |
| `:s` | Repeat the previous substitution on this line, without its flags. |
| `:%sg` | Repeat the last substitution globally across the buffer. |
| `:%s#old/path#new/path#g` | Use another separator when paths contain `/`. |
| `<leader>cr` | LSP rename: use for semantic symbol renaming when supported. |

| Range or flag | Meaning |
| --- | --- |
| No range / `.` | Current line. |
| `%` | All lines. |
| `12,20` / `.,$` | Lines 12–20 / current line through end of buffer. |
| `'a,'b` | Lines between two marks, inclusive. |
| `'<,'>` | Previous visual selection's **lines**, not only selected columns. |
| `.,/pattern/` | Current line through the next line matching the pattern. |
| `g` | Every match per line. |
| `c` | Confirm each replacement: `y` accept, `n` skip, `a` accept remaining, `q` quit. |
| `i` / `I` | Ignore / respect case. |
| `\0` or `&` in replacement | Reinsert the complete match. |
| `\1`, `\2`, … in replacement | Reinsert captured groups. |

Example: `:%s/\(red\)-\(blue\)/\2-\1/g` changes `red-blue` to `blue-red`.

#### Replacement interfaces

[rip-substitute](https://github.com/chrisgrieser/nvim-rip-substitute) · [Grug-far](https://github.com/MagicDuck/grug-far.nvim) · [text-case](https://github.com/johmsalas/text-case.nvim)

| Shortcut | Interface and action |
| --- | --- |
| `g/` | Open rip-substitute for the buffer; book mapping. |
| `V`, select lines, `g/` | Limit rip-substitute to those lines. |
| Characterwise selection, `g/` | Prefill the search with that text; does not establish a linewise scope. |
| `j` / `k` in rip-substitute Normal mode | Move between search and replacement fields. |
| `<CR>` in Normal / `<C-CR>` in Insert | Apply rip-substitute's previewed replacement. |
| `q` in rip-substitute Normal mode | Cancel. |
| `<leader>sr` | Open Grug-far for project-wide replacement. |
| `\r` in Grug-far Normal mode | Execute the search/replacement shown by the fields. |
| Edit result lines, then `\s` | Synchronize edited preview text to its source files. |
| `<CR>` on a Grug-far result | Open its source location. |
| `\t` / `g?` in Grug-far | Search history / help. |
| `ga`, then a case choice | Convert the current word or visual selection with text-case. |
| `gao`, case choice, then motion | Choose a case conversion and its affected region. |
| `gas` / `gac` / `gap` / `gan` | Convert to snake_case / camelCase / PascalCase / CONSTANT_CASE. |
| `:[range]Subs/old_name/new_name/` | Replace wording while preserving forms such as `oldName` and `OLD_NAME`. |

Grug-far's Files Filter takes globs, such as `src/**/*.ts`. `\r` applies the search recipe; `\s` saves manual result edits. Review the preview and resulting Git diff, especially for changes across files.

#### Native multicursors — version-dependent

This subsection requires a Neovim build with native multicursors, discussed in the book as **0.13/nightly**. It does not follow merely from installing LazyVim extras. See your installed `:help multicursor` and the [current Neovim reference](https://neovim.io/doc/user/repeat/#multicursor).

| Shortcut | Action |
| --- | --- |
| `Q` | Toggle an extra cursor at the current position; subsequent motions position the main cursor. |
| `<C-LeftMouse>` | Toggle a cursor at the clicked position. |
| `Q` in Visual mode | Place a cursor on each selected line and enable follow mode. |
| `q=` | Toggle whether relative motions move all cursors. |
| `<C-l>` | Clear multicursors, using the book's replacement for LazyVim's window mapping. |
| `gQ` | Restore the previous multicursors. |
| Search, then `zqgn` | Place cursors at search matches in current Neovim documentation. |

**Version difference:** the book uses `1Q` for all search matches. Current documentation assigns `1Q` to forcing placement of one cursor and uses `zq{motion}` for repeated placement. Do not assume those versions share the same keys.

#### Run commands across lines

[Repetition and global commands](https://neovim.io/doc/user/repeat/) · [Command-line window](https://neovim.io/doc/user/cmdline/#cmdwin)

| Command or shortcut | Action |
| --- | --- |
| `:'<,'>write extract.txt` | Write selected lines to another file. |
| `:[range]normal {keys}` | Execute Normal-mode keys on each line. |
| `:[range]normal! {keys}` | Execute native keys, bypassing mappings. |
| `:'<,'>normal @a` | Run macro `a` on each selected line. |
| `<C-v><Esc>` while typing a command | Insert a literal Escape for a `:normal` sequence. |
| `:%g/pattern/d` | Delete matching lines. |
| `:%g!/pattern/d` / `:%v/pattern/d` | Delete nonmatching lines. |
| `:%g/pattern/normal @a` | Run macro `a` only on matching lines. |
| `q:` / `<C-f>` from the command line | Open the editable command-history window. |
| `<CR>` in that window | Execute the edited command on the current line. |
| `:q` in that window | Close it without executing a history entry. |
| `:<Up>` | Recall the previous command for correction. |

### Shortcuts 14: Miscellaneous editing

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-14/) · [Insert commands](https://neovim.io/doc/user/insert/) · [Dial](https://www.lazyvim.org/extras/editor/dial)

#### Small edits, comments, and indentation

| Shortcut | Action |
| --- | --- |
| `g<C-g>` | Report word, character, byte, and position counts; works on a selection. |
| `xp` | Swap the current character with the next one. |
| `gc{motion}` / `gc{object}` | Toggle comments over a region. |
| `gcc` / `5gcc` | Toggle comments on one / five lines. |
| `gc` in Visual mode | Toggle comments on the selection. |
| `gco` / `gcO` | Insert a comment line below / above. |
| `<C-a>` / `<C-x>` | Increment / decrement a number or a Dial-supported value. |
| `g<C-a>` / `g<C-x>` in Visual mode | Apply progressively increasing increments / decrements across lines. |
| `>>` / `<<` | Indent / dedent the line once. |
| `3>>` | Indent three lines once. |
| `>` / `<` in Visual mode | Indent / dedent the selection. |
| `3>` in Visual mode | Indent the selection three levels. |
| `={motion}` / `==` | Reindent a region / line with the indentation engine. |
| `gq{motion}` | Format a region using the configured formatting mechanism. |
| `gww` / `gwip` / `gwig` | Reflow a line / paragraph / buffer using Vim's text wrapping. |
| `:set textwidth=80` | Set the target width for text reflow. |

#### External filters and spelling

| Shortcut | Action |
| --- | --- |
| Select text, then `!command` | Replace selected lines with the command's stdout. |
| `:'<,'>!sort` / `:'<,'>!jq` | Sort selected lines / format selected JSON with external tools. |
| `:!command` without a range | Run a shell command without replacing buffer text. |
| `<leader>us` | Toggle spell checking. |
| `[s` / `]s` | Previous / next spelling error. |
| `z=` | Suggest spellings for the word. |

#### While inserting

| Shortcut | Action |
| --- | --- |
| `<C-o>` / configured `;;` | Execute one Normal-mode command and return. |
| `<C-r>{register}` | Insert a register; `<C-r>+` inserts the clipboard. |
| `<C-a>` | Insert text from the previous insertion session. |
| `<C-u>` | Delete back to the current insertion start on this line. |
| `<C-t>` / `<C-d>` | Increase / decrease current-line indentation. |
| `<C-]>` | Expand an abbreviation without adding a separator. |
| `<C-n>` / `<C-p>` in completion | Select the next / previous candidate. |
| `<C-y>` | Accept completion; Enter also works with LazyVim's default preset, Right Arrow with the author's personal mapping. |
| `<Tab>` / `<S-Tab>` in an active snippet | Next / previous placeholder. |

`:iabbr shortcut expansion` defines a temporary Insert-mode abbreviation. Snippets support `$1`, `$2`, `${1:placeholder}`, and `$0` for the final cursor position. Custom VS Code-style snippet files and their `package.json` manifest live under `~/.config/nvim/snippets/` in the book's setup.

### Shortcuts 15: Source control

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-15/) · [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) · [Diff mode](https://neovim.io/doc/user/diff/)

#### Terminal and repository views

| Shortcut | Action |
| --- | --- |
| `<C-/>` | Toggle the integrated terminal. |
| `<C-\><C-n>` in Terminal mode | Enter Normal mode in the terminal buffer. |
| `<Esc><Esc>` in Terminal mode | LazyVim's alternative escape mapping where enabled. |
| `i` / `a` in terminal-buffer Normal mode | Resume sending input to the terminal. |
| `<C-z>`, then shell `fg` | Suspend Neovim / resume it through shell job control. |
| `<leader>gs` | Git status picker with diff previews. |
| `<Tab>` in Git status | Stage / unstage the highlighted file. |
| `<leader>gl` | Search commit history. |
| `:lua Snacks.picker.git_branches()` | Pick a branch. |
| `<leader>gg` | Open Lazygit for the project. |

#### Hunks — shortened mappings from the book

| Shortcut | Action |
| --- | --- |
| `[h` / `]h` | Previous / next changed hunk. |
| `ih` after an operator or in Visual mode | Select the hunk as a text object. Deleting it is not a general Git reset. |
| `<leader>hs` / `<leader>hS` | Stage the current hunk / whole buffer. |
| `<leader>hu` | Undo the most recent hunk staging operation. |
| `<leader>hr` / `<leader>hR` | Reset the hunk / buffer's unstaged changes against the index. |
| `<leader>ghb` | Show blame for the line; avoids the custom `hb` collision below. |
| `<leader>ghp` | Preview the hunk. |
| `<leader>ghd` / `<leader>ghD` | Diff against the index / `HEAD~1` with LazyVim's `diffthis("~")` mapping. |
| `:Gitsigns diffthis HEAD` | Compare explicitly with the checked-out commit. |

The book adds short aliases for staging, resetting, undo-staging, and blame. It does **not** shorten every `<leader>gh…` command. Its `<leader>hb` blame alias conflicts with git-conflict's “choose both”; use `<leader>ghb` or `:Gitsigns blame_line` for unambiguous blame.

**Correction:** the book describes `ghD` as comparing against the last commit. [LazyVim's mapping](https://www.lazyvim.org/plugins/editor) passes `~`, which means the parent of HEAD.

#### Diff and merge

| Shortcut or command | Action |
| --- | --- |
| Shell: `nvim -d first.txt second.txt` | Compare files side by side. |
| `[c` / `]c` in a diff window | Previous / next difference. |
| `do` / `:diffget` | Obtain the other side's change into this buffer. |
| `dp` / `:diffput` | Send this buffer's change to the other side. |
| `:diffget 2` | Obtain the hunk from buffer number 2 when several sides exist. |
| `:%diffget 2` | Replace the whole destination with buffer 2's version. |
| `:diffoff` / `:diffoff!` | Disable diff in this window / all windows in the tab. |
| Shell: `git mergetool` | Open the configured multiway merge layout. |

#### Conflict markers — book's git-conflict configuration

[git-conflict documentation](https://github.com/akinsho/git-conflict.nvim)

| Shortcut | Action |
| --- | --- |
| `[x` / `]x` | Previous / next conflict. |
| `<leader>ho` / `<leader>ht` | Choose the upper “ours” / lower “theirs” section. |
| `<leader>hb` / `:GitConflictChooseBoth` | Keep both sections; command form avoids mapping ambiguity. |
| `<leader>h0` | Choose neither: remove the conflicting sections. |
| `<leader>gx` | Populate Quickfix with conflicts. |
| `<leader>gr` | Refresh conflict detection. |

**Correction:** the book maps `h0` to `none`; that does not restore the base version, despite the accompanying prose. During rebases, “ours” and “theirs” can differ from your intuitive branch ownership; inspect the actual sections.

#### GitHub through Snacks

Requires the configured `gh` CLI. These are GitHub actions, not local Git operations.

| Shortcut | Action |
| --- | --- |
| `<leader>gi` / `<leader>gI` | Open / all issues. |
| `<leader>gp` / `<leader>gP` | Open / all pull requests. |
| `<CR>` on an item | Open its contextual action menu. |
| `<A-w>` in the picker | Focus the preview for line-level inspection. |
| `<CR>` on a PR diff line | Open actions including adding a review comment. |
| `<C-s>` in the comment editor | Submit the comment. |

### Shortcuts 17: Debugging

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-17/) · [LazyVim DAP configuration](https://www.lazyvim.org/extras/dap/core)

| Shortcut | Action |
| --- | --- |
| `<leader>db` / `<leader>dB` | Toggle a breakpoint / set a conditional breakpoint. |
| `<leader>dc` | Start or continue execution. |
| `<leader>da` | Run with prompted arguments. |
| `<leader>dl` | Rerun the previous debug configuration. |
| `<leader>di` / `<leader>dO` / `<leader>do` | Step into / over / out. |
| `<leader>dC` | Run to the cursor. |
| `<leader>dk` / `<leader>dj` | Move up / down the call stack. |
| `<leader>dP` / `<leader>dt` | Pause / terminate. |
| `<leader>du` | Toggle the debugger UI. |
| `<leader>de` | Evaluate the expression under the cursor or selection. |
| `<leader>dr` | Toggle the debugger REPL. |
| `<CR>` on an expandable DAP UI entry | Expand or collapse it. |
| `e` on a variable in the DAP UI | Edit its runtime value when supported. |
| `i` in the watches pane, expression, Enter | Add a watch expression. |

### Shortcuts 18: Testing

[Book chapter](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-18/) · [LazyVim Neotest configuration](https://www.lazyvim.org/extras/test/core) · [Neotest](https://github.com/nvim-neotest/neotest)

| Shortcut | Action |
| --- | --- |
| `<leader>tr` | Run the nearest test. |
| `<leader>tt` | Run tests in the current file. |
| `<leader>tT` | Run tests under cwd. |
| `<leader>tl` | Repeat the last test run. |
| `<leader>ts` | Toggle the test summary. |
| `<leader>to` / `<leader>tO` | Open focused floating output / toggle the output panel. |
| `<leader>tS` | Stop the test run. |
| `<leader>tw` | Toggle watching the current test file. |
| `<leader>td` | Debug the nearest test through DAP. |
| `<leader>ta` | Attach to a running test process where supported. |
| `q` in focused floating output | Close the output window. |
| `[q` / `]q` | Navigate failing-test entries in Trouble/Quickfix. |

#### Inside the Neotest summary

| Shortcut | Action |
| --- | --- |
| `<CR>` / `e` | Expand a node / expand its descendants. |
| `i` | Jump to the selected test's source. |
| `J` / `K` | Next / previous failed test. |
| `r` / `d` | Run / debug the selected test or group. |
| `o` / `O` | Show output / short output. |
| `m` / `M` | Toggle a mark / clear marks. |
| `R` / `D` | Run / debug marked tests. |
| `w` / `u` | Toggle watching / stop the selected run. |
| `?` | Show summary mappings. |

`<leader>td` chooses the DAP execution strategy. Whether a debugger stops automatically on an assertion failure depends on its adapter and exception settings.

## Part II: General overview

### Overview 2: Modal editing

**Normal** is the control mode, **Insert** enters text, **Visual** selects text, and the **command line** runs Ex commands. After an operator such as `d`, the editor waits in **operator-pending** mode for a motion or object.

The book's “Space mode”, “Go To mode”, and similar names describe command prefixes and discovery menus. A key's meaning depends on context: `<C-r>` redoes in Normal mode but inserts a register in Insert mode. Likewise, configured `;;` adds surrounds in Normal mode and temporarily executes a Normal command from Insert mode.

Use `:help` for exact behavior and which-key for discovery. Memorize a few operators and reusable motions before trying to memorize every combined command.

### Overview 3: Getting around

Choose movement by target: **Flash** for visible text, **search** for text outside the view, **word/subword motions** for nearby edits, and **counts** for a known distance. Repositioning the view with `zz` changes what is comfortable to see without changing the editing target.

Spider changes lowercase `w/e/b` to recognize code subwords and skip some punctuation-only stops. Uppercase WORD motions still follow whitespace boundaries. A motion is not a text object: Spider does not automatically make `iw` mean “subword”.

The jump list records jumps rather than every small cursor movement. Use it to return after inspecting another location, including another file.

### Overview 4: Opening files

**Root** is the project context detected from the current buffer, language servers, and root markers. **Cwd** is the working directory you started in or selected with `:cd`. They often match, but nested projects and monorepos can separate them. Switch to the cwd picker when root detection narrows the file list unexpectedly.

Pickers filter a collection; the same interface serves files, buffers, symbols, references, and other lists. File-name matching is fuzzy and normally uses smart case. Live grep searches file contents with a different query interpretation.

MiniFiles exposes directories as editable buffers. Renaming, copying, moving, and deleting entries use ordinary editing operations, followed by an explicit synchronization. Opening a file with `l` leaves the browser available for more selections.

### Overview 6: Basic editing

Think **action + extent**. `d` removes, `c` replaces, `y` copies; motions and text objects determine the extent. A doubled operator commonly means the whole line. Counts often extend the affected region rather than literally running separate commands.

Choose `c` when replacing text so dot-repeat captures both removal and insertion. Dot repeats one change; a macro repeats a sequence. Macros are more reliable when each iteration establishes a predictable starting position and uses searches or structural motions.

Undo history branches when you undo and then make a different edit. `u` and redo handle ordinary recovery; Undotree exposes alternate branches when needed.

### Overview 7: Objects and operators

**Motions** describe a path from the cursor. **Text objects** describe a region, often independent of the cursor's exact position within it. `i` preserves surrounding context; `a` includes it. This makes `ciw` convenient for replacement and `daw` convenient for removal without leftover spacing.

mini.ai extends objects, searches nearby, and adds next/previous forms. Tree-sitter supplies syntax-aware regions; Flash's `S` makes those regions selectable by visible labels. Remote operations apply an operator elsewhere and return you to your working location.

Surround operations edit the delimiters while preserving contents. This differs from `da(`, which removes both delimiters and their contents. Nested counts and highlight previews help distinguish nearby or enclosing pairs.

### Overview 8: Clipboard, registers, and visual modes

Registers store both text and macros. Deletes and changes normally write to registers, so they can replace the text you intended to paste. Use a named register for durable temporary storage, register `0` for the last yank, the black hole for deliberate discards, or Yanky's history to recover an earlier entry.

Characterwise, linewise, and blockwise text retain different put behavior. Use linewise selection for moving complete lines; use a visual block for columns or repeated prefixes/suffixes.

A recorded macro is editable text: put its register into a temporary buffer, modify the commands, then yank the exact result back into the same register. Avoid adding an unintended newline. Yanky adds searchable history and indentation-aware puts beyond the built-in register machinery.

### Overview 9: Buffers, windows, tabs, and sessions

| Concept | Remember |
| --- | --- |
| Buffer | In-memory text, possibly unsaved; shared across all its views. |
| Window | A viewport showing one buffer. Two windows can show different locations in the same buffer. |
| Tab | A layout of windows; all tabs share the buffer collection. |
| Bufferline | A visual list of buffers, even though its entries resemble tabs. |
| Fold | Hidden text within a view; folding does not remove text. |
| Session | Saved working layout and file context, associated with a directory. |

Closing a window and closing a buffer are different operations. Use tabs for distinct layouts rather than one tab per file. Session restoration recreates working context; it is not a substitute for saving file contents. Scratch buffers provide automatically persisted notes, scoped by context such as cwd and branch.

### Overview 10: Language support

| Component | Responsibility |
| --- | --- |
| Language server / LSP | Semantic navigation, completion, diagnostics, code actions, sometimes formatting. |
| Tree-sitter | Syntax structure for highlighting, objects, navigation, and folding. |
| Mason | Install editor-facing tools and make their executables available. |
| Language extra | Connect appropriate tools and plugins for a language. |
| nvim-lint | Run external linters and publish their diagnostics. |
| Conform | Run configured formatters, usually on save. |

Installing a tool and configuring the editor to use it are separate requirements. When something fails, check the buffer's filetype, server attachment, root, executable availability, and diagnostic messages.

**Quickfix** is a shared list of locations. A **location list** belongs to one window. **Trouble** presents diagnostics and other location collections with grouping and previews. Keep references or search results there when you need to visit several files and make edits.

### Overview 11: Navigating source files

LSP navigation follows meaning: definitions, implementations, types, and references. Text search follows character patterns. Prefer semantic navigation when investigating a symbol; use search when the server cannot resolve it or when looking for arbitrary strings.

The document-symbol picker is a searchable outline. Trouble keeps an outline visible; Tree-sitter context keeps enclosing signatures visible while scrolling. Workspace symbol coverage and speed depend on the server.

Marks are explicit bookmarks. Lowercase marks belong to a buffer, uppercase marks can cross files, and automatic marks remember selections and changes. Apostrophe jumps by line; backtick preserves the exact column. Marks also serve as endpoints in Ex ranges.

### Overview 12: Searching

Use `/` and `?` within a buffer, and live grep across files. LazyVim makes `n` mean downward and `N` upward regardless of the initial search direction; native Vim's defaults differ.

Know which regex engine you are using. Native search and `:substitute` use Vim patterns. Live grep, rip-substitute, and Grug-far use ripgrep-based matching. A pattern copied from one interface may mean something different in another.

Smart case is convenient until case itself matters; add `\c` or `\C` in native patterns to be explicit. Use `\V` for mostly literal text. Export multi-file results to Quickfix or Trouble instead of repeatedly rebuilding the same search.

### Overview 13: Replacing and bulk editing

| Need | Tool |
| --- | --- |
| Repeat one local change | Dot-repeat. |
| Repeat a multi-step edit | Macro. |
| Replace a symbol semantically | LSP rename. |
| Replace a pattern in a buffer | `:substitute` or rip-substitute. |
| Replace across files | Grug-far. |
| Change naming style or preserve it during replacement | text-case. |
| Apply the same interactive edit in several places | Native multicursors, when available. |
| Execute keys on contiguous lines | `:normal` with a range. |
| Execute an Ex command on matching lines | `:global`. |

For substitution, **range chooses lines; `g` chooses all matches per line**. Visual Ex ranges are line-based. Captures let replacements reuse matched text.

`:normal` honors mappings; `:normal!` bypasses them. `:global` filters lines before executing its command. The command-line window lets you revise complex commands using ordinary editing motions.

### Overview 14: Miscellaneous editing

Commenting and indentation are operators, so they compose with the same objects and motions as deletion. Dial extends increment/decrement beyond integers to configured booleans, dates, versions, and other sequences.

Keep three operations distinct: **reindent** adjusts leading whitespace, **reflow** wraps prose to a target width, and a **formatter** applies language-specific formatting rules. External filters replace selected lines with a program's output and can handle sorting, conversion, or custom transformations.

Spelling uses its own navigation rather than diagnostic jumps. Abbreviations expand short triggers; snippets add editable placeholders and navigation. Completion chooses the snippet or symbol, while snippet navigation moves through its fields. An active placeholder uses Select mode, where typing replaces its contents.

### Overview 15: Source control

The **working tree** contains current files, the **index** contains staged changes, and **HEAD** is the checked-out commit. Staging copies a change into the index; undo-staging retains working edits; resetting a hunk discards working changes relative to its comparison base.

Use Gitsigns for nearby hunks, the Git status picker for changed files, and Lazygit for broader repository operations. Generic diff commands copy text between compared buffers; in an index comparison, Gitsigns staging commands make the intended Git operation clearer.

For complex conflicts, the configured merge layout shows LOCAL, BASE, REMOTE, and the editable MERGED result. Buffer numbers depend on how the files were opened; inspect them before using numbered `:diffget`. For smaller conflicts, choose sections directly and then review the result for correctness. Choosing both is only a textual combination.

### Overview 17: Debugging

**DAP** connects the editor to a debugger through a language-specific adapter. The shared UI provides breakpoints, stepping, call stacks, variables, watches, and expression evaluation.

A routine session is: set a breakpoint → run or attach → inspect values → step or continue → terminate. Step **into** enters a call, **over** executes it as one step, and **out** returns to its caller. Conditional breakpoints reduce repeated stops.

Remote/container debugging additionally needs a reachable debugger endpoint and correct local-to-remote source paths. Browser debugging needs a running debug endpoint and a compatible JavaScript adapter. The book's Go and Chrome setups illustrate these relationships; ports, adapters, and launch details remain environment-specific. Program output may remain in the launching terminal.

### Overview 18: Testing

Neotest gives different test frameworks a common UI. A framework adapter handles discovery, invocation, and results; the project's actual test runner still needs to be available. A language extra may supply the adapter, but some languages offer several runners and require an explicit choice.

Run the nearest test while iterating, a file for related coverage, or cwd for the suite. Use summary marks for a temporary subset, watch mode for repeated runs, output for failure details, and DAP for inspection during execution.

The custom-adapter section's essential contract is:

| Method | Responsibility |
| --- | --- |
| `root` | Locate the test project. |
| `filter_dir` | Exclude irrelevant directories. |
| `is_test_file` | Identify candidate test files. |
| `discover_positions` | Return the test/namespace hierarchy and source locations. |
| `build_spec` | Build the command, cwd, and context for the requested run. |
| `results` | Convert runner output into results keyed by discovered test identifiers. |

### Checking a mapping in your own installation

The book, plugin versions, and personal configuration can disagree. `:verbose nmap <leader>hb`, `:verbose imap ;;`, and `:verbose nmap <C-l>` show the effective mappings and where they were defined. Use `:help {command}` for your installed Neovim version, and `g?` or `?` in plugin interfaces for their local help.
