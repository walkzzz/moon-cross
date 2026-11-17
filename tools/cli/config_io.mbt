///|
/// 配置与文件 IO — CLI 的读写磁盘能力 | Config and file IO — disk read/write capability for CLI

///|
/// 读取并解析 moon-cross.json | Load and parse moon-cross.json
pub async fn load_config(
  path : String,
) -> @config.CrossConfig raise @core.MoonCrossError {
  let text = @fs.read_text(path) catch {
    _ =>
      raise @core.IoError(
        "cannot read config file: \{path} | 无法读取配置文件: \{path}",
      )
  }
  @config.parse_config(text)
}

///|
/// 确保目录存在（递归创建） | Ensure directory exists (recursive)
pub async fn ensure_dir(dir : String) -> Unit raise @core.MoonCrossError {
  @fs.mkdir(dir, recursive=true, allow_exist=true) catch {
    _ =>
      raise @core.IoError(
        "cannot create directory: \{dir} | 无法创建目录: \{dir}",
      )
  }
}

///|
/// 写单个文本文件 | Write a single text file
pub async fn write_file(
  path : String,
  content : String,
) -> Unit raise @core.MoonCrossError {
  @fs.write_text(path, content) catch {
    _ =>
      raise @core.IoError(
        "cannot write file: \{path} | 无法写入文件: \{path}",
      )
  }
}

///|
/// 批量落盘跨平台代码（按平台分子目录） | Write cross-platform code files grouped by platform subdirectory
/// 返回写入文件数 | Returns number of files written
pub async fn write_cross_platform_codes(
  dir : String,
  codes : Array[@codegen.CrossPlatformCode],
) -> Int32 raise @core.MoonCrossError {
  let mut n = 0
  for code in codes {
    let sub = dir + "/" + code.platform
    ensure_dir(sub)
    write_file(sub + "/" + code.filename, code.content)
    n = n + 1
  }
  n
}
