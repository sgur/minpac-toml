Onepac: Install a series of vim packages using [minpac](https://github.com/k-takata/minpac)
=================

Description
-----------

Onepac imports packages from a json or toml file and calls `minpac#add()` for each entries.
And also call `minpac#install()` when the `-update` command specified.

Requirement
-----------

* Vim8 (`+job` and `+packages` required)
* [minpac](https://github.com/k-takata/minpac)

Usage
-----

### Commands

Execute `Onepac {-update,-clean} <filename>` where `filename` is a toml or json file.

Install
-------

Locate under the package directoy:

* `~/.vim/pack/default/start/vim-onepac`
* `~/.vim/pack/default/opt/vim-onepac` and execute `packadd vim-onepac`

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
