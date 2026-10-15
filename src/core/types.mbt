///|
/// 跨平台目标平台 | Cross-platform target platform
pub(all) enum Platform {
  Ios
  Android
  Windows
  Ohos
} derive(Debug, Eq)

///|
/// CPU 架构 | CPU architecture
pub(all) enum Arch {
  Arm64
  X86_64
} derive(Debug, Eq)

///|
/// 目标三元组（platform + arch + triple string） | Target triple (platform + arch + triple string)
pub(all) struct TargetTriple {
  platform : Platform
  arch : Arch
  triple : String
} derive(Debug, Eq)

///|
/// 平台转字符串标识 | Platform to string identifier
pub fn Platform::to_id(self : Platform) -> String {
  match self {
    Ios => "ios"
    Android => "android"
    Windows => "windows"
    Ohos => "ohos"
  }
}

///|
/// 平台显示名 | Platform display name
pub fn Platform::display_name(self : Platform) -> String {
  match self {
    Ios => "iOS"
    Android => "Android"
    Windows => "Windows"
    Ohos => "HarmonyOS"
  }
}

///|
/// 从字符串解析平台 | Parse platform from string
pub fn Platform::from_id(s : String) -> Platform? {
  match s {
    "ios" => Some(Ios)
    "android" => Some(Android)
    "windows" => Some(Windows)
    "ohos" => Some(Ohos)
    _ => None
  }
}

///|
/// 所有平台列表 | All platforms list
pub fn all_platforms() -> Array[Platform] {
  [Ios, Android, Windows, Ohos]
}

///|
/// 架构转字符串标识 | Architecture to string identifier
pub fn Arch::to_id(self : Arch) -> String {
  match self {
    Arm64 => "arm64"
    X86_64 => "x86_64"
  }
}

///|
/// 从字符串解析架构 | Parse architecture from string
pub fn Arch::from_id(s : String) -> Arch? {
  match s {
    "arm64" => Some(Arm64)
    "x86_64" => Some(X86_64)
    _ => None
  }
}

///|
/// 平台默认架构 | Default architecture for platform
pub fn Platform::default_arch(self : Platform) -> Arch {
  match self {
    Ios => Arm64
    Android => Arm64
    Windows => X86_64
    Ohos => Arm64
  }
}

///|
/// 构建目标三元组 | Build target triple
pub fn make_target_triple(platform : Platform, arch : Arch) -> TargetTriple {
  let triple = match (platform, arch) {
    (Ios, Arm64) => "arm64-apple-ios"
    (Ios, X86_64) => "x86_64-apple-ios-simulator"
    (Android, Arm64) => "aarch64-linux-android24"
    (Android, X86_64) => "x86_64-linux-android24"
    (Windows, X86_64) => "x86_64-pc-windows-msvc"
    (Windows, Arm64) => "aarch64-pc-windows-msvc"
    (Ohos, Arm64) => "aarch64-linux-ohos"
    (Ohos, X86_64) => "x86_64-linux-ohos"
  }
  { platform, arch, triple, }
}

///|
/// 目标三元组字符串 | Target triple to string
pub fn TargetTriple::to_string(self : TargetTriple) -> String {
  self.triple
}
