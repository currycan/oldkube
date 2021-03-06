#!/bin/bash

set -e

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Blue_background_prefix="\033[44;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

echo -e "${Blue_background_prefix}>>>>Please wait a moment to get the binaries version..${Font_color_suffix}"
declare -A binaries_url=(
    # [K8S_URL]=https://github.com/kubernetes/kubernetes/tags
    [kube_url]=https://dl.k8s.io/release/stable.txt
    [docker_url]=https://download.docker.com/linux/static/stable/x86_64
    [containerd_url]=https://github.com/containerd/containerd/tags
    [doker_compose_url]=https://github.com/docker/compose/tags
    [cfssl_url]=https://pkg.cfssl.org
    [etcd_url]=https://github.com/etcd-io/etcd/tags
    [cni_url]=https://github.com/containernetworking/plugins/tags
    [flanneld_url]=https://github.com/coreos/flannel/tags
    [calico_url]=https://github.com/projectcalico/calico/tags
    [coredns_url]=https://github.com/coredns/coredns/tags
    [helm_url]=https://github.com//helm/helm/tags
    [harbor_url]=https://github.com/goharbor/harbor/tags
)
for binary_url in ${!binaries_url[@]}
do
    binary=`echo $binary_url | awk -F'_url' '{print $1}'`
    if [[ ${binary} == "kube" ]];then
        export "${binary}_version=`wget -qO- ${binaries_url[$binary_url]}`"
    elif [[ ${binary} == "docker" ]];then
        export "${binary}_version=`wget -qO- ${binaries_url[$binary_url]} | grep docker | tail -n 1 | cut -d">" -f1 | grep -oP "[a-zA-Z]*[0-9]\d*\.[0-9]\d*\.[0-9]\d*"`"
    elif [[ ${binary} == "cfssl" ]];then
        export "${binary}_version=R`wget -qO- ${binaries_url[$binary_url]} | grep "CFSSL" | grep -oP "[0-9]\d*\.[0-9]\d*" | head -n 1`"
    else
        export "${binary}_version=`wget -qO- ${binaries_url[$binary_url]} | grep "releases/tag/" | grep "muted-link" | grep -v "rc" | grep -v "alpha" | grep -v "beta" | grep -oP "[a-zA-Z]*[0-9]\d*\.[0-9]\d*\.[0-9]\d*" | head -n 1`"
    fi
done
echo -e "${Green_font_prefix}++++++++++++++++++++++++++++++++++${Font_color_suffix}"
echo -e "${Green_font_prefix}kube_version=$kube_version${Font_color_suffix}"
echo -e "${Green_font_prefix}docker_version=$docker_version${Font_color_suffix}"
echo -e "${Green_font_prefix}containerd_version=$containerd_version${Font_color_suffix}"
echo -e "${Green_font_prefix}doker_compose_version=$doker_compose_version${Font_color_suffix}"
echo -e "${Green_font_prefix}cfssl_version=$cfssl_version${Font_color_suffix}"
echo -e "${Green_font_prefix}etcd_version=$etcd_version${Font_color_suffix}"
echo -e "${Green_font_prefix}cni_version=$cni_version${Font_color_suffix}"
echo -e "${Green_font_prefix}flanneld_version=$flanneld_version${Font_color_suffix}"
echo -e "${Green_font_prefix}calico_version=$calico_version${Font_color_suffix}"
echo -e "${Green_font_prefix}coredns_version=$coredns_version${Font_color_suffix}"
echo -e "${Green_font_prefix}helm_version=$helm_version${Font_color_suffix}"
echo -e "${Green_font_prefix}harbor_version=$harbor_version${Font_color_suffix}"
echo -e "${Green_font_prefix}++++++++++++++++++++++++++++++++++${Font_color_suffix}"

BINS=(harbor_version helm_version coredns_version calico_version flanneld_version cni_version etcd_version cfssl_version doker_compose_version docker_version containerd_version kube_version)
for bin in ${BINS[@]};do
    FLAG=`cat roles/cluster-default/defaults/main.yml | grep ${bin} | wc -l`
    if [ $FLAG -eq 0 ];then
        echo "===== 配置${bin} ====="
        version=`eval echo '$'"$bin"`
        if [ `echo $version | grep -e [a-zA-Z] | wc -l` = 1 ];then
            sed -e "7i ${bin}: \"${version:1}\"" -i roles/cluster-default/defaults/main.yml
        else
            sed -e "7i ${bin}: \"${version}\"" -i roles/cluster-default/defaults/main.yml
        fi
    else
        echo "===== 修改${bin} ====="
        version=`eval echo '$'"$bin"`
        if [ `echo $version | grep -e [a-zA-Z] | wc -l` = 1 ];then
            sed -e "s/^${bin}.*/${bin}: \"${version:1}\"/g" -i roles/cluster-default/defaults/main.yml
        else
            sed -e "s/^${bin}.*/${bin}: \"${version}\"/g" -i roles/cluster-default/defaults/main.yml
        fi
    fi
done
