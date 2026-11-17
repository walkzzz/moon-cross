// toml-cross — moonbit-community/toml 跨平台导出包装 | cross-platform export wrapper for moonbit-community/toml
// 导出符号前缀 mt_ — native 静态库中的稳定 C 符号 | exported symbols prefixed mt_ — stable C symbols

///|
/// 解析 TOML 文档并返回格式化输出，失败返回空字符串 | parse a TOML document and return formatted output, empty string on failure
#export_name("mt_toml_format")
pub fn toml_format(input : String) -> String {
  let outcome = try Ok(@toml.parse(input)) catch {
    _ => Err(())
  }
  match outcome {
    Ok(value) => value.to_string()
    Err(_) => ""
  }
}

///|
/// 判断输入是否为合法 TOML 文档 | whether the input is a valid TOML document
#export_name("mt_toml_validate")
pub fn toml_validate(input : String) -> Bool {
  let outcome = try Ok(@toml.parse(input)) catch {
    _ => Err(())
  }
  match outcome {
    Ok(value) => value.validate()
    Err(_) => false
  }
}

///|
/// 返回解析结果根节点类型名（如 "TomlTable"），失败返回空字符串 | root node type name (e.g. "TomlTable"), empty string on failure
#export_name("mt_toml_root_type")
pub fn toml_root_type(input : String) -> String {
  let outcome = try Ok(@toml.parse(input)) catch {
    _ => Err(())
  }
  match outcome {
    Ok(value) => value.type_name()
    Err(_) => ""
  }
}

///|
/// 统计顶层键数量，失败返回 -1 | count top-level keys, -1 on failure
#export_name("mt_toml_top_keys")
pub fn toml_top_keys(input : String) -> Int {
  let outcome = try Ok(@toml.parse(input)) catch {
    _ => Err(())
  }
  match outcome {
    Ok(@toml.TomlTable(table)) => table.length()
    Ok(_) => 0
    Err(_) => -1
  }
}
