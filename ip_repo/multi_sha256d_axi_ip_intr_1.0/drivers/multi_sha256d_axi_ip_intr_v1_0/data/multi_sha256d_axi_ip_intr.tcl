

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "multi_sha256d_axi_ip_intr" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_AXI_BASEADDR" "C_S00_AXI_HIGHADDR"
}
