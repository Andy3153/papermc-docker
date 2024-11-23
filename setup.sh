#!/bin/sh
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Message
printf "\033[34m#### PaperMC Docker Image: building... ####"
# }}}

# {{{ Installing dependencies
printf "\033[34m\n#### Installing dependencies ####\033[0m\n"
apt update
apt install --yes curl wget openjdk-21-jre screen
# }}}

# {{{ Variables
_game="papermc"

_papermcver="1.21.1"
_papermcbuild=$(curl -s -X GET "https://papermc.io/api/v2/projects/paper/versions/${_papermcver}" -H  "accept: application/json" | tr '\n' ' ' | sed -e 's/[^0-9]/ /g' -e 's/^ *//g' -e 's/ *$//g' | tr -s ' ' | sed 's/ /\n/g' | sort -n -r | head -n 1) # get latest build number from papermc api
_source="https://papermc.io/api/v2/projects/paper/versions/${_papermcver}/builds/${_papermcbuild}/downloads/paper-${_papermcver}-${_papermcbuild}.jar"

_dest="${_game}-${_papermcver}_${_papermcbuild}.jar"

_user="${_game}"
_papermcfolder="/home/${_user}"
# }}}

# {{{ Create user
printf "\033[34m\n#### Creating user ####\033[0m\n"
useradd --home-dir "${_papermcfolder}" --comment "PaperMC Server" "${_user}"
mkdir "${_papermcfolder}"
# }}}

# {{{ Download PaperMC
printf "\033[34m\n#### Downloading PaperMC ####\033[0m\n"
cd "${_papermcfolder}" || return
wget -P "${_papermcfolder}" -O "${_dest}" "${_source}"
ln -s "${_papermcfolder}/${_dest}" "${_papermcfolder}/${_game}.jar"
# }}}

# {{{ Move files in server's folder
printf "\033[34m\n#### Moving required files ####\033[0m\n"
mv /papermcctl "${_papermcfolder}"
mv /startServer.sh "${_papermcfolder}"

mv /eula.txt "${_papermcfolder}"
mv /server.properties "${_papermcfolder}"
# }}}

# {{{ Final steps/cleanup
printf "\033[34m\n#### Cleanup ####\033[0m\n"
ln -s "${_papermcfolder}"/papermcctl /bin  # Link scripts to the path
apt remove --yes curl wget             # Remove no longer needed programs
apt clean                              # Clear apt cache
chown -R "${_user}:${_user}" "${_papermcfolder}" # Fix file permissions
rm /setup.sh                           # Cleanup
# }}}
