Before running:
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
Instruction is here:
https://www.rabbitmq.com/kubernetes/operator/quickstart-operator.html
Install:
kubectl apply -f rabbitmq.yaml
Delete:
kubectl delete -f rabbitmq.yaml