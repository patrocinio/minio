OS := $(shell uname | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m | sed -e 's/x86_64/amd64/')
KREW := ./krew-$(OS)_$(ARCH)


install_krew:
	echo $(ARCH)
	cd $(shell mktemp -d)
	curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz"
	tar zxvf krew.tar.gz
	$(KREW) install krew

install_minio:
	kubectl krew update
	kubectl krew install minio

minio_init:
	kubectl minio init

validate:
	kubectl get all --namespace minio-operator

minio_storage_class:
	kubectl apply -f minio_storage_class.yaml
	kubectl patch storageclass local-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

all: install_krew install_minio minio_init validate