resource "yandex_compute_snapshot_schedule" "snapshot-hdd" {
  name           = "snapshot-hdd"

  schedule_policy {
    expression = "0 0 ? * *"
  }

  retention_period = "168h"

  snapshot_spec {
      description = "Snapshots from each VM"
      labels = {
        snapshot-label = "snapshot-test"
      }
  }

  disk_ids = ["epdfas3hekebl39mb1ls", "epdrjgsrjhleh36n2omg", "epdt380pdg59k13soh2s", "fhm9i9tiokqqdlsas828", "fhmoi2e3b888qbj6cugv", "fhmolbege07c7jfl06el"]
}