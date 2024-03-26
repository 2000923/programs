variable "nombre" {
  description = "Nombre del creador"
  type        = string
}

variable "archivo" {
  description = "Nombre y ruta del archivo"
  type        = string
  default     = "prueba.txt"
}

resource "local_file" "foo" {
  filename = var.archivo
  content  = "Este archivo fue creado por $(var.nombre)"
}

output "md5" {
  description = "Suma de verificación MD5 del archivo creado"
  value       = local_file.foo.content_md5
}
