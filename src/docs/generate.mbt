///|
/// 文档格式 | Documentation format
pub(all) enum DocFormat {
  Markdown
  Json
  Html
} derive(Debug, Eq)

pub extend DocFormat with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DocFormat with Eq::{not_equal, equal}

///|
/// API 文档条目 | API documentation entry
pub(all) struct ApiDocEntry {
  name : String
  signature : String
  description : String
  examples : Array[String]
  platform_support : Array[@core.Platform]
} derive(Debug, Eq)

pub extend ApiDocEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ApiDocEntry with Eq::{not_equal, equal}

///|
/// 文档章节 | Documentation section
pub(all) struct DocSection {
  title : String
  description : String
  entries : Array[ApiDocEntry]
} derive(Debug, Eq)

pub extend DocSection with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DocSection with Eq::{not_equal, equal}

///|
/// 文档配置 | Documentation configuration
pub(all) struct DocConfig {
  format : DocFormat
  output_dir : String
  include_private : Bool
  include_examples : Bool
} derive(Debug, Eq)

pub extend DocConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DocConfig with Eq::{not_equal, equal}

///|
/// 默认文档配置 | Default documentation configuration
pub fn default_doc_config() -> DocConfig {
  { format: Markdown, output_dir: "docs/api", include_private: false, include_examples: true }
}

///|
/// 创建 API 文档条目 | Create API documentation entry
pub fn make_doc_entry(
  name : String,
  signature : String,
  description : String,
  examples : Array[String],
  platform_support : Array[@core.Platform],
) -> ApiDocEntry {
  { name, signature, description, examples, platform_support }
}

///|
/// 创建文档章节 | Create documentation section
pub fn make_doc_section(title : String, description : String, entries : Array[ApiDocEntry]) -> DocSection {
  { title, description, entries }
}

///|
/// 从导出函数生成 API 文档 | Generate API documentation from export functions
pub fn generate_api_doc(functions : Array[@config.ExportFunction]) -> Array[ApiDocEntry] {
  let entries = []
  for func in functions {
    let mut param_str = ""
    let mut first = true
    for param in func.params {
      if !first {
        param_str = param_str + ", "
      }
      param_str = param_str + param.name + ": " + param.typ
      first = false
    }
    let sig = "fn \{func.name}(\{param_str}) -> \{func.return_type}"
    let desc = "Export function: \{func.name}"
    let platforms = @core.all_platforms()
    entries.push(make_doc_entry(func.name, sig, desc, [], platforms))
  }
  entries
}

///|
/// 生成 Markdown 格式文档 | Generate Markdown format documentation
pub fn generate_markdown(sections : Array[DocSection]) -> String {
  let mut doc = "# Moon Cross API Documentation\n\n"
  for section in sections {
    doc = doc + "## \{section.title}\n\n"
    if section.description.length() > 0 {
      doc = doc + "\{section.description}\n\n"
    }
    for entry in section.entries {
      doc = doc + "### \{entry.name}\n\n"
      doc = doc + "```moonbit\n\{entry.signature}\n```\n\n"
      if entry.description.length() > 0 {
        doc = doc + "\{entry.description}\n\n"
      }
      if entry.examples.length() > 0 {
        doc = doc + "**Examples:**\n\n"
        for example in entry.examples {
          doc = doc + "```moonbit\n\{example}\n```\n\n"
        }
      }
      if entry.platform_support.length() > 0 {
        doc = doc + "**Platform Support:** "
        let mut first = true
        for p in entry.platform_support {
          if !first {
            doc = doc + ", "
          }
          doc = doc + p.display_name()
          first = false
        }
        doc = doc + "\n\n"
      }
    }
  }
  doc
}

///|
/// 生成 JSON 格式文档 | Generate JSON format documentation
pub fn generate_json(sections : Array[DocSection]) -> String {
  let mut json = "{\n  \"sections\": [\n"
  let mut first_section = true
  for section in sections {
    if !first_section {
      json = json + ",\n"
    }
    json = json + "    {\n      \"title\": \"\{section.title}\",\n      \"entries\": [\n"
    let mut first_entry = true
    for entry in section.entries {
      if !first_entry {
        json = json + ",\n"
      }
      json = json + "        {\"name\": \"\{entry.name}\", \"signature\": \"\{entry.signature}\"}"
      first_entry = false
    }
    json = json + "\n      ]\n    }"
    first_section = false
  }
  json = json + "\n  ]\n}"
  json
}

///|
/// DocFormat 转字符串 | DocFormat to string
pub fn DocFormat::to_string(self : DocFormat) -> String {
  match self {
    Markdown => "markdown"
    Json => "json"
    Html => "html"
  }
}

///|
/// 文档生成版本 | Documentation generation version
pub fn docs_version() -> String {
  "moon-cross docs v1.1.0"
}