VIMS_EDIT_TEMPLATE='"VIMS SNIPPETS:
"terminal zsh -is eval "..."
'

local vims_sessions_root=~/dotfiles/nvim/sessions
local vim_base_session=~/dotfiles/nvim/Session.vim

function __vimsType { echo "${1:-default}" }

function __vimsLoc { echo "${vims_sessions_root}$(pwd)/$(__vimsType $1).vim" }

function _vimsEdit {
    local session_location="$(__vimsLoc $1)"
    mkdir -p "$(dirname $session_location)"
    [[ ! -f $session_location ]] && echo "$VIMS_EDIT_TEMPLATE" > "$session_location"
    vim "$session_location"
}

function _vimsOpen {
    if [[ $# > 1 ]]; then
        echo "[VIMS]: CAN ONLY OPEN ONE SESSION"
        return 2
    fi
    local session_type="$(__vimsType $1)"
    if [ ! -f `__vimsLoc $session_type` ]; then
        echo "[VIMS]: FILE NOT FOUND '`__vimsLoc $session_type`'"
        return 2
    fi
    vim --cmd "let g:vims_session_type='$session_type'" \
        --cmd "let g:vims_sessions_root='$vims_sessions_root'" \
        -S "$vim_base_session" "${@:2}"
}

function __vimsList { find "$vims_sessions_root$(pwd)" -type f -maxdepth 1 }

function _vimsShow { for i in `__vimsList`; do echo "===> $i <==="; cat $i; done }

function _vimsList { __vimsList | xargs -I_ basename _ | sed 's/.vim$//' }

function _vimsHelp { echo $__DOC }

function vims {
    local __DOC="vims [edit|help|list|show] [SESSION]"
    local sub_cmd="$1"
    case "$sub_cmd" in
        edit) _vimsEdit "${@:2}" ;;
        help) _vimsHelp "${@:2}" ;;
        list) _vimsList "$@" ;;
        show) _vimsShow "$@" ;;
        *) _vimsOpen "$@" ;;
    esac
}
