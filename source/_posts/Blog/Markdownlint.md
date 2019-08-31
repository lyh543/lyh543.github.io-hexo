---
title: Markdownlint 使用
tags:
- Markdown
- Visual Studio Code
category:
- Blog
top: false
---

Markdownlint 是 Visual Studio Code 的一个 Markdown 插件。

![markdownlint_intro](markdownlint_intro.jpg)

[下载链接](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)

VSCode插件目录：`%userprofile%/.vscode/extensions`

## 如何忽略项

> Rules can be enabled, disabled, and customized by creating a JSON file named `.markdownlint.json` or a YAML file named `.markdownlint.yaml` (or .markdownlint.yml) in any directory of a project.

Visual Studio Code - `File`（工具栏） - `Preference` - `Settings` - `Extensions` - `markdownlint` - `Markdownlint: config` - `Edit in settings.json`

也可以直接到`%userprofile%AppData\Roaming\Code\User\settings.json`里面找到

```json
{
    "workbench.colorTheme": "Quiet Light",
    "markdownlint.config": {
        "default": true,
        "MD033": false,
        "MD014": false,
        "MD029": false,
        "MD040": false,
        "no-hard-tabs": false
    },
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "markdownlint.ignore": [
        "*/Markdown_语法.md"
    ]
}
```
