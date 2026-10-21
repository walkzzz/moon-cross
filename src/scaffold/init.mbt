///|
/// 脚手架初始化选项 | Scaffold initialization options
pub(all) struct ScaffoldOptions {
  name : String
  platforms : Array[@core.Platform]
  output_dir : String
} derive(Debug, Eq)
pub extend ScaffoldOptions with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ScaffoldOptions with Eq::{not_equal, equal}

///|
/// 脚手架版本 | Scaffold version
pub fn scaffold_version() -> String {
  "moon-cross scaffold v0.1.0"
}

///|
/// 生成脚手架文件列表 | Generate scaffold file list
pub fn scaffold_file_list(opts : ScaffoldOptions) -> Array[String] {
  [
    opts.name + "/moon-cross.json",
    opts.name + "/README.md",
    opts.name + "/src/moon.pkg.json",
    opts.name + "/src/lib.mbt",
  ]
}

///|
/// 默认脚手架选项（全平台） | Default scaffold options (all platforms)
pub fn default_scaffold_options(name : String) -> ScaffoldOptions {
  { name, platforms: @core.all_platforms(), output_dir: "./" + name, }
}


///|
/// ScaffoldOptions 实现 Named trait | ScaffoldOptions implements Named
pub impl @trait.Named for ScaffoldOptions with name(self) {
  self.name
}
pub extend ScaffoldOptions with @trait.Named::{name}