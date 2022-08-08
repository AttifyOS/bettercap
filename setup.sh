#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/AttifyOS/bettercap/releases/download/bin-e224eea/bettercap-e224eea.tgz -O $APM_TMP_DIR/bettercap.tgz
  tar xf $APM_TMP_DIR/bettercap.tgz -C $APM_PKG_INSTALL_DIR/
  chmod +x $APM_PKG_INSTALL_DIR/bettercap
  ln -s $APM_PKG_INSTALL_DIR/bettercap $APM_PKG_BIN_DIR/bettercap

  echo "===================="
  echo "Install the following packages using apt before running bettercap for the first time"
  echo "- libnetfilter-queue1"
  echo "- libpcap0.8"
  echo "- libusb-1.0-0"
  echo
  echo "(Ignore if already installed)"
  echo "===================="
}

uninstall() {
  rm $APM_PKG_INSTALL_DIR/bettercap
  rm $APM_PKG_BIN_DIR/bettercap
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1