export ISTIO_VERSION=1.3.3

curl -L https://git.io/getLatestIstio | sh -
 
cd istio-$ISTIO_VERSION

export PATH=$PWD/bin:$PATH

oc apply -f install/kubernetes/helm/helm-service-account.yaml

helm init
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | oc apply -f -
helm template install/kubernetes/helm/istio-cni --name=istio-cni --namespace=kube-system | oc apply -f -
helm template install/kubernetes/helm/istio --name istio --namespace istio-system --set istio_cni.enabled=true | oc apply -f -

