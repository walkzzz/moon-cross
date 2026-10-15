///|
/// 导出函数参数声明
pub(all) struct ExportParam {
  name : String
  typ : String
} derive(Debug, Eq)

///|
/// 导出函数声明
pub(all) struct ExportFunction {
  name : String
  params : Array[ExportParam]
  return_type : String
} derive(Debug, Eq)

///|
/// 导出类型字段声明
pub(all) struct ExportField {
  name : String
  typ : String
} derive(Debug, Eq)

///|
/// 导出类型声明
pub(all) struct ExportType {
  name : String
  fields : Array[ExportField]
} derive(Debug, Eq)

///|
/// moon-cross.json 完整配置
pub(all) struct CrossConfig {
  version : Int
  module_path : String
  package_name : String
  targets : Array[@core.Platform]
  functions : Array[ExportFunction]
  types : Array[ExportType]
} derive(Debug, Eq)

///|
/// 创建默认配置
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
/// 配置版本号
pub fn config_version() -> Int {
  1
}
