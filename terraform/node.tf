resource "yandex_kubernetes_node_group" "app" {
  cluster_id = yandex_kubernetes_cluster.k8s-zonal.id
  name       = "app"
 
  instance_template {
    name       = "app-{instance.short_id}"
    platform_id = "standard-v1"
    resources {
      cores  = 2
      memory = 4
    } 
    scheduling_policy {
    preemptible = true
    } 
      
    metadata = {
    ssh-keys = "oleg:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgRCzGnVRpbCL47/rGtDi2BNUs9ILA5HLDimLzm9JoJ oleg@DESKTOP-NG99BTO"
    }

    network_acceleration_type = "standard"
    container_runtime {
     type = "containerd"
    }
#    labels {
#      "<имя_метки>"="<значение_метки>"
#    }
    
    }
  
  scale_policy {
    fixed_scale {
      size  = 1
      
        
  }
 }
}
