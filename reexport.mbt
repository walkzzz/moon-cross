///|
/// Moon Cross 根包重导出 | Root package re-exports
/// 对外提供统一入口 @moon-cross | Unified entry point @moon-cross

///|
/// 核心类型重导出 | Core types re-export
pub using @core { type Platform, type Arch, type TargetTriple }

///|
/// Trait 重导出 | Trait re-exports
pub using @trait {
  trait Named,
  trait Checkable,
  trait Resettable,
  trait Verifiable,
  trait Runnable,
  trait Countable,
  trait Describable,
  trait Summarizable,
}

///|
/// 形式化证明重导出 | Proof types re-export
pub using @proof { type ProofResult, type Contract, type Invariant }

///|
/// Mock 框架重导出 | Mock types re-export
pub using @mock { type Mock, type Stub, type Spy, type Fake }

///|
/// E2E 测试框架重导出 | E2E types re-export
pub using @e2e { type Step, type Scenario, type ScenarioResult, type E2EReport }

///|
/// AI 测试工具重导出 | AI test types re-export
pub using @ai_test { type TestCase, type BoundaryCase, type CoverageReport, type AITestResult }

///|
/// 根包版本 | Root package version
pub fn moon_cross_version() -> String {
  "moon-cross v0.3.4"
}