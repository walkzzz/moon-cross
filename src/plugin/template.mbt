///|
/// 模板信息 | Template information
pub(all) struct TemplateInfo {
  name : String
  description : String
  category : String
  file_count : Int
} derive(Debug, Eq)

pub extend TemplateInfo with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TemplateInfo with Eq::{not_equal, equal}

///|
/// 模板文件 | Template file
pub(all) struct TemplateFile {
  path : String
  content : String
  is_binary : Bool
} derive(Debug, Eq)

pub extend TemplateFile with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TemplateFile with Eq::{not_equal, equal}

///|
/// 模板实例化参数 | Template instantiation parameters
pub(all) struct TemplateParams {
  project_name : String
  target_platforms : Array[String]
  ffi_enabled : Bool
  author : String
} derive(Debug, Eq)

pub extend TemplateParams with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TemplateParams with Eq::{not_equal, equal}

///|
/// 内置模板列表 | Built-in template list
pub fn builtin_templates() -> Array[TemplateInfo] {
  [
    { name: "basic-library", description: "Basic cross-platform library template", category: "library", file_count: 5 },
    { name: "ffi-wrapper", description: "FFI wrapper library template", category: "ffi", file_count: 8 },
    { name: "full-application", description: "Full cross-platform application template", category: "application", file_count: 12 },
    { name: "plugin-template", description: "Plugin development template", category: "plugin", file_count: 6 },
  ]
}

///|
/// 创建模板参数 | Create template parameters
pub fn make_template_params(project_name : String, target_platforms : Array[String], ffi_enabled : Bool, author : String) -> TemplateParams {
  { project_name, target_platforms, ffi_enabled, author }
}

///|
/// 生成模板文件 | Generate template files
pub fn generate_template_files(template_name : String, params : TemplateParams) -> Array[TemplateFile] {
  let files = []
  if template_name == "basic-library" {
    files.push({ path: "moon.mod", content: generate_moon_mod(params), is_binary: false })
    files.push({ path: "src/lib.mbt", content: generate_lib_source(params), is_binary: false })
    files.push({ path: "src/lib_test.mbt", content: generate_lib_test(params), is_binary: false })
    files.push({ path: "README.md", content: generate_readme(params), is_binary: false })
    files.push({ path: "moon-cross.json", content: generate_cross_config(params), is_binary: false })
  }
  if template_name == "ffi-wrapper" {
    files.push({ path: "moon.mod", content: generate_moon_mod(params), is_binary: false })
    files.push({ path: "src/lib.mbt", content: generate_lib_source(params), is_binary: false })
    files.push({ path: "src/lib_test.mbt", content: generate_lib_test(params), is_binary: false })
    files.push({ path: "src/c_wrapper.h", content: generate_c_header(params), is_binary: false })
    files.push({ path: "src/c_wrapper.c", content: generate_c_source(params), is_binary: false })
    files.push({ path: "README.md", content: generate_readme(params), is_binary: false })
    files.push({ path: "moon-cross.json", content: generate_cross_config(params), is_binary: false })
    files.push({ path: "Makefile", content: generate_makefile(params), is_binary: false })
  }
  files
}

///|
/// 生成 moon.mod 内容 | Generate moon.mod content
fn generate_moon_mod(params : TemplateParams) -> String {
  "name = \"\{params.author}/\{params.project_name}\"\n\nversion = \"0.1.0\"\n\nlicense = \"MIT\"\n"
}

///|
/// 生成库源码 | Generate library source
fn generate_lib_source(params : TemplateParams) -> String {
  "///|\npub fn \{params.project_name}_version() -> String {\n  \"0.1.0\"\n}\n"
}

///|
/// 生成库测试 | Generate library test
fn generate_lib_test(_params : TemplateParams) -> String {
  "test \"version\" {\n  assert_true(true)\n}\n"
}

///|
/// 生成 README | Generate README
fn generate_readme(params : TemplateParams) -> String {
  "# \{params.project_name}\n\nCross-platform MoonBit library.\n\n## Build\n\n```bash\nmoon check\nmoon test\n```\n"
}

///|
/// 生成跨平台配置 | Generate cross-platform config
fn generate_cross_config(params : TemplateParams) -> String {
  let mut platforms_str = ""
  let mut first = true
  for p in params.target_platforms {
    if !first {
      platforms_str = platforms_str + ", "
    }
    platforms_str = platforms_str + p
    first = false
  }
  "{\n  \"library\": \"\{params.project_name}\",\n  \"ffi\": \{params.ffi_enabled},\n  \"platforms\": [\{platforms_str}]\n}\n"
}

///|
/// 生成 C 头文件 | Generate C header file
fn generate_c_header(params : TemplateParams) -> String {
  "#ifndef \{params.project_name}_H\n#define \{params.project_name}_H\n\n#include <stdint.h>\n\n#endif\n"
}

///|
/// 生成 C 源文件 | Generate C source file
fn generate_c_source(params : TemplateParams) -> String {
  "#include \"\{params.project_name}.h\"\n"
}

///|
/// 生成 Makefile | Generate Makefile
fn generate_makefile(_params : TemplateParams) -> String {
  "all:\n\tmoon build\n\ntest:\n\tmoon test\n"
}

///|
/// 查找模板 | Find template by name
pub fn find_template(name : String) -> TemplateInfo? {
  let templates = builtin_templates()
  for template in templates {
    if template.name == name {
      return Some(template)
    }
  }
  None
}

///|
/// 列出指定类别的模板 | List templates by category
pub fn templates_by_category(category : String) -> Array[TemplateInfo] {
  let result = []
  for template in builtin_templates() {
    if template.category == category {
      result.push(template)
    }
  }
  result
}

///|
/// 模板库版本 | Template library version
pub fn template_version() -> String {
  "moon-cross plugin/template v1.1.0"
}