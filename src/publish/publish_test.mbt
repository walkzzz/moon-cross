test "default_publish_config_module_name" {
  let cfg = @publish.default_publish_config()
  assert_eq(cfg.module_name, "walkzzz/moon-cross")
}

test "default_publish_config_version" {
  let cfg = @publish.default_publish_config()
  assert_eq(cfg.version, "0.1.4")
}

test "default_publish_config_license" {
  let cfg = @publish.default_publish_config()
  assert_eq(cfg.license, "MIT")
}

test "default_publish_config_description" {
  let cfg = @publish.default_publish_config()
  assert_true(cfg.description.length() > 10)
}

test "default_publish_config_repository" {
  let cfg = @publish.default_publish_config()
  assert_true(cfg.repository.contains("github.com"))
}

test "default_publish_config_readme" {
  let cfg = @publish.default_publish_config()
  assert_eq(cfg.readme_path, "README.md")
}

test "default_publish_config_keywords" {
  let cfg = @publish.default_publish_config()
  assert_true(cfg.keywords.length() >= 3)
}

test "check_module_name_valid" {
  let check = @publish.check_module_name("walkzzz/moon-cross")
  assert_true(check.passed)
}

test "check_module_name_invalid_no_slash" {
  let check = @publish.check_module_name("mooncross")
  assert_true(!check.passed)
}

test "check_module_name_invalid_empty" {
  let check = @publish.check_module_name("")
  assert_true(!check.passed)
}

test "check_version_format_valid" {
  let check = @publish.check_version_format("0.1.4")
  assert_true(check.passed)
}

test "check_version_format_valid_2" {
  let check = @publish.check_version_format("1.0.0")
  assert_true(check.passed)
}

test "check_version_format_invalid_2_segments" {
  let check = @publish.check_version_format("0.1")
  assert_true(!check.passed)
}

test "check_version_format_invalid_4_segments" {
  let check = @publish.check_version_format("0.1.4.0")
  assert_true(!check.passed)
}

test "check_license_valid" {
  let check = @publish.check_license("MIT")
  assert_true(check.passed)
}

test "check_license_empty" {
  let check = @publish.check_license("")
  assert_true(!check.passed)
}

test "check_description_valid" {
  let check = @publish.check_description("A cross-platform framework for MoonBit")
  assert_true(check.passed)
}

test "check_description_too_short" {
  let check = @publish.check_description("short")
  assert_true(!check.passed)
}

test "check_repository_valid" {
  let check = @publish.check_repository("https://github.com/walkzzz/moon-cross")
  assert_true(check.passed)
}

test "check_repository_empty" {
  let check = @publish.check_repository("")
  assert_true(!check.passed)
}

test "check_repository_no_protocol" {
  let check = @publish.check_repository("github.com/walkzzz/moon-cross")
  assert_true(!check.passed)
}

test "check_readme_valid" {
  let check = @publish.check_readme("README.md")
  assert_true(check.passed)
}

test "check_readme_invalid" {
  let check = @publish.check_readme("README.txt")
  assert_true(!check.passed)
}

test "check_keywords_sufficient" {
  let check = @publish.check_keywords(["a", "b", "c"])
  assert_true(check.passed)
}

test "check_keywords_insufficient" {
  let check = @publish.check_keywords(["a", "b"])
  assert_true(!check.passed)
}

test "validate_publish_readiness_default" {
  let cfg = @publish.default_publish_config()
  let readiness = @publish.validate_publish_readiness(cfg)
  assert_true(readiness.ready)
}

test "validate_publish_readiness_checks_count" {
  let cfg = @publish.default_publish_config()
  let readiness = @publish.validate_publish_readiness(cfg)
  assert_eq(readiness.checks.length(), 7)
}

test "validate_publish_readiness_summary" {
  let cfg = @publish.default_publish_config()
  let readiness = @publish.validate_publish_readiness(cfg)
  assert_true(readiness.summary.contains("passed"))
}

test "generate_mooncakes_metadata" {
  let cfg = @publish.default_publish_config()
  let meta = @publish.generate_mooncakes_metadata(cfg)
  assert_eq(meta.name, "walkzzz/moon-cross")
  assert_eq(meta.version, "0.1.4")
  assert_eq(meta.license, "MIT")
}

test "generate_checksum_not_empty" {
  let cfg = @publish.default_publish_config()
  let checksum = @publish.generate_checksum(cfg)
  assert_true(checksum.length() > 0)
}

test "generate_checksum_contains_prefix" {
  let cfg = @publish.default_publish_config()
  let checksum = @publish.generate_checksum(cfg)
  assert_true(checksum.contains("sha256:"))
}

test "generate_publish_command" {
  let cfg = @publish.default_publish_config()
  let cmd = @publish.generate_publish_command(cfg)
  assert_true(cmd.contains("moon publish"))
  assert_true(cmd.contains("0.1.4"))
}

test "generate_install_command" {
  let cfg = @publish.default_publish_config()
  let cmd = @publish.generate_install_command(cfg)
  assert_true(cmd.contains("moon add"))
  assert_true(cmd.contains("walkzzz/moon-cross"))
}

test "check_version_consistency_match" {
  let check = @publish.check_version_consistency("0.1.4", "0.1.4")
  assert_true(check.passed)
}

test "check_version_consistency_mismatch" {
  let check = @publish.check_version_consistency("0.1.4", "0.1.3")
  assert_true(!check.passed)
}

test "publish_checklist_default" {
  let cfg = @publish.default_publish_config()
  let checklist = @publish.publish_checklist(cfg)
  assert_eq(checklist.length(), 7)
}

test "publish_checklist_all_passed" {
  let cfg = @publish.default_publish_config()
  let checklist = @publish.publish_checklist(cfg)
  for item in checklist {
    assert_true(item.contains("[x]"))
  }
}

test "check_license_compatibility_mit" {
  assert_true(@publish.check_license_compatibility("MIT"))
}

test "check_license_compatibility_apache" {
  assert_true(@publish.check_license_compatibility("Apache-2.0"))
}

test "check_license_compatibility_bsd" {
  assert_true(@publish.check_license_compatibility("BSD-3-Clause"))
}

test "check_license_compatibility_gpl" {
  assert_true(!@publish.check_license_compatibility("GPL-3.0"))
}

test "generate_mooncakes_toml_contains_package" {
  let cfg = @publish.default_publish_config()
  let toml = @publish.generate_mooncakes_toml(cfg)
  assert_true(toml.contains("[package]"))
}

test "generate_mooncakes_toml_contains_name" {
  let cfg = @publish.default_publish_config()
  let toml = @publish.generate_mooncakes_toml(cfg)
  assert_true(toml.contains("walkzzz/moon-cross"))
}

test "generate_mooncakes_toml_contains_version" {
  let cfg = @publish.default_publish_config()
  let toml = @publish.generate_mooncakes_toml(cfg)
  assert_true(toml.contains("0.1.4"))
}

test "generate_mooncakes_toml_contains_license" {
  let cfg = @publish.default_publish_config()
  let toml = @publish.generate_mooncakes_toml(cfg)
  assert_true(toml.contains("MIT"))
}

test "generate_mooncakes_toml_contains_keywords" {
  let cfg = @publish.default_publish_config()
  let toml = @publish.generate_mooncakes_toml(cfg)
  assert_true(toml.contains("cross-platform"))
}

test "simulate_publish_success" {
  let cfg = @publish.default_publish_config()
  let result = @publish.simulate_publish(cfg)
  assert_true(@publish.is_published(result))
}

test "simulate_publish_message" {
  let cfg = @publish.default_publish_config()
  let result = @publish.simulate_publish(cfg)
  assert_true(result.message.contains("walkzzz/moon-cross"))
}

test "simulate_publish_metadata" {
  let cfg = @publish.default_publish_config()
  let result = @publish.simulate_publish(cfg)
  match @publish.get_publish_metadata(result) {
    Some(meta) => assert_eq(meta.name, "walkzzz/moon-cross")
    None => assert_true(false)
  }
}

test "simulate_publish_failure" {
  let cfg : @publish.PublishConfig = {
    module_name: "invalid",
    version: "0.1",
    license: "",
    description: "short",
    repository: "",
    readme_path: "",
    keywords: [],
  }
  let result = @publish.simulate_publish(cfg)
  assert_true(!@publish.is_published(result))
}

test "publish_status_not_published" {
  let result : @publish.PublishResult = {
    status: @publish.PublishStatus::NotPublished,
    message: "not published",
    metadata: None,
  }
  assert_true(!@publish.is_published(result))
}

test "publish_status_published" {
  let cfg = @publish.default_publish_config()
  let result : @publish.PublishResult = {
    status: @publish.PublishStatus::Published,
    message: "published",
    metadata: Some(@publish.generate_mooncakes_metadata(cfg)),
  }
  assert_true(@publish.is_published(result))
}