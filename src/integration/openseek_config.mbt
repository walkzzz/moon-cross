///|
/// openseek 模块名
pub fn openseek_module_name() -> String {
  "moonbitlang_openseek"
}

///|
/// openseek 版本
pub fn openseek_version() -> String {
  "latest"
}

///|
/// openseek/deepseek 导出函数列表（基于纯数据层 API）
pub fn openseek_export_functions() -> Array[@config.ExportFunction] {
  [
    {
      name: "chat_message_create",
      params: [
        { name: "role", typ: "String" },
        { name: "content", typ: "String" },
      ],
      return_type: "ChatMessage",
    },
    {
      name: "tool_definition_create",
      params: [
        { name: "name", typ: "String" },
        { name: "description", typ: "String" },
        { name: "parameters", typ: "String" },
      ],
      return_type: "ToolDefinition",
    },
    {
      name: "chat_response_decode",
      params: [{ name: "json", typ: "String" }],
      return_type: "ChatResponse",
    },
    {
      name: "model_from_string",
      params: [{ name: "name", typ: "String" }],
      return_type: "Model",
    },
    {
      name: "role_from_string",
      params: [{ name: "name", typ: "String" }],
      return_type: "Role",
    },
    {
      name: "chat_message_get_role",
      params: [{ name: "msg", typ: "ChatMessage" }],
      return_type: "String",
    },
    {
      name: "chat_message_get_content",
      params: [{ name: "msg", typ: "ChatMessage" }],
      return_type: "String",
    },
    {
      name: "tool_definition_get_name",
      params: [{ name: "tool", typ: "ToolDefinition" }],
      return_type: "String",
    },
  ]
}

///|
/// openseek/deepseek 导出类型
pub fn openseek_export_types() -> Array[@config.ExportType] {
  [
    {
      name: "Model",
      fields: [
        { name: "DeepSeekFlash", typ: "Unit" },
        { name: "DeepSeekChat", typ: "Unit" },
        { name: "KimiK27", typ: "Unit" },
        { name: "Glm53", typ: "Unit" },
      ],
    },
    {
      name: "Role",
      fields: [
        { name: "System", typ: "Unit" },
        { name: "User", typ: "Unit" },
        { name: "Assistant", typ: "Unit" },
        { name: "Tool", typ: "Unit" },
      ],
    },
    {
      name: "ChatMessage",
      fields: [
        { name: "role", typ: "Role" },
        { name: "content", typ: "String" },
      ],
    },
    {
      name: "ToolDefinition",
      fields: [
        { name: "name", typ: "String" },
        { name: "description", typ: "String" },
        { name: "parameters", typ: "String" },
        { name: "strict", typ: "Bool" },
      ],
    },
    {
      name: "ChatResponse",
      fields: [
        { name: "content", typ: "String" },
        { name: "model", typ: "String" },
        { name: "usage", typ: "String" },
      ],
    },
  ]
}

///|
/// 为 openseek/deepseek 生成完整的跨平台配置
pub fn openseek_cross_config() -> @config.CrossConfig {
  {
    version: 1,
    module_path: "moonbitlang/openseek/deepseek",
    package_name: "moonbitlang/openseek",
    targets: @core.all_platforms(),
    functions: openseek_export_functions(),
    types: openseek_export_types(),
  }
}

///|
/// openseek 导出函数数量
pub fn openseek_function_count() -> Int {
  openseek_export_functions().length()
}

///|
/// openseek 导出类型数量
pub fn openseek_type_count() -> Int {
  openseek_export_types().length()
}

///|
/// openseek 目标平台数量
pub fn openseek_target_count() -> Int {
  openseek_cross_config().targets.length()
}