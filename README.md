# THIS REPOSITORY IS ARCHIVED

This repository is archived and will not be developed any further. If you like the non-lsp-renaming technique using regex behind this plugin, feel free to fork this plugin and develop it further.

If your interested into using the java snippets of this plugin, look [here](https://github.com/simaxme/java-snippets.nvim).


<p align="center">
    <img src="https://github.com/simaxme/java.nvim/blob/main/images/neovim_java.png?raw=true" align="center" width="100">
</p>

# java.nvim
A neovim plugin to move and rename java files.

## Introduction
I am a Java developer and am loving to use neovim. Nevertheless, refactoring was the thing that always brought me back to JetBrains IDEs. Although [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) is existing, which is able to simply rename symbols, file renames were never possible with it. For instance, tsserver-LSP has this feature. Because I really wanted to use neovim as my dailydriver and file-renames are essential, I have written this plugin.

## Dependencies
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) (currently the only supported file editor, other may come later if requested)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (recommended for some java snippets)
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) (recommended)

## Function of this plugin
In current state, this plugin is a addition to [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls). It allows you to rename .java files and looks for any reference to the name and updates the import statements and symbol usages automaticaly. This does only work due to the use of lua-patterns and regex. 
I hope this plugin wil help someone with this basic feature of file refactoring. 

## Why have I named it java.nvim?
This can be simply answered: I want to add some features besides the refactoring of files that are helping in everyday Java use. For instance, I will try to add the ability for simple LuaSnip snippets that allow you to create a default class/interface/enum by using a simple snippet without needing to write all the same stuff again and again.

## Supported platforms
- Linux
- MacOS

## Installing the plugin
The plugin can be easily installed using dusing different Plugin Managers.

**Lazy**
```lua
-- other lazy stuff
{
    'simaxme/java.nvim'
}
-- other lazy stuff
```

You will also need to setup the plugin (see [Configuring the plugin](#configuring-the-plugin))

## Configuring the plugin
You can setup java.nvim with the following line:
```lua
require("java").setup()
```

However, there are some tweaks you can make (default configuration):
```lua
require("java").setup {
    rename = {
        enable = true, -- enable the functionality for renaming java files
        nvimtree = true, -- enable nvimtree integration
        write_and_close = false -- automatically write and close modified (previously unopened) files after refactoring a java file
    },
    snippets = {
        enable = true -- enable the functionality for java snippets
    },
    root_markers = { -- markers for detecting the package path (the package path should start *after* the marker)
        "main/java/",
        "test/java/"
    }
}
```

## Compatibility with nvim-java
Due to the owner of the [nvim-java](https://github.com/nvim-java/nvim-java) also naming his package `java` there may be compatibility issues. If you are using this package, it is recommended to use the alias `simaxme-java`:
```lua
require("simaxme-java").setup()
```

## All current functionalities

- [x] Detect file renames in nvim-tree and automatically update the class name and every associated files with the symbol.
- [x] Snippet integration with LuaSnip
    - [x] type `class`, `interface` or `enum` in an empty java file to automatically create a package and class/enum/interface declaration in the file.
    - [ ] autorun snippets for class creation
    - [ ] javadoc snippets

## After configuration
Go to your nvim-tree pane and execute a simple `r` on a java file or a package. Magic will happen and you will not have to do anything 🙃.
