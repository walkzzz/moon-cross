# security

## Types
- `AsanConfig`
- `AsanResult`
- `DependencyInfo`
- `FfiSafetyResult`
- `LicenseCompatResult`
- `LockEntry`
- `SafetyCheckType`
- `SafetyIssue`
- `SandboxConfig`
- `SandboxResult`

## Public API
- `SafetyCheckType`
- `analyze_asan_output`
- `asan_compile_flags`
- `asan_env_vars`
- `asan_failed`
- `asan_link_flags`
- `asan_passed`
- `asan_version`
- `batch_check_dependencies`
- `check_buffer_bounds`
- `check_dependency_safety`
- `check_license_compatibility`
- `check_null_safety`
- `check_type_safety`
- `cleanup_sandbox`
- `comprehensive_safety_check`
- `default_asan_config`
- `default_sandbox_config`
- `disabled_asan_config`
- `ffi_safety_version`
- `generate_lock_file`
- `generate_safety_wrapper`
- `make_dependency`
- `make_lock_entry`
- `make_safety_issue`
- `sandbox_compile_command`
- `sandbox_failure`
- `sandbox_success`
- `sandbox_timeout`
- `sandbox_version`
- `sandbox_work_dir`
- `supply_chain_version`
- `validate_sandbox_config`
- `verify_checksum`

> Part of [moon-cross](../../README.md) — MoonBit cross-platform native framework
