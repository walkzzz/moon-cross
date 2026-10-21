///|
/// 可命名 trait | Named trait: types with a name
pub(open) trait Named {
  name(Self) -> String
}

///|
/// 可检查 trait | Checkable trait: types that can be checked for validity
pub(open) trait Checkable {
  check(Self) -> Bool
}

///|
/// 可重置 trait | Resettable trait: types that can be reset
pub(open) trait Resettable {
  reset(Self) -> Self
}

///|
/// 可验证 trait | Verifiable trait: types that can be verified
pub(open) trait Verifiable {
  verify(Self) -> Bool
}

///|
/// 可运行 trait | Runnable trait: types that can be run
pub(open) trait Runnable {
  run(Self) -> Bool
}

///|
/// 可计数 trait | Countable trait: types with a count
pub(open) trait Countable {
  count(Self) -> Int
}

///|
/// 可描述 trait | Describable trait: types with a description
pub(open) trait Describable {
  describe(Self) -> String
}

///|
/// 可摘要 trait | Summarizable trait: types that can produce a summary
pub(open) trait Summarizable {
  summary(Self) -> String
}

///|
/// 可克隆 trait | Cloneable trait: types that can be cloned
pub(open) trait Cloneable {
  clone(Self) -> Self
}

///|
/// 可序列化 trait | Serializable trait: types that can be serialized to string
pub(open) trait Serializable {
  serialize(Self) -> String
}

///|
/// 可迭代 trait | Iterable trait: types that can be iterated
pub(open) trait Iterable {
  iter_count(Self) -> Int
}

///|
/// trait 包版本 | Trait package version
pub fn trait_version() -> String {
  "moon-cross trait v0.3.10"
}