provider "helm" {
  kubernetes {
    host     = "https://${hcloud_load_balancer.external.ipv4}:6443"
    client_certificate     = base64decode(module.k0sctl.client_certificate)
    client_key             = base64decode(module.k0sctl.client_key)
    cluster_ca_certificate = base64decode(module.k0sctl.cluster_ca_certificate)
  }
}
provider "kubernetes" {
  host     = "https://${hcloud_load_balancer.external.ipv4}:6443"
  client_certificate     = base64decode(module.k0sctl.client_certificate)
  client_key             = base64decode(module.k0sctl.client_key)
  cluster_ca_certificate = base64decode(module.k0sctl.cluster_ca_certificate)
}

resource "kubernetes_secret" "hcloud_token" {
  metadata {
    name = "hcloud"
    namespace = "kube-system"
  }
  data = {
    token = var.hcloud_token
    network = hcloud_network.net.id
  }
}

resource "kubernetes_service_account" "serviceaccount_kube_system_cloud_controller_manager" {
  metadata {
    name = "cloud-controller-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "clusterrolebinding_system_cloud_controller_manager" {
  metadata {
    name = "system:cloud-controller-manager"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = "cloud-controller-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "deployment_kube_system_hcloud_cloud_controller_manager" {
  metadata {
    name = "hcloud-cloud-controller-manager"
    namespace = "kube-system"
  }
  spec {
    replicas = 1
    revision_history_limit = 2
    selector {
      match_labels = {
        app = "hcloud-cloud-controller-manager"
      }
    }
    template {
      metadata {
        annotations = {
          "scheduler.alpha.kubernetes.io/critical-pod" = ""
        }
        labels = {
          app = "hcloud-cloud-controller-manager"
        }
      }
      spec {
        container {
          image = "hetznercloud/hcloud-cloud-controller-manager:v1.12.1"
          name = "hcloud-cloud-controller-manager"
          command = [
            "/bin/hcloud-cloud-controller-manager",
            "--cloud-provider=hcloud",
            "--leader-elect=false",
            "--allow-untagged-cloud",
          ]
          resources {
            requests = {
              cpu = "100m"
              memory = "50Mi"
            }
          }
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "HCLOUD_TOKEN"
            value_from {
              secret_key_ref {
                key = "token"
                name = "hcloud"
              }
            }
          }
          env {
            name = "HCLOUD_NETWORK"
            value_from {
              secret_key_ref {
                key = "network"
                name = "hcloud"
              }
            }
          }
        }
        dns_policy = "Default"
        service_account_name = "cloud-controller-manager"
        toleration {
          effect = "NoSchedule"
          key = "node.cloudprovider.kubernetes.io/uninitialized"
          value = "true"
        }
        toleration {
          key = "CriticalAddonsOnly"
          operator = "Exists"
        }
        toleration {
          effect = "NoSchedule"
          key = "node-role.kubernetes.io/master"
        }
        toleration {
          effect = "NoSchedule"
          key = "node-role.kubernetes.io/control-plane"
        }
        toleration {
          effect = "NoSchedule"
          key = "node.kubernetes.io/not-ready"
        }
      }
    }
  }
  depends_on = [kubernetes_secret.hcloud_token]
}

resource "helm_release" "traefik" {
  name = "traefik"
  namespace = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart = "traefik"
  create_namespace = true
  dependency_update = true
  #wait = false
  values = [
    file("traefik.yaml")
  ]
  #set {
  #  name = "deployment.kind"
  #  value = "DaemonSet"
  #}
  #set {
  #  name = "service.annotations.load-balancer\\.hetzner\\.cloud/location"
  #  value = var.location
  #}
  #set {
  #  name = "service.annotations.load-balancer\\.hetzner\\.cloud/use-private-ip"
  #  value = true
  #}
  depends_on = [kubernetes_service_account.serviceaccount_kube_system_cloud_controller_manager, kubernetes_cluster_role_binding.clusterrolebinding_system_cloud_controller_manager, kubernetes_deployment.deployment_kube_system_hcloud_cloud_controller_manager]
  #depends_on = [hcloud_load_balancer.http, kubernetes_service_account.serviceaccount_kube_system_cloud_controller_manager, kubernetes_cluster_role_binding.clusterrolebinding_system_cloud_controller_manager, kubernetes_deployment.deployment_kube_system_hcloud_cloud_controller_manager]
}
