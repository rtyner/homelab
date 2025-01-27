#!/bin/bash

# Create namespaces directory if it doesn't exist
mkdir -p namespaces

# Get all namespaces
for ns in $(kubectl get ns --no-headers | cut -d' ' -f1); do
  # Get namespace manifest and clean it up
  kubectl get namespace $ns -o yaml |
    python3 -c '
import sys, yaml
data = yaml.safe_load(sys.stdin)
# Remove unnecessary fields
clean = {
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
        "name": data["metadata"]["name"]
    }
}
# Add labels if they exist
if "labels" in data["metadata"]:
    clean["metadata"]["labels"] = data["metadata"]["labels"]
print("---")
print(yaml.dump(clean, default_flow_style=False))
' >"namespaces/${ns}.yml"
done
