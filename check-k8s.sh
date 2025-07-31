#!/bin/bash

echo "🔍 Checking Docker & Kubernetes Status"
echo "======================================="
echo ""

# Check if Docker is installed
if ls /Applications/Docker.app &> /dev/null; then
    echo "✅ Docker Desktop is installed"
    
    # Check if Docker is running
    if docker info &> /dev/null; then
        echo "✅ Docker daemon is running"
        echo "   Version: $(docker --version)"
    else
        echo "❌ Docker daemon is not running"
        echo "   Please start Docker Desktop from Applications"
    fi
else
    echo "❌ Docker Desktop is not installed"
    echo "   Run: ansible-playbook docker-kubernetes-setup.yml"
fi

echo ""

# Check if kubectl is available
if command -v kubectl &> /dev/null; then
    echo "✅ kubectl is available"
    echo "   Version: $(kubectl version --short --client 2>/dev/null)"
    
    # Check if Kubernetes cluster is accessible
    if kubectl cluster-info &> /dev/null; then
        echo "✅ Kubernetes cluster is running"
        echo ""
        echo "Cluster Info:"
        kubectl cluster-info
        echo ""
        echo "Nodes:"
        kubectl get nodes
    else
        echo "❌ Cannot connect to Kubernetes cluster"
        echo "   Make sure Kubernetes is enabled in Docker Desktop settings"
    fi
else
    echo "❌ kubectl is not available"
    echo "   Kubernetes might not be enabled in Docker Desktop"
fi

echo ""
echo "💡 Troubleshooting Tips:"
echo "   • If Docker is not running: Open Docker Desktop from Applications"
echo "   • If Kubernetes is not enabled:"
echo "     1. Open Docker Desktop"
echo "     2. Go to Settings → Kubernetes"
echo "     3. Check 'Enable Kubernetes'"
echo "     4. Click 'Apply & Restart'"
echo "   • Wait 2-5 minutes for Kubernetes to fully start"