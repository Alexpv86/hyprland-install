#!/bin/bash
chsh -s /bin/zsh

#######################################
# Make symlinks
#######################################
WORKDIR="$(realpath $(dirname $(readlink -f ${0}))/..)"
CONFIG_TMP_DIR="${HOME}/tmp/hyprinstall"
CONFIG_WORK_DIR="${WORKDIR}/config"
CONFIG_HOME_DIR="${HOME}/.config"

if [ ! -d ${CONFIG_TMP_DIR} ]; then
    mkdir -p ${CONFIG_TMP_DIR}
fi

function make_symlink() {
    if [[ ${1} == "" || ${2} == "" ]];then
        echo "Не указаны параметры"
        return
    fi

    if [ -d ${1} ] || [ -f ${1} ];then
        echo "Файл/папка ${1} не существует"
        return
    fi

    BASENAME="$(basename ${2})"
    TMP_PATH="${CONFIG_TMP_DIR}/${BASENAME}"

    if [ -d ${TMP_PATH} ] || [ -f ${TMP_PATH} ];then
        TMP_PATH="${CONFIG_TMP_DIR}/${BASENAME}.${RANDOM}"
    fi
 
    if [ -d ${2} ] || [ -f ${2} ]; then
        mv ${2} ${TMP_PATH}
    fi

    ln -s ${1} ${2}

}

make_symlink "${CONFIG_WORK_DIR}/.config/hypr" "${CONFIG_HOME_DIR}/hypr"
make_symlink "${CONFIG_WORK_DIR}/.config/kitty" "${CONFIG_HOME_DIR}/kitty"
make_symlink "${CONFIG_WORK_DIR}/.config/mako" "${CONFIG_HOME_DIR}/mako"
make_symlink "${CONFIG_WORK_DIR}/.config/nvim" "${CONFIG_HOME_DIR}/nvim"
make_symlink "${CONFIG_WORK_DIR}/.config/nwg-look" "${CONFIG_HOME_DIR}/nwg-look"
make_symlink "${CONFIG_WORK_DIR}/.config/waybar" "${CONFIG_HOME_DIR}/waybar"
make_symlink "${CONFIG_WORK_DIR}/.config/wlogout" "${CONFIG_HOME_DIR}/wlogout"
make_symlink "${CONFIG_WORK_DIR}/.config/wofi" "${CONFIG_HOME_DIR}/wofi"
make_symlink "${CONFIG_WORK_DIR}/.config/workstyle" "${CONFIG_HOME_DIR}/workstyle"

make_symlink "${CONFIG_WORK_DIR}/.oh-my-zsh" "${HOME}/.oh-my-zsh"
make_symlink "${CONFIG_WORK_DIR}/.p10k.zsh" "${HOME}/.p10k.zsh"
make_symlink "${CONFIG_WORK_DIR}/.zshrc" "${HOME}/.zshrc"
make_symlink "${CONFIG_WORK_DIR}/powerlevel10k" "${HOME}/powerlevel10k"

make_symlink "${WORKDIR}/home/Wallpapers" "${HOME}/Wallpapers"

if [ ! -d "${HOME}/Wallpapers" ]; then
    mkdir -p "${HOME}/Wallpapers"
fi
