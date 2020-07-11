# Installing gvim on windows

1. Install Chocolatey

    ~~~(powershell)
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ~~~

2. Install vim from Chocolatey

    ~~~(powershell)
    choco install vim-tux -y
    ~~~

3. Install Git

    ~~~(powershell)
    choco install git -y
    ~~~

4. Install vim package manager minpack

    ~~~(cmd)
    git clone https://github.com/k-takata/minpac.git %USERPROFILE%\vimfiles\pack\minpac\opt\minpac
    ~~~

5. Add package manager to vimrc

    edit %USERPROFILE%\vimfiles\vimrc

    ~~~(vim)
    "=== Initialize Package Manager
    packadd minpac

    call minpac#init()

    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " Add other plugins here.
    call minpac#add('lifepillar/vim-solarized8')

    " Define user commands for updating/cleaning the plugins.
    " Each of them loads minpac, reloads .vimrc to register the
    " information of plugins, then performs the task.
    command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
    command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
    command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

    ~~~

6. In vim execute

    ~~~(vim)
    run :source $MYVIMRC
    run :PackUpdate
    ~~~

7. Download a better font

    <https://math.berkeley.edu/~serganov/ilyaz.org/software/fonts/unifont-smooth-mono-10.0.06--1.171-merged-with-dejavu-2.36-no-Han-Hangul.7z>

    add to vimrc:

    ~~~(vim)
    set guifont=DejaVu_Sans_Mono_Unifont:h10:cANSI:qDRAFT
    ~~~

8. Install Lightline

    ~~~(vim)
    call minpac#add('itchyny/lightline.vim')
    Settings:
    set noshow
    set laststatus=2
    ~~~

9. Install Denite

    ~~~(powershell)
    choco install python -y
    ~~~

    ~~~(vim)

    call minpac#add('roxma/nvim-yarp')
    call minpac#add('roxma/vim-hug-neovim-rpc')
    call minpac#add('Shougo/denite.nvim')
    :PackUpdate
    ~~~

10. Install Coc.nvim

    ~~~(powershell)
    choco install nodejs -y
    ~~~

    ~~~(vim)
    call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
    call minpac#add('honza/vim-snippets')
    call minpac#add('sheerun/vim-polyglot')
    :PackUpdate
    ~~~
