variables {
  project_id = "test-project"
  tenants    = ["production", "staging"]
}

run "enables_multitenancy_and_emits_a_tenant_per_name" {
  command = plan

  assert {
    condition     = google_identity_platform_config.default.multi_tenant[0].allow_tenants == true
    error_message = "multi-tenancy must be enabled on the Identity Platform config"
  }

  assert {
    condition     = length(google_identity_platform_tenant.tenant) == 2
    error_message = "expected exactly two tenants to be planned"
  }

  assert {
    condition = alltrue([
      for name in var.tenants : contains(keys(google_identity_platform_tenant.tenant), name)
    ])
    error_message = "a tenant must be planned for each requested display name"
  }

  assert {
    condition     = google_identity_platform_tenant.tenant["staging"].allow_password_signup == true
    error_message = "tenants must allow password signup"
  }
}

run "no_tenants_by_default" {
  command = plan

  variables {
    tenants = []
  }

  assert {
    condition     = length(google_identity_platform_tenant.tenant) == 0
    error_message = "no tenants should be created when the list is empty"
  }
}
