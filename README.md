minpac-loader: Json and Toml loader for [minpac](https://github.com/k-takata/minpac)
=================

Description
-----------

Minpac-loader imports a json or toml file and calls minpac#add() for each entries.

Requirement
-----------

* Vim8
* minpac

Usage
-----

### Functions

call `minpac#loader#json#load()` or `minpac#loader#toml#load()` for the appropriate format.

### Commands

Execute `MinpacLoader {-update,-clean} <filename>` where `filename` is a toml or json file.

Install
-------

Locate under the package directoy:

* `~/.vim/pack/default/start/vim-minpac-loader`
* `~/.vim/pack/default/opt/vim-minpac-loader` and execute `packadd vim-minpac-loader`

TOML Format
-----------

```toml
[[plugins]]
url = "tpope/vim-repeat"

[[plugins]]
url = "mattn/webapi-vim"

# Install to "opt" dir
[[plugins]]
url = "noahfrederick/vim-hemisu"
type = "opt"

# Install to "opt/dracula-vim"
[[plugins]]
url = "dracula/vim"
name = "dracula-vim"
type = "opt"

# Development repo ('wip' branch and no-shallow)
[[plugins]]
url = "sgur/chbuf.vim"
branch = "wip"
depth = 9999
```

JSON Format
-----------

There are two formats for JSON.

### Standard
```json
{
    "plugins": [
        "tpope/vim-repeat",
        "mattn/webapi-vim",
        {"url": "noahfrederick/vim-hemisu", "type": "opt"},
        {"url": "dracula/vim", "type": "opt", "name": "dracula-vim"},
        {"url": "sgur/chbuf.vim", "branch": "wip", "depth": 9999}
    ]
}
```

### Classified by folders
```json
{
    "start": [
        "tpope/vim-repeat",
        "mattn/webapi-vim",
        {"url": "sgur/chbuf.vim", "branch": "wip", "depth": 9999}
    ],
    "opt": [
        "noahfrederick/vim-hemisu",
        {"url": "dracula/vim", "name": "dracula-vim"}
    ]
}
```

License
-------

MIT License

Author
------

sgur
