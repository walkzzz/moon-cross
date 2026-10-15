///|
/// 脚手架初始化选项
pub(all) struct ScaffoldOptions {
  name : String
  platforms : Array[@core.Platform]
  output_dir : String
} derive(Debug, Eq)

///|
/// 脚手架版本
pub fn scaffold_version() -> String {
  "moon-cross scaffold v0.1.0"
}

///|
/// 生成脚手架文件列表
pub fn scaffold_file_list(opts : ScaffoldOptions) -> Array[String] {
  [
    opts.name + "/moon-cross.json",
    opts.name + "/README.md",
    opts.name + "/src/moon.pkg.json",
    opts.name + "/src/lib.mbt",
  ]
}

///|
/// 默认脚手架选项（全平台）
pub fn default_scaffold_options(name : String) -> ScaffoldOptions {
  { name, platforms: @core.all_platforms(), output_dir: "./" + name, }
}
