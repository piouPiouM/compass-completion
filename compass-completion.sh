#!bash
#
# compass-completion
# ==================
# 
# Bash completion support for [Compass][compass].
# 
# Installation
# ------------
# 
# The easiest way (but not necessarily the cleanest) is to copy it somewhere
# (e.g. `~/.compass-completion.sh`) and put the following line in your `.bashrc`:
# 
#     source ~/.compass-completion.sh
# 
# Otherwise, the most comprehensive methodology is as follows:
# 
# 1. If you have not already done:
# 
#    1. Create the directory `~/bash_completion.d`.
# 
#    2. Put the following lines in your `.bashrc` to enable the bash completion:
# 
#       ~~~
#       export USER_BASH_COMPLETION_DIR=~/bash_completion.d
#       if [ -f /etc/bash_completion ]; then
#         . /etc/bash_completion
#       fi
#       ~~~
# 
#       *Note:* the bash_completion script can be at a different location depending on your system, like:
# 
#         * `/etc/bash_completion` (debian like)
#         * `/usr/local/etc/bash_completion` (BSD like)
#         * `/opt/local/etc/bash_completion` (macports)
# 
#    3. Put in the ~/.bash_completion file the following code:
# 
#       ~~~
#       # source user completion directory definitions
#       if [[ -d $USER_BASH_COMPLETION_DIR && -r $USER_BASH_COMPLETION_DIR && \
#             -x $USER_BASH_COMPLETION_DIR ]]; then
#           for i in $(LC_ALL=C command ls "$USER_BASH_COMPLETION_DIR"); do
#               i=$USER_BASH_COMPLETION_DIR/$i
#               [[ ${i##*/} != @(*~|*.bak|*.swp|\#*\#|*.dpkg*|*.rpm@(orig|new|save)|Makefile*) \
#                  && -f $i && -r $i ]] && . "$i"
#           done
#       fi
#       unset i
#       ~~~
# 
# 2. Copy the `compass-completion.sh` file in your ~/bash_completion.d (e.g. `~/bash_completion.d/compass`).
# 3. Reload your shell.
# 
# License
# -------
# 
# Copyright (c) 2011 [Mehdi Kabab][blog]  
# Released under [MIT License][license].
# 
# [blog]: http://pioupioum.fr/
# [compass]: http://compass-style.org/
# [license]: http://opensource.org/licenses/mit-license.php "The MIT License"

__compasscomp_cur ()
{
    [[ "$cur" == --* ]] && __compasscomp "$*"
    return 0
}

__compasscomp ()
{
    COMPREPLY=( $(compgen -W "$*" -- "$cur") )
    return 0
}

_compass ()
{
    local cur cword prev
    local global_options project_options primary_commands other_commands
    local frameworks patterns fmw

    COMPREPLY=()
    _get_comp_words_by_ref cur prev cword

    global_options="--require --load --load-all --quiet \
                    --trace --force --dry-run --boring \
                    --help"

    project_options="--config --app --sass-dir --css-dir \
                     --images-dir --javascripts-dir --environment \
                     --output-style --relative-assets"

    primary_commands="compile create init watch"

    other_commands="config frameworks grid-img imports install \
                    interactive stats unpack validate"

    frameworks="$(compass frameworks --quiet)"
    fmw=$(echo -n "$frameworks" | tr -s '\n' '|')
    patterns=( "$(compass frameworks | grep -oE "(${fmw})/[^ ]+")" )
    unset fmw

    # The compass command
    if [[ cword -eq 1 ]]; then
        case "$cur" in
            --*)
                __compasscomp $global_options
                ;;
            *)
                __compasscomp $primary_commands $other_commands "version help"
                ;;
        esac
    fi

    case "$prev" in
        help)
            __compasscomp $primary_commands $other_commands
            ;;
        compile|interactive|stats|unpack|validate)
            __compasscomp_cur $global_options $project_options
            ;;
        config)
            __compasscomp_cur $global_options $project_options "--debug"
            ;;
        frameworks)
            __compasscomp_cur $global_options "--bare"
            ;;
        grid-img)
            __compasscomp_cur $global_options
            ;;
        init)
            __compasscomp_cur $global_options $project_options "--using --syntax --prepare"
            ;;
        install)
            __compasscomp_cur $global_options $project_options "--syntax"
            ;;
        version)
            __compasscomp_cur "--quiet --major --minor --patch --revision --help"
            ;;
        watch)
            __compasscomp_cur $global_options $project_options "--poll"
            ;;
        --environment)
            __compasscomp "development production"
            ;;
        --output-style)
            __compasscomp "nested expanded compact compressed"
            ;;
        --sass-dir|--css-dir|--images-dir|--javascripts-dir|--load|--load-all)
            _filedir -d
            ;;
        --syntax)
            __compasscomp "sass scss"
            ;;
        --using)
            __compasscomp $frameworks $patterns
            ;;
    esac

} # _compass()

complete -o default -F _compass compass
