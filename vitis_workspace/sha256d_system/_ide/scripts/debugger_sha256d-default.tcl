# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: D:\Uni\RL\sha256d_zedboard\vitis_workspace\sha256d_system\_ide\scripts\debugger_sha256d-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source D:\Uni\RL\sha256d_zedboard\vitis_workspace\sha256d_system\_ide\scripts\debugger_sha256d-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248684685" && level==0 && jtag_device_ctx=="jsn-Zed-210248684685-23727093-0"}
fpga -file D:/Uni/RL/sha256d_zedboard/vitis_workspace/sha256d/_ide/bitstream/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw D:/Uni/RL/sha256d_zedboard/vitis_workspace/design_1_wrapper/export/design_1_wrapper/hw/design_1_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source D:/Uni/RL/sha256d_zedboard/vitis_workspace/sha256d/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow D:/Uni/RL/sha256d_zedboard/vitis_workspace/sha256d/Debug/sha256d.elf
configparams force-mem-access 0
bpadd -addr &main
