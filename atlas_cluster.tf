resource "mongodbatlas_cluster" "cluster-test" {
  project_id              = var.project_id
  name                    = "cluster-test-global"
  disk_size_gb            = 80
  num_shards              = 1
  provider_backup_enabled = true
  cluster_type            = "GEOSHARDED"

  //Provider Settings "block"
  provider_name               = "AWS"
  provider_instance_size_name = "M30"

  replication_specs {
    zone_name  = "Zone 1"
    num_shards = 2
    regions_config {
      region_name     = "EU_WEST_1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }

  replication_specs {
    zone_name  = "Zone 2"
    num_shards = 2
    regions_config {
      region_name     = "EU_CENTRAL_1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
}

resource "mongodbatlas_cluster" "cluster-test-single" {
  project_id   = var.project_id
  name         = "cluster-test"
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "EU_WEST_1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  //Provider Settings "block"
  provider_name               = "AWS"
  disk_size_gb                = 10
  provider_instance_size_name = "M10"
}
