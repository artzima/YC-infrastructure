resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
}


resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
}