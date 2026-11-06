///|
/// 可命名 trait |; types with a name
pub(open) trait Named {
  fn name(Self) -> String
}

///|
/// 可检查 trait; types that can be checked for validity
pub(open) trait Checkable {
  fn check(Self) -> Bool
}

///|
/// 可重置 trait; types that can be reset
pub(open) trait Resettable {
  fn reset(Self) -> Self
}

///|
/// 可验证 trait; types that can be verified; sub-trait of Checkable
pub(open) trait Verifiable: Checkable {
  fn verify(Self) -> Bool
}

///|
/// 可运行 trait; types that can be run
pub(open) trait Runnable {
  fn run(Self) -> Bool
}

///|
/// 可计数 trait; types with a count
pub(open) trait Countable {
  fn count(Self) -> Int32
}

///|
/// 可描述 trait; types with a description
pub(open) trait Describable {
  fn describe(Self) -> String
}

///|
/// 可摘要 trait; types that can produce a summary
pub(open) trait Summarizable {
  fn summary(Self) -> String
}

///|
/// 可克隆 trait; types that can be cloned
pub(open) trait Cloneable {
  fn clone(Self) -> Self
}

///|
/// 可序列化 trait; types that can be serialized to string
pub(open) trait Serializable {
  fn serialize(Self) -> String
}

///|
/// 可迭代 trait; types that can be iterated
pub(open) trait Iterable {
  fn iter_count(Self) -> Int32
}

///|
/// 有版本 trait; types with a version string
pub(open) trait Versioned {
  fn version(Self) -> String
}

///|
/// 可排序 trait; types that can be ordered (like Compare)
pub(open) trait Ordered {
  fn compare(Self, Self) -> Int32
}

///|
/// 可展示 trait; sub-trait combining Named + Describable
pub(open) trait Displayable: Named + Describable {}

///|
/// 可哈希 trait; types that can be hashed
pub(open) trait Hashable {
  fn hash(Self) -> Int32
}

///|
/// 可构建 trait; types that can produce build output
pub(open) trait Buildable {
  fn build(Self) -> String
}

///|
/// 可渲染 trait; sub-trait of Displayable, types that can render to formatted output
pub(open) trait Renderable: Displayable {
  fn render(Self) -> String = _
}

///|
/// 可配置 trait; types that can be configured with key-value pairs
pub(open) trait Configurable {
  fn configure(Self, String, String) -> Self
}

///|
/// 可观察 trait; types that can be observed/monitored
pub(open) trait Observable {
  fn observe(Self) -> String
}

///|
/// 可验证输入 trait; sub-trait of Checkable, types with input validation
pub(open) trait Validatable: Checkable {
  fn validate(Self) -> Bool = _
}

///|
/// Renderable 默认实现: render = name + ": " + describe
impl Renderable with fn render(self) {
  Named::name(self) + ": " + Describable::describe(self)
}

///|
/// Validatable 默认实现@实现: validate = check
impl Validatable with fn validate(self) {
  Checkable::check(self)
}

///|
/// trait 包版本 | Trait package version
pub fn trait_version() -> String {
  "moon-cross trait v0.3.30"
}
