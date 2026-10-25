///|
/// 产品类型 | Product type
pub(all) struct ProductInfo {
  type_name : String
  version : String
  attributes : Array[String]
} derive(Debug, Eq)
pub extend ProductInfo with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProductInfo with Eq::{not_equal, equal}

///|
/// 工厂注册项 | Factory registration
pub(all) struct FactoryRegistration {
  type_name : String
  creator : String
} derive(Debug, Eq)
pub extend FactoryRegistration with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FactoryRegistration with Eq::{not_equal, equal}

///|
/// 工厂 | Factory
pub(all) struct Factory {
  registrations : Array[FactoryRegistration]
} derive(Debug, Eq)
pub extend Factory with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Factory with Eq::{not_equal, equal}

///|
/// 创建工厂 | Create factory
pub fn factory_create() -> Factory {
  { registrations: [] }
}

///|
/// 注册类型 | Register type
pub fn factory_register(f : Factory, type_name : String, creator : String) -> Factory {
  let new_regs = []
  for r in f.registrations {
    new_regs.push(r)
  }
  new_regs.push({ type_name, creator })
  { registrations: new_regs }
}

///|
/// 创建产品 | Create product
pub fn factory_make(f : Factory, type_name : String, version : String) -> ProductInfo? {
  for r in f.registrations {
    if r.type_name == type_name {
      return Some({ type_name, version, attributes: [] })
    }
  }
  None
}

///|
/// 创建带属性产品 | Create product with attributes
pub fn factory_make_with_attrs(f : Factory, type_name : String, version : String, attrs : Array[String]) -> ProductInfo? {
  for r in f.registrations {
    if r.type_name == type_name {
      return Some({ type_name, version, attributes: attrs })
    }
  }
  None
}

///|
/// 检查类型是否注册 | Check if type is registered
pub fn factory_has_type(f : Factory, type_name : String) -> Bool {
  for r in f.registrations {
    if r.type_name == type_name {
      return true
    }
  }
  false
}

///|
/// 已注册类型数量 | Registered type count
pub fn factory_type_count(f : Factory) -> Int {
  f.registrations.length()
}

///|
/// 注销类型 | Unregister type
pub fn factory_unregister(f : Factory, type_name : String) -> Factory {
  let new_regs = []
  for r in f.registrations {
    if r.type_name != type_name {
      new_regs.push(r)
    }
  }
  { registrations: new_regs }
}

///|
/// 工厂版本 | Factory version
pub fn factory_version() -> String {
  "moon-cross factory v0.3.4"
}

///|
/// ProductInfo 实现 Named trait | ProductInfo implements Named
pub impl @trait.Named for ProductInfo with name(self) {
  self.type_name
}
pub extend ProductInfo with @trait.Named::{name}

///|
/// ProductInfo 实现 Hashable trait | ProductInfo implements Hashable
pub impl @trait.Hashable for ProductInfo with hash(self) {
  @trait.Named::name(self).length()
}
pub extend ProductInfo with @trait.Hashable::{hash}