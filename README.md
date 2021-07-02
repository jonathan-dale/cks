## CKS Killer.sh

Install k8s cluster, must be root `sudo -i` first

#### cks-master
```bash
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_master.sh)
```

#### cks-worker
```bash
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_worker.sh)
```


#### run the printed kubeadm-join-command from the master on the worker
