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

resource "google_compute_network" "default" {
  name                    = "test-psa-network"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "test network"
}

module "test_psa" {
  source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
  version = "~> 26.0"

  project_id      = var.project_id
  vpc_network     = google_compute_network.default.name
  address         = "10.220.0.0"
  deletion_policy = "ABANDON"
  depends_on      = [google_compute_network.default]
}
