locals {
  environment_map = {}
}

resource "cloudfoundry_app" "app_application" {
  name         = var.paas_application_name
  space        = data.cloudfoundry_space.space.id
  docker_image = var.paas_app_docker_image
  stopped      = var.application_stopped
  strategy     = var.strategy
  memory       = 1024
  disk_quota   = 3072
  timeout      = var.timeout
  instances    = var.instances

  routes {
    route = cloudfoundry_route.app_route_cloud.id
  }

  routes {
    route = cloudfoundry_route.app_route_internal.id
  }

  dynamic "routes" {
    for_each = data.cloudfoundry_route.app_route_internet
    content {
      route = routes.value["id"]
    }
  }

  environment = merge(local.application_secrets, local.environment_map)
}
