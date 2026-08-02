# 卡住时运行此脚本（右键 → 用 PowerShell 运行）
# 会生成 thread_stack.txt，把内容发给我
$worldserver = Get-Process -Name worldserver -ErrorAction SilentlyContinue
if (-not $worldserver) { Write-Host "worldserver 未运行"; exit }

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class NT {
  [DllImport("kernel32.dll")] public static extern IntPtr OpenThread(uint access, bool inherit, uint tid);
  [DllImport("kernel32.dll")] public static extern bool GetThreadContext(IntPtr h, IntPtr ctx);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
}
'@

$out = @()
$out += "worldserver PID: $($worldserver.Id)"
$out += "CPU: $($worldserver.CPU)s"
$out += ""

foreach ($t in $worldserver.Threads) {
  $h = [NT]::OpenThread(0xFFFF, $false, $t.Id)
  if ($h -eq [IntPtr]::Zero) { continue }
  $buf = [Runtime.InteropServices.Marshal]::AllocHGlobal(0x4D0)
  [Runtime.InteropServices.Marshal]::WriteInt32($buf, 0x20, 0x10001F)
  $ok = [NT]::GetThreadContext($h, $buf)
  if ($ok) {
    $rip = [Runtime.InteropServices.Marshal]::ReadInt64($buf, 0xE8)
    $rsp = [Runtime.InteropServices.Marshal]::ReadInt64($buf, 0x88)
    $out += "T$($t.Id) RIP=0x$($rip.ToString('X16')) RSP=0x$($rsp.ToString('X'))"
  }
  [Runtime.InteropServices.Marshal]::FreeHGlobal($buf)
  [NT]::CloseHandle($h) | Out-Null
}

$out | Out-File -FilePath "$env:TEMP\thread_stack.txt" -Encoding UTF8
Write-Host "已生成 C:\Users\$(whoami)\AppData\Local\Temp\thread_stack.txt，请把内容发给我"