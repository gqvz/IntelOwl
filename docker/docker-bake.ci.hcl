variable "REPO_DOWNLOADER_ENABLED" {
  default = "true"
}

group "default" {
  targets = ["uwsgi", "nginx"]
}

target "uwsgi" {
  context    = ".."
  dockerfile = "docker/Dockerfile"
  tags       = ["intelowlproject/intelowl:ci"]
  args = {
    REPO_DOWNLOADER_ENABLED = REPO_DOWNLOADER_ENABLED
  }
  cache-from = ["type=gha,scope=intelowl-main"]
  cache-to   = ["type=gha,mode=max,scope=intelowl-main"]
  output     = ["type=docker"]
}

target "nginx" {
  context    = ".."
  dockerfile = "docker/Dockerfile_nginx"
  tags       = ["intelowlproject/intelowl_nginx:ci"]
  cache-from = ["type=gha,scope=intelowl-nginx"]
  cache-to   = ["type=gha,mode=max,scope=intelowl-nginx"]
  output     = ["type=docker"]
}