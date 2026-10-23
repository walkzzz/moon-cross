test "diagnostic: check moonbit found" {
  let check = @diagnostic.check_moonbit(Some("0.1.20260920"))
  assert_eq(check.status, @diagnostic.DiagStatus::Ok)
  assert_true(check.message.contains("0.1.20260920"))
}

test "diagnostic: check moonbit not found" {
  let check = @diagnostic.check_moonbit(None)
  assert_eq(check.status, @diagnostic.DiagStatus::NotFound)
  assert_true(check.fix_hint is Some(_))
}

test "diagnostic: check moonbit empty version" {
  let check = @diagnostic.check_moonbit(Some(""))
  assert_eq(check.status, @diagnostic.DiagStatus::Error)
}

test "diagnostic: check ndk found" {
  let check = @diagnostic.check_ndk(Some("/opt/android-ndk"))
  assert_eq(check.status, @diagnostic.DiagStatus::Ok)
}

test "diagnostic: check ndk not set" {
  let check = @diagnostic.check_ndk(None)
  assert_eq(check.status, @diagnostic.DiagStatus::Warning)
}

test "diagnostic: check xcode found" {
  let check = @diagnostic.check_xcode(Some("/Applications/Xcode.app"))
  assert_eq(check.status, @diagnostic.DiagStatus::Ok)
}

test "diagnostic: check xcode not found" {
  let check = @diagnostic.check_xcode(None)
  assert_eq(check.status, @diagnostic.DiagStatus::Warning)
}

test "diagnostic: check ohos sdk found" {
  let check = @diagnostic.check_ohos_sdk(Some("/opt/ohos-sdk"))
  assert_eq(check.status, @diagnostic.DiagStatus::Ok)
}

test "diagnostic: check ohos sdk not found" {
  let check = @diagnostic.check_ohos_sdk(None)
  assert_eq(check.status, @diagnostic.DiagStatus::Warning)
}

test "diagnostic: run doctor all ok" {
  let checks = [
    @diagnostic.check_moonbit(Some("0.1.0")),
    @diagnostic.check_ndk(Some("/ndk")),
    @diagnostic.check_xcode(Some("/xcode")),
  ]
  let result = @diagnostic.run_doctor(checks)
  assert_eq(result.total, 3)
  assert_eq(result.passed, 3)
  assert_eq(result.errors, 0)
}

test "diagnostic: run doctor with errors" {
  let checks = [
    @diagnostic.check_moonbit(None),
    @diagnostic.check_ndk(Some("/ndk")),
  ]
  let result = @diagnostic.run_doctor(checks)
  assert_eq(result.total, 2)
  assert_eq(result.passed, 1)
  assert_eq(result.errors, 1)
}

test "diagnostic: generate report" {
  let checks = [
    @diagnostic.check_moonbit(Some("0.1.0")),
    @diagnostic.check_ndk(None),
  ]
  let result = @diagnostic.run_doctor(checks)
  let report = @diagnostic.generate_report(result)
  assert_true(report.contains("Doctor Report"))
  assert_true(report.contains("moonbit"))
  assert_true(report.contains("android-ndk"))
  assert_true(report.contains("Summary"))
}

test "diagnostic: is healthy" {
  let checks = [
    @diagnostic.check_moonbit(Some("0.1.0")),
    @diagnostic.check_ndk(Some("/ndk")),
  ]
  let result = @diagnostic.run_doctor(checks)
  assert_true(@diagnostic.is_healthy(result))
}

test "diagnostic: not healthy" {
  let checks = [
    @diagnostic.check_moonbit(None),
  ]
  let result = @diagnostic.run_doctor(checks)
  assert_false(@diagnostic.is_healthy(result))
}

test "diagnostic: status to string" {
  assert_eq(@diagnostic.DiagStatus::Ok.to_string(), "ok")
  assert_eq(@diagnostic.DiagStatus::Warning.to_string(), "warning")
  assert_eq(@diagnostic.DiagStatus::Error.to_string(), "error")
  assert_eq(@diagnostic.DiagStatus::NotFound.to_string(), "not_found")
}

test "diagnostic: version" {
  assert_true(@diagnostic.diagnostic_version().contains("v0.1.2"))
}