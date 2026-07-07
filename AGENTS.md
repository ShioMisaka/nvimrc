# AGENTS.md

本文件为 AI 编码助手提供本项目的上下文指引。开发者使用任意 AI 工具（Claude Code、Cursor 等）时，工具会自动读取此文件。

## 项目概述

这是一个基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 的模块化 Neovim 配置，运行于 Neovim >= 0.10，目标平台为 WSL2 / Linux。语言以中文为主（注释、文档、commit message）。

## 目录结构

```
init.lua                  -- 入口，加载 lua/config/lazy.lua
lua/config/               -- 基础配置：options / keymaps / autocmds / lazy / lsp-utils
lua/plugins/              -- 每个文件 return {} 一个插件 spec，lazy 自动 import
docs/                     -- 各插件的中文操作文档（Markdown 表格为主）
README.md                 -- 用户向总览
lazy-lock.json            -- 插件版本锁，已锁定，禁用自动更新检查
```

## 配置约定

- **缩进**：4 空格，`expandtab`（`lua/config/options.lua`）。C/C++ 无 `.clang-format` 时回退 WebKit 风格（4 空格）。
- **插件管理**：每个插件一个独立文件 `lua/plugins/<name>.lua`，`return {}` 形式。新增插件即新增文件，无需改其他地方。
- **懒加载**：优先用 `event = "VeryLazy"` 或 `cmd`/`keys` 触发加载。
- **注释风格**：中文注释，说明"为什么"而非"是什么"。代码应与周围风格一致。
- **Leader 键**：`Space`。
- **退出插入模式**：`jk` / `kj`（非默认 Esc）。

## 文档约定

- 所有插件文档放 `docs/<plugin>.md`，文件名小写 kebab-case。
- 文档语言为中文，以表格为核心呈现形式（快捷键表、命令表）。
- 快捷键必须从源码 `vim.keymap.set()` 和插件 spec 的 `keys = {}` 中**实际提取**，不可凭记忆。
- 详细文档写作规范见 `.claude/skills/nvim-doc/SKILL.md`。

## 编辑此配置时的注意事项

- 修改 `lua/config/autocmds.lua` 等涉及自动事件的文件后，用 `nvim --headless -u NONE -c "luafile <file>" -c "qa!"` 验证语法。
- 涉及插入模式交互的功能（如括号配对、回车拆行）无法在 headless 下可靠测试，需让用户手动验证。
- 不要随意改动 `lazy-lock.json` 的插件版本——这是刻意锁定的，避免引入不可控变更。
- commit message 用中文，简短描述变更。
