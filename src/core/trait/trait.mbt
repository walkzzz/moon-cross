///|
/// 可命名 trait |; types with a name
pub(open) trait Named {
  name(Self) -> String
}

///|
/// 可检查 trait; types that can be checked for validity
pub(open) trait Checkable {
  check(Self) -> Bool
}

///|
/// 可重置 trait; types that can be reset
pub(open) trait Resettable {
  reset(Self) -> Self
}

///|
/// 可验证 trait; types that can be verified; sub-trait of Checkable
pub(open) trait Verifiable : Checkable {
  verify(Self) -> Bool
}

///|
/// 可运行 trait; types that can be run
pub(open) trait Runnable {
  run(Self) -> Bool
}

///|
/// 可计数 trait; types with a count
pub(open) trait Countable {
  count(Self) -> Int

}

///|
/// 可描述 trait; types with a description
pub(open) trait Describable {
  describe(Self) -> String
}

///|
/// 可摘要 trait; types that can produce a summary
pub(open) trait Summarizable {
  summary(Self) -> String
}

///|
/// 可克隆 trait; types that can be cloned
pub(open) trait Cloneable {
  clone(Self) -> Self
}

///|
/// 可序列化 trait; types that can be serialized to string
pub(open) trait Serializable {
  serialize(Self) -> String
}

///|
/// 可迭代 trait; types that can be iterated
pub(open) trait Iterable {
  iter_count(Self) -> Int
}

///|
/// 有版本 trait; types with a version string
pub(open) trait Versioned {
  version(Self) -> String
}

///|
/// 可排序 trait; types that can be ordered (like Compare)
pub(open) trait Ordered {
  compare(Self, Self) -> Int
}

///|
/// 可展示 trait; sub-trait combining Named + Describable
pub(open) trait Displayable : Named + Describable {}

///|
/// trait 包版本 | Trait package version
pub fn trait_version() -> String {
  "moon-cross trait v0.3.13"
}