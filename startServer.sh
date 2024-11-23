#!/bin/sh
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Variables
_script=$(readlink -f "$0")
_scriptpath=$(dirname "$_script")

_jvmminram=512M
_jvmmaxram=2018M

_runnerargs="-Xms$_jvmminram -Xmx$_jvmmaxram -Dcom.mojang.eula.agree=true -jar"
_gameargs="nogui"
# }}}

# {{{ Run server
cd $_scriptpath
java $_runnerargs $_scriptpath/papermc.jar $_gameargs
# }}}
