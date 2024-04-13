resource "local_file" "mensaje" {
  content  = "Este es un curso de terraform"
  filename = "archivo.txt"
}
