#!/bin/bash

function abort {
	EXIT_VAL="$?"
	echo "ABORT ERROR: exit code $EXIT_VAL occured, failed to execute '$BASH_COMMAND' on line '${BASH_LINENO[0]}' "
	exit "$EXIT_VAL"
}


function die {
	MESS="$1"
	EXIT_VAL="${2:-1}"
	echo '[DIE] ' "$MESS" 1>&2
	exit "$EXIT_VAL"
}


function info {
	echo
	NOW=`date +%m%s`
        DIFF=`expr $NOW - $START_TIME`
        echo '[INFO] ['$DIFF'] ' "$@"
	echo
}


trap abort ERR

START_TIME=`date +%m%s`

AM_I_ROOT=`id -u`
[[ "$AM_I_ROOT" == 0 ]] || die "must be root to run this script..."


## docker
info "adding docker repo and GPG KEY"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"


info "install docker"
sudo apt update && \
    sudo apt install -y apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    docker-ce \
    docker-ce-cli \
    containerd.io

info "adding docker user/group"
sudo usermod -aG docker ubuntu


## kubectl
info "checking kubectl"
KUBECTL="$which kubectl"
if [ ! -z $KUBECTL ] ; then
   info "installing kubectl"
   curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" 
   chmod 755 kubectl
   sudo mv kubectl /usr/local/bin/kubectl
   info "creating link kubectl=k"
   sudo ln -s /usr/local/bin/kubectl /usr/local/bin/k
fi
echo 'source /usr/share/bash-completion/bash_completion' >> /home/ubuntu/.bashrc
echo 'source <(kubectl completion bash)' >> /home/ubuntu/.bashrc
echo 'complete -F __start_kubectl k' >> /home/ubuntu/.bashrc


## k3d
info "installing k3d"
wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash


## terraform
info "installing terraform"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform


#sudo sysctl -w vm.max_map_count=262144


cat <<- EOF


  Done!
  Docker, kubectl, k3d, and terraform are now installed....


   ***IMPORTANT! - You must log out and back in so the docker group changes take effect.

  press any key to exit

EOF
read anykey

exit

