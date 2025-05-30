/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Master
output "instance_name" {
  value       = google_sql_database_instance.default.name
  description = "The instance name for the master instance"
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = google_sql_database_instance.default.public_ip_address
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  value       = google_sql_database_instance.default.private_ip_address
}

output "instance_ip_address" {
  value       = google_sql_database_instance.default.ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "instance_first_ip_address" {
  value       = google_sql_database_instance.default.first_ip_address
  description = "The first IPv4 address of the addresses assigned."
}

output "instance_connection_name" {
  value       = google_sql_database_instance.default.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = google_sql_database_instance.default.self_link
  description = "The URI of the master instance"
}

output "instance_server_ca_cert" {
  value       = google_sql_database_instance.default.server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
  sensitive   = true
}

output "instance_service_account_email_address" {
  value       = google_sql_database_instance.default.service_account_email_address
  description = "The service account email address assigned to the master instance"
}

output "instance_psc_attachment" {
  value       = google_sql_database_instance.default.psc_service_attachment_link
  description = "The psc_service_attachment_link created for the master instance"
}

// Replicas
output "replicas_instance_first_ip_addresses" {
  value       = [for r in google_sql_database_instance.replicas : r.ip_address]
  description = "The first IPv4 addresses of the addresses assigned for the replica instances"
}

output "replicas_instance_connection_names" {
  value       = [for r in google_sql_database_instance.replicas : r.connection_name]
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = [for r in google_sql_database_instance.replicas : r.self_link]
  description = "The URIs of the replica instances"
}

output "replicas_instance_server_ca_certs" {
  value       = [for r in google_sql_database_instance.replicas : r.server_ca_cert]
  description = "The CA certificates information used to connect to the replica instances via SSL"
  sensitive   = true
}

output "replicas_instance_service_account_email_addresses" {
  value       = [for r in google_sql_database_instance.replicas : r.service_account_email_address]
  description = "The service account email addresses assigned to the replica instances"
}

output "read_replica_instance_names" {
  value       = [for r in google_sql_database_instance.replicas : r.name]
  description = "The instance names for the read replica instances"
}

output "generated_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = var.enable_default_user ? random_password.user-password[0].result : ""
  sensitive   = true
}

output "additional_users" {
  description = "List of maps of additional users and passwords"
  value = [for r in google_sql_user.additional_users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}

output "additional_user_passwords_map" {
  description = "Map of auto generated passwords for the additional users"
  value       = { for u in google_sql_user.additional_users : u.name => u.password }
  sensitive   = true
}

output "iam_users" {
  description = "The list of the IAM users with access to the CloudSQL instance"
  value       = var.iam_users
}

// Resources
output "primary" {
  value       = google_sql_database_instance.default
  description = "The `google_sql_database_instance` resource representing the primary instance"
  sensitive   = true
}

output "replicas" {
  value       = values(google_sql_database_instance.replicas)
  description = "A list of `google_sql_database_instance` resources representing the replicas"
  sensitive   = true
}

output "instances" {
  value       = concat([google_sql_database_instance.default], values(google_sql_database_instance.replicas))
  description = "A list of all `google_sql_database_instance` resources we've created"
  sensitive   = true
}

output "dns_name" {
  value       = google_sql_database_instance.default.dns_name
  description = "DNS name of the instance endpoint"
}

output "env_vars" {
  description = "Exported environment variables"
  value = {
    "CLOUD_SQL_DATABASE_HOST" : google_sql_database_instance.default.first_ip_address,
    "CLOUD_SQL_DATABASE_CONNECTION_NAME" : google_sql_database_instance.default.connection_name,
    "CLOUD_SQL_DATABASE_NAME" : local.database_name
  }
}

output "apphub_service_uri" {
  value = {
    service_uri = "//sqladmin.googleapis.com/projects${element(split("/projects", google_sql_database_instance.default.self_link), 1)}"
    service_id  = substr("${var.name}-${md5("${var.region}-${var.project_id}")}", 0, 63)
    location    = var.region
  }
  description = "Service URI in CAIS style to be used by Apphub."
}
