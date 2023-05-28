data "http" "ip" {
  url = "https://ifconfig.me/ip"
}


locals {
  client_public_ip = data.http.ip.response_body
}


resource "mongodbatlas_cluster" "atlas_cluster" {
  project_id              = var.mongodb_atlas_project_id
  name                    = "atlas-cluster"

  provider_name           = "AWS"
  provider_region_name    = "EU_WEST_1"
  provider_instance_size_name = "M10"

  mongo_db_major_version  = "6.0"
  auto_scaling_disk_gb_enabled = "false"
}


resource "mongodbatlas_project_ip_access_list" "atlas_cluster" {
      project_id = var.mongodb_atlas_project_id
      ip_address = local.client_public_ip
      comment    = "atlas_cluster"
}


resource "mongodbatlas_database_user" "atlas_cluster" {
  username           = "cluster-admin"
  password           = "cluster-admin"
  project_id         = var.mongodb_atlas_project_id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  labels {
    key   = "Name"
    value = "atlas_cluster"
  }

  scopes {
    name   = "atlas-cluster"
    type = "CLUSTER"
  }
}