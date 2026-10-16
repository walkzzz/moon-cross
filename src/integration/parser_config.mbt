///|
/// moonbitlang/parser 模块名 | moonbitlang/parser module name
pub fn parser_module_name() -> String {
  "moonbitlang_parser"
}

///|
/// moonbitlang/parser 版本 | moonbitlang/parser version
pub fn parser_version() -> String {
  "0.4.4"
}

///|
/// parser 导出函数列表（基于 moonbitlang/parser v0.4.4 公开 API） | parser export function list (based on moonbitlang/parser v0.4.4 public API)
pub fn parser_export_functions() -> Array[@config.ExportFunction] {
  [
    {
      name: "parser_parse",
      params: [{ name: "source", typ: "String" }],
      return_type: "Ast",
    },
    {
      name: "parser_tokenize",
      params: [{ name: "source", typ: "String" }],
      return_type: "Array",
    },
    {
      name: "parser_to_string",
      params: [{ name: "ast", typ: "Ast" }],
      return_type: "String",
    },
    {
      name: "parser_ast_kind",
      params: [{ name: "ast", typ: "Ast" }],
      return_type: "String",
    },
    {
      name: "parser_ast_children",
      params: [{ name: "ast", typ: "Ast" }],
      return_type: "Array",
    },
    {
      name: "parser_token_kind",
      params: [{ name: "token", typ: "Token" }],
      return_type: "String",
    },
    {
      name: "parser_token_value",
      params: [{ name: "token", typ: "Token" }],
      return_type: "String",
    },
    {
      name: "parser_token_position",
      params: [{ name: "token", typ: "Token" }],
      return_type: "Span",
    },
    {
      name: "parser_format",
      params: [{ name: "ast", typ: "Ast" }],
      return_type: "String",
    },
    {
      name: "parser_comments",
      params: [{ name: "ast", typ: "Ast" }],
      return_type: "Array",
    },
  ]
}

///|
/// parser 导出类型 | parser export types
pub fn parser_export_types() -> Array[@config.ExportType] {
  [
    {
      name: "Token",
      fields: [
        { name: "kind", typ: "String" },
        { name: "value", typ: "String" },
        { name: "span", typ: "Span" },
      ],
    },
    {
      name: "Ast",
      fields: [
        { name: "kind", typ: "String" },
        { name: "children", typ: "Array" },
        { name: "span", typ: "Span" },
      ],
    },
    {
      name: "Span",
      fields: [
        { name: "start", typ: "Int" },
        { name: "end", typ: "Int" },
      ],
    },
    {
      name: "ParseError",
      fields: [
        { name: "message", typ: "String" },
        { name: "position", typ: "Int" },
        { name: "expected", typ: "String" },
      ],
    },
  ]
}

///|
/// 为 moonbitlang/parser 生成完整的跨平台配置 | Generate complete cross-platform config for moonbitlang/parser
pub fn parser_cross_config() -> @config.CrossConfig {
  {
    version: 1,
    module_path: "moonbitlang/parser",
    package_name: "moonbitlang/parser",
    targets: @core.all_platforms(),
    functions: parser_export_functions(),
    types: parser_export_types(),
  }
}

///|
/// parser 导出函数数量 | parser export function count
pub fn parser_function_count() -> Int {
  parser_export_functions().length()
}

///|
/// parser 导出类型数量 | parser export type count
pub fn parser_type_count() -> Int {
  parser_export_types().length()
}

///|
/// parser 目标平台数量 | parser target platform count
pub fn parser_target_count() -> Int {
  parser_cross_config().targets.length()
}