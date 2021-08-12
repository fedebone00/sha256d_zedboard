# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: D:\Uni\RL\sha256d_zedboard\vitis_workspace\sha256d_system\_ide\scripts\systemdebugger_sha256d_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source D:\Uni\RL\sha256d_zedboard\vitis_workspace\sha256d_system\_ide\scripts\systemdebugger_sha256d_system_standalone.tcl
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
targets -set -nocase -filter {name =~ "*A9*#0"}
rst -processor
dow D:/Uni/RL/sha256d_zedboard/vitis_workspace/design_1_wrapper/export/design_1_wrapper/sw/design_1_wrapper/boot/fsbl.elf
set bp_53_53_fsbl_bp [bpadd -addr &XFsbl_Exit]
con -block -timeout 60
bpremove $bp_53_53_fsbl_bp
targets -set -nocase -filter {name =~ "*A9*#0"}
dow D:/Uni/RL/sha256d_zedboard/vitis_workspace/sha256d/Debug/sha256d.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
