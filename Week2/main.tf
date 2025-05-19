terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}


resource "docker_image" "lab1_image" {
  name = "lab1-web-app-image"
  build {
    context = "${path.module}/lab1-app"
    dockerfile = "Dockerfile.txt"
  }
}

resource "docker_container" "node_web_app_container" {
  name = "lab1-web-app-container"
  image = docker_image.lab1_image.image_id
  restart = "unless-stopped"

  ports {
    internal = 3000
    external = 3000
  }
}