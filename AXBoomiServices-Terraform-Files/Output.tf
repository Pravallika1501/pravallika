output "tls_private_key" {
  value     = tls_private_key.BoomiNFSKey.private_key_pem
  sensitive = true
}

