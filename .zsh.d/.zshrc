export PATH=${HOME}/.local/bin/:${HOME}/.dotfiles/bin:${PATH}

# keybind
bindkey -e

# history
HISTFILE=${HOME}/.zsh_history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE

setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history
setopt share_history

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end

# prompt
setopt prompt_subst
setopt prompt_percent
setopt transient_rprompt

function setup_prompt {
	local esc=$(echo -ne "\033")
	local color_black="%{${esc}[30m%}"
	local color_red="%{${esc}[31m%}"
	local color_green="%{${esc}[32m%}"
	local color_yellow="%{${esc}[33m%}"
	local color_blue="%{${esc}[34m%}"
	local color_magenta="%{${esc}[35m%}"
	local color_cyan="%{${esc}[36m%}"
	local color_white="%{${esc}[37m%}"
	local color_bold_black="%{${esc}[30;1m%}"
	local color_bold_red="%{${esc}[31;1m%}"
	local color_bold_green="%{${esc}[32;1m%}"
	local color_bold_yellow="%{${esc}[33;1m%}"
	local color_bold_blue="%{${esc}[34;1m%}"
	local color_bold_magenta="%{${esc}[35;1m%}"
	local color_bold_cyan="%{${esc}[36;1m%}"
	local color_bold_white="%{${esc}[37;1m%}"
	local color_default="%{${esc}[0m%}"

	local ps_user="${color_red}%n${color_default}"
	local ps_dir="${color_white}%1~${color_default}"
	local ps_host=" ${color_cyan}%m${color_default}"

	if [ -z "${REMOTEHOST}${SSH_CONNECTION}" ]; then
		ps_host=''
	fi

	autoload -Uz vcs_info
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr "${color_red}"
	zstyle ':vcs_info:git:*' unstagedstr "${color_bold_red}"
	zstyle ':vcs_info:git:*' formats " ${color_green}%c%u(%b)${color_default}"
	zstyle ':vcs_info:git:*' actionformats " ${color_green}%c%u(%b|%a)${color_default}"

	autoload -Uz add-zsh-hook
	add-zsh-hook precmd vcs_info

	PROMPT="[${ps_user}${ps_host}:${ps_dir}"'${vcs_info_msg_0_}'"]%(!.#.$) "
}

setup_prompt
unset setup_prompt

# homebrew
if type brew &>/dev/null; then
	function setup_brew {
		local brew_prefix=$(brew --prefix)
		FPATH=${brew_prefix}/share/zsh-completions:${brew_prefix}/share/zsh/site-functions:${FPATH}

		local asdf_path=${brew_prefix}/opt/asdf/libexec/asdf.sh
		if [ -f "${asdf_path}" ]; then
			source "${asdf_path}"
			FPATH=${brew_prefix}/opt/asdf/share/zsh/site-functions:${FPATH}
		fi

		export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${brew_prefix}/opt/openssl@1.1"
	}

	setup_brew
	unset setup_brew
fi

# completion
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:cd:*' ignore-parents parent pwd

setopt complete_in_word

# other
REPORTTIME=3

# ni
NI_PATH=$(dirname $0)/ni.zsh

if [ ! -f "${NI_PATH}" ]; then
	curl -o "${NI_PATH}" https://raw.githubusercontent.com/azu/ni.zsh/main/ni.zsh
fi

if [ -f "${NI_PATH}" ]; then
	source "${NI_PATH}"
fi

# alias
case ${OSTYPE} in
freebsd* | darwin*)
	alias ls='ls -FGw'
	;;
linux*)
	alias ls='ls --color'
	;;
esac

alias ll='ls -lah'
alias su='su -l'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep='grep --color'

alias 'cd-'='cd -'
alias 'cd..'='cd ..'

export LESS='-iMR'

if type emacs &>/dev/null; then
	EDITOR=emacs
fi
alias e="$EDITOR"

alias now='date +"%Y%m%d%H%M%S"'
alias ymd='date +"%Y%m%d"'

if type colordiff &>/dev/null; then
	alias diff='colordiff -u'
else
	alias diff='diff -u'
fi

if type git &>/dev/null; then
	alias gb='git --no-pager branch'
	alias gg='git grep'
	alias gst='git --no-pager status --short --branch && git --no-pager stash list'

	function gstf {
		git --no-pager status --short | awk -v q="${1}" "BEGIN{n=int(q);if(n\"\"!=q)n=0;if(q==\"0\")q=\"\"}{if(n==0?\$2~q:NR==n)print\$2}"
	}

	function gsta {
		git add "${@:2}" $(gstf "${1}")
	}

	function gstd {
		git diff --indent-heuristic --ignore-space-change --histogram "${@:2}" -- $(gstf "${1}")
	}

	function git-user-config {
		git config user.name "${1}"
		git config user.email "${2}"
	}
fi

if type bundle &>/dev/null; then
	alias bundle-install='bundle install --path vendor/bundle --without production'
	alias be='bundle exec'
fi

if type docker &>/dev/null; then
	if ! type shellcheck >/dev/null 2>&1; then
		alias shellcheck='docker run -it --rm -v $PWD:/mnt -w /mnt koalaman/shellcheck'
	fi

	if ! type shfmt >/dev/null 2>&1; then
		alias shfmt='docker run -it --rm -v $PWD:/mnt -w /mnt mvdan/shfmt'
	fi

	if ! type ffmpeg >/dev/null 2>&1; then
		alias ffmpeg='docker run -it --rm -v $PWD:/mnt -w /mnt jrottenberg/ffmpeg'
	fi

	if ! type ffprobe >/dev/null 2>&1; then
		alias ffprobe='docker run -it --rm --entrypoint=ffprobe -v $PWD:/mnt -w /mnt jrottenberg/ffmpeg'
	fi

	if ! type magick >/dev/null 2>&1; then
		alias magick='docker run -it --rm --entrypoint=magick -v $PWD:/mnt -w /mnt dpokidov/imagemagick'
	fi

	if ! type composite >/dev/null 2>&1; then
		alias composite='docker run -it --rm --entrypoint=composite -v $PWD:/mnt -w /mnt dpokidov/imagemagick'
	fi

	if ! type convert >/dev/null 2>&1; then
		alias convert='docker run -it --rm -v $PWD:/mnt -w /mnt dpokidov/imagemagick'
	fi

	if ! type identify >/dev/null 2>&1; then
		alias identify='docker run -it --rm --entrypoint=identify -v $PWD:/mnt -w /mnt dpokidov/imagemagick'
	fi

	if ! type mogrify >/dev/null 2>&1; then
		alias mogrify='docker run -it --rm --entrypoint=mogrify -v $PWD:/mnt -w /mnt dpokidov/imagemagick'
	fi

	if ! type montage >/dev/null 2>&1; then
		alias montage='docker run -it --rm --entrypoint=montage -v $PWD:/mnt -w /mnt dpokidov/imagemagick'
	fi
fi

if type ffmpeg >/dev/null 2>&1; then
	function ffmpeg-mp4 {
		ffmpeg -i $1 -pix_fmt yuv420p ${1%.*}.mp4
	}

	function ffmpeg-gif {
		local tmp_palette=.tmp-${1%.*}.png
		ffmpeg -i $1 -vf "palettegen" -y $tmp_palette
		ffmpeg -i $1 -i $tmp_palette -lavfi "fps=12,scale=900:-1:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:di\
ff_mode=rectangle" -y ${1%.*}.gif
		rm -f $tmp_palette
	}
fi

if [ "$(uname)" = 'Darwin' ]; then
	alias coteditor='open -a CotEditor'

	if type git >/dev/null 2>&1; then
		function gsed {
			sed -i '' "s/${1}/${2}/g" $(git grep -l "${1}" "${@:3}")
		}
	fi
fi
