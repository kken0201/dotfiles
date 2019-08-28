# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=/usr/local/bin/vim

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager

# -------------------------------------
# zshのオプション
# -------------------------------------

# 補完を有効にする

autoload -U compinit
compinit
zstyle ':completion:*:default' menu select=1


## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups


# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# zshのコマンド実行時にプロンプトの時刻を更新する
re-prompt() {
    zle .reset-prompt
    zle .accept-line
}

zle -N accept-line re-prompt

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
   $HOME/bin(N-/)
   /usr/local/bin(N-/)
   /usr/local/sbin(N-/)
   $path
)

# -------------------------------------
# ブランチを右プロンプトに表示
# -------------------------------------

# ${fg[...]} や $reset_color をロード
autoload -U colors; colors

function rprompt-git-current-branch {
       local name st color

       if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
               return
       fi
       name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
       if [[ -z $name ]]; then
               return
       fi
       st=`git status 2> /dev/null`
       if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
               color=${fg[green]}
       elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
               color=${fg[yellow]}
       elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
               color=${fg_bold[red]}
       else
               color=${fg[red]}
       fi

       # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
       # これをしないと右プロンプトの位置がずれる
       echo "%{$color%}$name%{$reset_color%} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'

# -------------------------------------
# プロンプトに表示
# -------------------------------------

PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~%# "
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%}%#"
PROMPT="%n@%m %# "
PROMPT="%n@%m %{${fg[green]}%}%#%{${reset_color}%} "

# -------------------------------------
# エイリアス
# -------------------------------------

# -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -a"
alias l1="ls -1"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# emacsをCUIで開く
alias e="emacs -nw"

# hubでプルリクを作成
alias mkpr="hub -c core.commentChar='%' pull-request"

# https://github.com/motemen/git-browse-remote
alias oppr="git browse-remote --pr"

# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
  echo
  cd ..
  zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# その他
# -------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ls }

# iTerm2のタブ名を変更する
function title {
   echo -ne "\033]0;"$*"\007"
}

# シェルのリロード
alias reload="exec $SHELL -l"

# branchのお掃除
alias clean-branch="git branch --merged | grep -v '*' | xargs -I % git branch -d %"

# リモートデバッグを有効にしたChromeを起動する
alias dbg="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222"

# 新しいブログ記事を作成し該当のMarkdownをAtomで開く
alias mydays="hugo new days/$(date +%Y%m%d).md --editor='code'"

# homebrew
export PATH=/usr/local/bin:$PATH

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
for D in `ls $HOME/.anyenv/envs`
do
export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
done

# yarn
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:`yarn global bin`"
