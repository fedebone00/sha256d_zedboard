The main project contains the block design, in which the processing system is connected to our ip "multi_sha256d_axi_intr_ip" through an axi interface.
Our custom axi slave receive the block data and the target, handles nonce generation and hashing phase and alerts the PS using an interrupt, when a hash meets the target.
The vitis_workspace folder contains both the platform projects (3_inst is not working) and the application project.

Make sure to always shut down the LCD screen by pressing the BTNC button.
