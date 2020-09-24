#!/bin/sh

# wordpress jnannie:jnannie; user:user
# phpmyadmin root:
# grafana admin:jnannie
# ftps jnannie:jnannie

SERVICES="mysql nginx wordpress phpmyadmin influxdb telegraf grafana ftps"

nginxIP="192.168.99.5"
wordpressIP="192.168.99.6"
phpmyadminIP="192.168.99.7"
grafanaIP="192.168.99.8"
ftpsIP="192.168.99.9"

clear_resources()
{
	for SERVICE in $SERVICES
	do
		kubectl delete service $SERVICE
		kubectl delete deployment $SERVICE
	done
	sleep 2
	kubectl delete pvc --all
	kubectl delete pv --all
}

if [ "$1" = "uninstall" ]; then
	minikube delete
	rm -rf ~/.minikube/
	rm -rf ~/.kube
	sudo rm -f /usr/local/bin/minikube
	sudo rm -f ~/.config/VirtualBox/HostInterfaceNetworking-vboxnet0-Dhcpd.leases
	echo "minikube uninstalled"
	exit
fi

if [ "$1" = "install" ]; then
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
	&& chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
	rm -f minikube
	echo "minikube installed, run './setup.sh' to create cluster"
	exit
fi

if [ ! -f /usr/local/bin/minikube ] || [ ! -f /usr/local/bin/kubectl ]; then
	echo "kubectl and minikube must be installed"
	exit
fi

# run cluster
echo "check minikube status:"
minikube status
if [ $? != 0 ]; then
	minikube start --driver=virtualbox
	minikube addons enable dashboard
	minikube addons enable metallb
	sleep 5
fi

clear_resources

eval $(minikube -p minikube docker-env)

kubectl apply -f srcs/metallb_config.yaml

docker build -t phpfpm srcs/phpfpm

export loadBalancerIP
for SERVICE in $SERVICES
do
	eval "loadBalancerIP=\${${SERVICE}IP}"
	if [ "$SERVICE" = "ftps" ]
	then
		docker build --build-arg loadBalancerIP=$loadBalancerIP -t $SERVICE srcs/$SERVICE
	else
		docker build -t $SERVICE srcs/$SERVICE
	fi
	sleep 2
	envsubst < srcs/$SERVICE.yaml | kubectl apply -f -
done

sleep 10
kubectl exec -i deploy/mysql -- mysql -u root wordpress < srcs/wordpress/srcs/wordpress.sql
