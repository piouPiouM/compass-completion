compass-completion
==================

Bash completion support for [Compass][compass].

Installation
------------

The easiest way (but not necessarily the cleanest) is to copy it somewhere
(e.g. `~/.compass-completion.sh`) and put the following line in your `.bashrc`:

    source ~/.compass-completion.sh

Otherwise, the most comprehensive methodology is as follows:

1. If you have not already done:

   1. Create the directory `~/bash_completion.d`.

   2. Put the following lines in your `.bashrc` to enable the bash completion:

      <pre>
export USER_BASH_COMPLETION_DIR=~/bash_completion.d
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
</pre>

      *Note:* the bash_completion script can be at a different location depending on your system, like:

        * `/etc/bash_completion` (debian like)
        * `/usr/local/etc/bash_completion` (BSD like)
        * `/opt/local/etc/bash_completion` (macports)

   3. Put in the `~/.bash_completion` file the following code:

      <pre>
\# source user completion directory definitions
if [[ -d $USER_BASH_COMPLETION_DIR && -r $USER_BASH_COMPLETION_DIR && \
    -x $USER_BASH_COMPLETION_DIR ]]; then
  for i in $(LC_ALL=C command ls "$USER_BASH_COMPLETION_DIR"); do
      i=$USER_BASH_COMPLETION_DIR/$i
      [[ ${i##\*/} != @(\*~|\*.bak|\*.swp|\#\*\#|\*.dpkg\*|\*.rpm@(orig|new|save)|Makefile\*) \
         && -f $i && -r $i ]] && . "$i"
  done
fi
unset i
</pre>

2. Copy the `compass-completion.sh` file in your ~/bash_completion.d (e.g. `~/bash_completion.d/compass`).
3. Reload your shell.

License
-------

Copyright (c) 2011 [Mehdi Kabab][blog]  
Released under [MIT License][license].

[blog]: http://pioupioum.fr/
[compass]: http://compass-style.org/
[license]: http://opensource.org/licenses/mit-license.php "The MIT License"
