#!/bin/bash
# chsh -s /bin/zsh

#######################################
# Make symlinks
#######################################
WORKDIR="$(realpath $(dirname $(readlink -f ${0}))/..)"
CONFIG_TMP_DIR="${HOME}/tmp/hyprinstall"
CONFIG_HOME_DIR="${HOME}/.config"
PROGS_WORK_DIR="${WORKDIR}/progs"

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

make_symlink "${PROGS_WORK_DIR}/.config/yandex-browser" "${CONFIG_HOME_DIR}/yandex-browser"
make_symlink "${PROGS_WORK_DIR}/.config/Code" "${CONFIG_HOME_DIR}/Code"
