resource "local_file" "my_file" {
    filename = "new_file.txt"
    content = "Created through terraform"
}