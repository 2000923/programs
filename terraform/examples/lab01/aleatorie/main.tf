resource "random_password" "my_password" {
  length  = 20
  special = true
}

resource "random_string" "text_aleatorie" {
  length  = 8
  special = false
}

output "texto" {
  description = "texto_generado"
  value       = random_string.text_aleatorie.result
}

output "password" {
  description = "Clave generada"
  value       = random_password.my_password.result
  sensitive   = true
}

