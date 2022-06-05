Repository:
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
Install prometheus:
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
helm upgrade --install prometheus bitnami/kube-prometheus
Install exporter:
helm install redis-exporter prometheus-community/prometheus-redis-exporter -f values.yaml
Watch metrics:
kubectl port-forward service/redis-exporter-prometheus-redis-exporter 9121 