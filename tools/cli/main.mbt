///|
/// Moon Cross CLI 入口 — 接收真实命令行参数 | Moon Cross CLI entry — accepts real command line arguments

///|
/// 程序主入口：解析 argv 并分发命令 | Program main entry: parse argv and dispatch commands
async fn main {
  let args = @env.args()
  let real_args : Array[String] = []
  for i in 1..<args.length() {
    real_args.push(args[i])
  }
  let output = run_cli(real_args) catch {
    e => {
      println(@core.MoonCrossError::to_message(e))
      @env.exit(1)
    }
  }
  println(output)
  // 显式退出以结束 async 事件循环 | exit explicitly to shut down the async event loop
  @env.exit(0)
}
