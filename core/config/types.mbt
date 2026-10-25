///|
/// 导出函数参数声明 | Export function parameter declaration
pub(all) struct ExportParam {
  name : String
  typ : String
} derive(Debug, Eq)
pub extend ExportParam with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ExportParam with Eq::{not_equal, equal}

///|
/// 导出函数声明 | Export function declaration
pub(all) struct ExportFunction {
  name : String
  params : Array[ExportParam]
  return_type : String
} derive(Debug, Eq)
pub extend ExportFunction with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ExportFunction with Eq::{not_equal, equal}

///|
/// 导出类型字段声明 | Export type field declaration
pub(all) struct ExportField {
  name : String
  typ : String
} derive(Debug, Eq)
pub extend ExportField with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ExportField with Eq::{not_equal, equal}

///|
/// 导出类型声明 | Export type declaration
pub(all) struct ExportType {
  name : String
  fields : Array[ExportField]
} derive(Debug, Eq)
pub extend ExportType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ExportType with Eq::{not_equal, equal}

///|
/// moon-cross.json 完整配置 | moon-cross.json full configuration
pub(all) struct CrossConfig {
  version : Int
  module_path : String
  package_name : String
  targets : Array[@core.Platform]
  functions : Array[ExportFunction]
  types : Array[ExportType]
} derive(Debug, Eq)
pub extend CrossConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CrossConfig with Eq::{not_equal, equal}

///|
/// 创建默认配置 | Create default configuration
pub fn default_config(name : String) -> CrossConfig {
  {
    version: 1,
    module_path: "./" + name,
    package_name: "walkzzz/" + name,
    targets: @core.all_platforms(),
    functions: [],
    types: [],
  }
}

///|
/// 配置版本号 | Configuration version number
pub fn config_version() -> Int {
  1
}


///|
/// ExportParam 实现 Named trait | ExportParam implements Named
pub impl @trait.Named for ExportParam with name(self) {
  self.name
}
pub extend ExportParam with @trait.Named::{name}

///|
/// ExportFunction 实现 Named trait | ExportFunction implements Named
pub impl @trait.Named for ExportFunction with name(self) {
  self.name
}
pub extend ExportFunction with @trait.Named::{name}

///|
/// ExportField 实现 Named trait | ExportField implements Named
pub impl @trait.Named for ExportField with name(self) {
  self.name
}
pub extend ExportField with @trait.Named::{name}

///|
/// ExportType 实现 Named trait | ExportType implements Named
pub impl @trait.Named for ExportType with name(self) {
  self.name
}
pub extend ExportType with @trait.Named::{name}


///|
/// ExportParam 实现 Hashable trait | ExportParam implements Hashable
pub impl @trait.Hashable for ExportParam with hash(self) {
  @trait.Named::name(self).length()
}
pub extend ExportParam with @trait.Hashable::{hash}

///|
/// ExportFunction 实现 Hashable trait | ExportFunction implements Hashable
pub impl @trait.Hashable for ExportFunction with hash(self) {
  @trait.Named::name(self).length()
}
pub extend ExportFunction with @trait.Hashable::{hash}

///|
/// ExportField 实现 Hashable trait | ExportField implements Hashable
pub impl @trait.Hashable for ExportField with hash(self) {
  @trait.Named::name(self).length()
}
pub extend ExportField with @trait.Hashable::{hash}

///|
/// ExportType 实现 Hashable trait | ExportType implements Hashable
pub impl @trait.Hashable for ExportType with hash(self) {
  @trait.Named::name(self).length()
}
pub extend ExportType with @trait.Hashable::{hash}