# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\Uni\RL\sha256d_zedboard\vitis_workspace\design_1_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\Uni\RL\sha256d_zedboard\vitis_workspace\design_1_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_1_wrapper}\
-hw {D:\Uni\RL\sha256d_zedboard\design_1_wrapper.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {D:/Uni/RL/sha256d_zedboard/vitis_workspace}

platform write
platform generate -domains 
platform generate
bsp reload
domain active {zynq_fsbl}
bsp reload
platform generate -domains standalone_domain 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform active {design_1_wrapper}
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform generate -domains 
platform active {design_1_wrapper}
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform active {design_1_wrapper}
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform active {design_1_wrapper}
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
platform config -updatehw {D:/Uni/RL/sha256d_zedboard/design_1_wrapper.xsa}
platform generate -domains 
