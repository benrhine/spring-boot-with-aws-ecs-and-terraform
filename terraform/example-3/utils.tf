# --------------------
# Generate Random String
# --------------------
resource "random_string" "suffix" {
  length  = 8
  special = false
}