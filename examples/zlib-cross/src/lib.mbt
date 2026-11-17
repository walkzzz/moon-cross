// zlib-cross — mizchi/zlib 跨平台导出包装 | cross-platform export wrapper for mizchi/zlib
// 导出符号前缀 mz_ — native 静态库中的稳定 C 符号 | exported symbols prefixed mz_ — stable C symbols in the native static archive
// 说明：mizchi/zlib 已归档（API 冻结于 0.4.12），新项目建议 moonbitlang/core 的 flate/zlib/gzip

///|
/// zlib 压缩（fixed Huffman） | zlib compression (fixed Huffman)
#export_name("mz_zlib_compress")
pub fn zlib_compress_data(data : Bytes) -> Bytes {
  @zlib.zlib_compress(data)
}

///|
/// zlib 解压，失败返回空 Bytes | zlib decompression, returns empty Bytes on failure
#export_name("mz_zlib_decompress")
pub fn zlib_decompress_data(data : Bytes) -> Bytes {
  let result = try Ok(@zlib.zlib_decompress(data)) catch {
    _ => Err(())
  }
  match result {
    Ok(out) => out
    Err(_) => b""
  }
}

///|
/// deflate 压缩 | raw deflate compression
#export_name("mz_deflate_compress")
pub fn deflate_compress_data(data : Bytes) -> Bytes {
  @zlib.deflate_compress(data)
}

///|
/// deflate 解压，失败返回空 Bytes | raw deflate decompression, returns empty Bytes on failure
#export_name("mz_deflate_decompress")
pub fn deflate_decompress_data(data : Bytes) -> Bytes {
  let result = try Ok(@zlib.deflate_decompress(data)) catch {
    _ => Err(())
  }
  match result {
    Ok(out) => out
    Err(_) => b""
  }
}

///|
/// gzip 压缩（stored blocks） | gzip compression (stored blocks)
#export_name("mz_gzip_compress")
pub fn gzip_compress_data(data : Bytes) -> Bytes {
  @zlib.gzip_compress(data)
}

///|
/// gzip 解压，失败返回空 Bytes | gzip decompression, returns empty Bytes on failure
#export_name("mz_gzip_decompress")
pub fn gzip_decompress_data(data : Bytes) -> Bytes {
  let result = try Ok(@zlib.gzip_decompress(data)) catch {
    _ => Err(())
  }
  match result {
    Ok(out) => out
    Err(_) => b""
  }
}

///|
/// Adler-32 校验和 | Adler-32 checksum
#export_name("mz_adler32")
pub fn adler32_sum(data : Bytes) -> Int {
  @zlib.adler32(data)
}

///|
/// CRC-32 校验和（反射多项式 0xEDB88320） | CRC-32 checksum (reflected polynomial 0xEDB88320)
#export_name("mz_crc32")
pub fn crc32_sum(data : Bytes) -> Int {
  @zlib.crc32(data).reinterpret_as_int()
}

///|
/// 判断数据是否为可解压的 zlib 流 | whether data is a decompressible zlib stream
#export_name("mz_zlib_can_decompress")
pub fn zlib_can_decompress(data : Bytes) -> Bool {
  let result = try Ok(@zlib.zlib_decompress(data)) catch {
    _ => Err(())
  }
  match result {
    Ok(_) => true
    Err(_) => false
  }
}
