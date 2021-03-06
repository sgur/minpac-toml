Minpac-toml: Install a series of vim packages using [minpac](https://github.com/k-takata/minpac)
=================

Description
-----------

minpac-toml imports packages from a toml file and calls `minpac#add()` for each entries.
And also call `minpac#install()` when the `-update` command specified.

Requirement
-----------

* Vim8 (`+job` and `+packages` required)
* [minpac](https://github.com/k-takata/minpac)
* [restart.vim](https://github.com/tyru/restart.vim) (Optional)

Usage
-----

### Commands

Execute `MinpacToml {-update,-clean} <filename>` where `filename` is a toml file.

`MinpacToml` command with `!`(bang) restarts Vim after update. It use [restart.vim](https://github.com/tyru/restart.vim).

Install
-------

Locate under the package directoy:

* `~/.vim/pack/default/start/minpac-toml`
* `~/.vim/pack/default/opt/minpac-toml` and execute `packadd minpac-toml`

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
