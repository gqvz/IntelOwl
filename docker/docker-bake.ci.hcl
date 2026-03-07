variable "REPO_DOWNLOADER_ENABLED" {
  default = "true"
}

group "default" {
  targets = ["uwsgi", "nginx", "postgres", "redis"]
}

target "uwsgi" {
  context    = "."
  dockerfile = "docker/Dockerfile"
  tags       = ["intelowlproject/intelowl:ci"]
  args = {
    REPO_DOWNLOADER_ENABLED = REPO_DOWNLOADER_ENABLED
  }
  cache-from = [{ type = "local", src = "/tmp/.buildx-cache" }]
  cache-to   = [{ type = "local", dest = "/tmp/.buildx-cache-new", mode = "max" }]
}

target "nginx" {
  context    = "."
  dockerfile = "docker/Dockerfile_nginx"
  tags       = ["intelowlproject/intelowl_nginx:ci"]
  cache-from = [{ type = "local", src = "/tmp/.buildx-cache" }]
  cache-to   = [{ type = "local", dest = "/tmp/.buildx-cache-new", mode = "max" }]
}

target "postgres" {
  dockerfile-inline = "FROM postgres:16-alpine"
  tags              = ["postgres:16-alpine"]
  output            = ["type=docker"]
}

target "redis" {
  dockerfile-inline = "FROM redis:6.2.7-alpine"
  tags              = ["redis:6.2.7-alpine"]
  output            = ["type=docker"]
}