#
# Samu
#

# Basic zsh config.
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${HOME}/.config/zsh.d"
HISTFILE="${ZDOTDIR}/.zsh_history"
HISTSIZE='100000'
SAVEHIST="${HISTSIZE}"

# Basic options
setopt beep  
setopt noflowcontrol
setopt extendedglob
setopt autocd
setopt hist_ignore_dups

bindkey -e

# Completion
autoload -Uz compinit
compinit
autoload -U bashcompinit
bashcompinit


zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{red}%d%f%u'
zstyle :compinstall filename '/home/js/.zshrc'

autoload -Uz compinit
autoload colors
colors
compinit
autoload -Uz promptinit
promptinit

SEP="%{$fg[red]%}%B:%B%{$reset_color%}"
export PS1="[%n%{$fg[red]%}%B@%B%{$reset_color%}%m]${SEP}%(?..%?%B%{$fg[red]%}:%B%{$reset_color%})<%~>%{$fg[red]%}%B$%B%{$reset_color%} "

bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "^[OH"  beginning-of-line
bindkey "^[OF"  end-of-line
bindkey "^[[5~" beginning-of-history
bindkey "^[[6~" end-of-history
bindkey "^[[2~" quoted-insert
bindkey "^[[3~" delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

termtitle() {
        case "$TERM" in
                rxvt*|xterm|nxterm|gnome|screen|screen-*)
                        case "$1" in
                                precmd)
                                        print -Pn "\e]0;%n@%m: %~\a"
                                ;;
                                preexec)
                                        zsh_cmd_title="$2"
                                        # Escape '\' char.
                                        zsh_cmd_title="${zsh_cmd_title//\\/\\\\}"
                                        # Escape '$' char.
                                        zsh_cmd_title="${zsh_cmd_title//\$/\\\\\$}"
                                        # Escape '%' char.
                                        #zsh_cmd_title="${zsh_cmd_title//%/\%\%}"
                                        # As I am unable to deal with all %, especialy
                                        # the nasted one, I will just strip this char.
                                        zsh_cmd_title="${zsh_cmd_title//\%/<percent>}"
                                        print -Pn "\e]0;${zsh_cmd_title} [%n@%m: %~]\a"
                                ;;
                        esac
                ;;
        esac
}

# Keys.
case $TERM in
    xterm)
        bindkey "^[OH" beginning-of-line
        bindkey "^[OF" end-of-line
        bindkey "^[[3~" delete-char
        bindkey "^[[1;5D" backward-word
        bindkey "^[[1;5C" forward-word
        
    ;;
    
    linux)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward
        bindkey "^[[B" history-beginning-search-forward
    ;;

    screen|screen-*)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;
        
    rxvt*)
        bindkey "^[[7~" beginning-of-line #Home key
        bindkey "^[[8~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;

    screen|screen-*)
        bindkey "^[[1~" beginning-of-line #Home key
        bindkey "^[[4~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;
    
    rxvt*)
        bindkey "^[[7~" beginning-of-line #Home key
        bindkey "^[[8~" end-of-line #End key
        bindkey "^[[3~" delete-char #Del key
        bindkey "^[[A" history-beginning-search-backward #Up Arrow
        bindkey "^[[B" history-beginning-search-forward #Down Arrow
        bindkey "^[Oc" forward-word # control + right arrow
        bindkey "^[Od" backward-word # control + left arrow
        bindkey "^H" backward-kill-word # control + backspace
        bindkey "^[[3^" kill-word # control + delete
    ;;
esac


#
# Git functions
#

function git_current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo ${ref#refs/heads/}
}

function git_current_repository() { 
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo $(git remote -v | cut -d':' -f 2)
}

function git_status() {
    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        STATUS+="U"
    fi
    if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
        STATUS+="A"
    elif $(echo "$INDEX" | grep '^M ' &> /dev/null); then
        STATUS+="A"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
        STATUS+="M"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
        STATUS+="M"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
        STATUS+="M"
    fi
    if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
        STATUS+="R"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
        STATUS+="D"
    elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
        STATUS+="D"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
        STATUS+="u"
    fi
    echo $STATUS
}

#
# Subversion functions
#
function svn_current_revision() {
    INDEX=$(svn info  2> /dev/null |egrep "Wersja|Revision" |awk '{print $2}') || return
    echo $INDEX    
}

function svn_status() {
    INDEX=$(svn status 2> /dev/null)
    STATUS=""
    if $(echo "$INDEX" | grep '^? ' &> /dev/null); then
        STATUS+="U"
    fi
    if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
        STATUS+="A"
    elif $(echo "$INDEX" | grep '^M ' &> /dev/null); then
        STATUS+="A"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
        STATUS+="M"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
        STATUS+="M"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
        STATUS+="M"
    fi
    if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
        STATUS+="R"
    fi
    if $(echo "$INDEX" | grep '^C ' &> /dev/null); then
        STATUS+="C"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
        STATUS+="D"
    elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
        STATUS+="D"
    fi
    if $(echo "$INDEX" | grep '^..L ' &> /dev/null); then
        STATUS+="L"
    fi
    echo $STATUS
}

function port_vercomp() {
    awk '{ if ($1 > $2) {print ">"} else if ($1 < $2) {print "<"} else {print "="} }' <<< "$1 $2"
}

function port_isinstalled() {
    pkg_info -Ix $1 2> /dev/null > /dev/null && echo "installed"
}

#
# precmd/preexec bindings
#
function precmd() {
    case $TERM in
        rxvt*|xterm|nxterm|gnome|screen)
                        termtitle precmd
                        ;;
    esac
    
    repotype=0
    if [[ -e '.git' ]]; then
        isgit=$(git_current_branch)
        if [[ -n "$isgit" ]]; then
            repotype="git"
        fi
    fi
    if [[ -e '.svn' ]]; then
        issvn=$(svn_current_revision)
        if [[ -n "$issvn" ]]; then
            repotype="svn"
        fi
    fi
    
    if [[ "$PWD" =~ "/usr/ports/[^/]+/.+" ]]; then
        repotype="freebsd-port"
    fi
    
    if [[ $repotype != 0 ]]; then
        RPROMPT="["
    fi

    if [[ $repotype == "git" ]]; then
        repostatus=$(git_status)
        RPROMPT+="git${SEP}$isgit"
        if [[ -n "$repostatus" ]]; then
             RPROMPT+="${SEP}$repostatus"            
        fi
    fi
    
    if [[ $repotype == "svn" ]]; then
        repostatus=$(svn_status)
        RPROMPT+="svn${SEP}$issvn"
        if [[ -n "$repostatus" ]]; then
             RPROMPT+="${SEP}$repostatus"            
        fi
    fi
    
    if [[ $repotype == "freebsd-port" ]]; then
        if [[ -e Makefile ]]; then
            oifs="$IFS"
            IFS='/'; arr=( ${=PWD} ); 
            RPROMPT+="${arr[4]}/${arr[5]}"
            IFS="$oifs"
            installed=$(port_isinstalled ${arr[5]})
            if [[ -n "$installed" ]]; then
                ppversion=$(grep PORTVERSION Makefile |awk '{print $2}')
                ipversion=$(pkg_info -Ix ${arr[5]} |head -n 1 )
                ipversion=${ipversion#*-}
                ipversion=${ipversion%_*} 
                RPROMPT+="${SEP}installed${SEP}$(port_vercomp $ppversion $ipversion)"
            else
                RPROMPT+="${SEP}not installed"
            fi
        fi
    fi
    
    if [[ $repotype != 0 ]]; then
        RPROMPT+="]"
    else
        unset RPROMPT
    fi
}

preexec () {
    case $TERM in
        rxvt*|xterm|nxterm|gnome|screen)
            termtitle preexec
            ;;
    esac
}
