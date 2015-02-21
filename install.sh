#!/bin/bash

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

getPkgMng() {
    case ${os,,} in
        fedora)
            pkgMgr="yum"
            ;;
        debian)
            pkgMgr="apt"
            ;;
        *)
            echo "Sorry $OS not supported ... "
            exit 1
    esac

    echo $pkgMgr
}

installPackages() {
    local os=$(lsb_release -si)
    local pkgs=("tmux" "python" "most" "vim" "python-pip")
    local pkgMgr=$(getPkgMng)

    for p in "${pkgs[@]}"
    do
        $pkgMgr install $p
    done
}

installMvn() {
    local urls=("http://apache.rediris.es/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz" "http://apache.rediris.es/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz" "http://apache.rediris.es/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz")
    cd /opt
    for u in "${urls[@]}"
    do
        echo "Getting $u"
        wget -P /opt/ -N $u
        echo "Untar ${u##*/}"
        tar --overwrite -xzf ${u##*/}
        echo "Delete ${u##*/}"
        \rm ${u##*/}
    done
    cd -
}

launchGitInit() {
    git submodule update --init --recursive
}

copyLinkFiles() {
    local copyFiles=("_gitconfig")

    for f in `find ./ -maxdepth 1 -name _\* -printf '%f\n'`;
    do
        dest=${f/_/.}

        if containsElement $f $copyFiles; then
            command="cp"
        else
            command="ln -s"
        fi

        if [[ -f $USER_HOME/$dest || -d $USER_HOME/$dest ]]; then
            mv $USER_HOME/$dest $USER_HOME/$dest.bak
        fi
        $command `pwd`/$f $USER_HOME/$dest
        if [[ -f $USER_HOME/$dest ]]; then
            sed -i "s/USERNAME/${username}/" $USER_HOME/$dest
        fi

        chown $SUDO_USER:$USER_GROUP $USER_HOME/$dest

    done
}

subVars() {
    sed -i "s/\(email =\).*/\1 ${email}/" $USER_HOME/.gitconfig
}

installVirtualEnvWrapper() {
    echo "Installing virtualenvwrapper ... "
    pip install virtualenvwrapper
    WORKON_HOME=$USER_HOME/Envs
    echo "Creating virtualenvwrapper $WORKON_HOME... "
    [ -d $WORKON_HOME ] || mkdir -p $WORKON_HOME
}

# We need sudo
(( EUID != 0 )) && exec sudo -- "$0" "$@"

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
USER_GROUP=$(getent group $SUDO_USER | cut -d: -f3)

echo "Please enter your email: "
read email

username=${1%@*}


installPackages
launchGitInit
copyLinkFiles
subVars
installMvn
installVirtualEnvWrapper
