///|
/// 构建产品 | Build product
pub(all) struct Product {
  name : String
  parts : Array[String]
  tags : Array[String]
  metadata : Array[(String, String)]
} derive(Debug, Eq)
pub extend Product with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Product with Eq::{not_equal, equal}

///|
/// 构建器 | Builder
pub(all) struct Builder {
  name : String
  parts : Array[String]
  tags : Array[String]
  metadata : Array[(String, String)]
} derive(Debug, Eq)
pub extend Builder with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Builder with Eq::{not_equal, equal}

///|
/// 创建构建器 | Create builder
pub fn builder_create(name : String) -> Builder {
  { name, parts: [], tags: [], metadata: [] }
}

///|
/// 添加部件 | Add part
pub fn builder_add_part(b : Builder, part : String) -> Builder {
  let new_parts = []
  for p in b.parts {
    new_parts.push(p)
  }
  new_parts.push(part)
  { name: b.name, parts: new_parts, tags: b.tags, metadata: b.metadata }
}

///|
/// 添加标签 | Add tag
pub fn builder_add_tag(b : Builder, tag : String) -> Builder {
  let new_tags = []
  for t in b.tags {
    new_tags.push(t)
  }
  new_tags.push(tag)
  { name: b.name, parts: b.parts, tags: new_tags, metadata: b.metadata }
}

///|
/// 添加元数据 | Add metadata
pub fn builder_add_meta(b : Builder, key : String, value : String) -> Builder {
  let new_meta = []
  for m in b.metadata {
    new_meta.push(m)
  }
  new_meta.push((key, value))
  { name: b.name, parts: b.parts, tags: b.tags, metadata: new_meta }
}

///|
/// 构建产品 | Build product
pub fn builder_build(b : Builder) -> Product {
  { name: b.name, parts: b.parts, tags: b.tags, metadata: b.metadata }
}

///|
/// 重置构建器 | Reset builder
pub fn builder_reset(b : Builder) -> Builder {
  { name: b.name, parts: [], tags: [], metadata: [] }
}

///|
/// 部件数量 | Part count
pub fn builder_part_count(b : Builder) -> Int {
  b.parts.length()
}

///|
/// 标签数量 | Tag count
pub fn builder_tag_count(b : Builder) -> Int {
  b.tags.length()
}

///|
/// 获取元数据 | Get metadata
pub fn builder_get_meta(b : Builder, key : String) -> String? {
  for m in b.metadata {
    if m.0 == key {
      return Some(m.1)
    }
  }
  None
}

///|
/// 产品部件数量 | Product part count
pub fn product_part_count(p : Product) -> Int {
  p.parts.length()
}

///|
/// 产品标签数量 | Product tag count
pub fn product_tag_count(p : Product) -> Int {
  p.tags.length()
}

///|
/// 构建器版本 | Builder version
pub fn builder_version() -> String {
  "moon-cross builder v0.3.3"
}

///|
/// Builder 实现 Named trait | Builder implements Named
pub impl @trait.Named for Builder with name(self) {
  self.name
}
pub extend Builder with @trait.Named::{name}

///|
/// Builder 实现 Resettable trait | Builder implements Resettable
pub impl @trait.Resettable for Builder with reset(self) {
  builder_reset(self)
}
pub extend Builder with @trait.Resettable::{reset}