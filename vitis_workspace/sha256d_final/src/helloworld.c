/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <unistd.h>
#include "platform.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "multi_sha256d_axi_ip_intr.h"
#include "xscugic.h"

#define MULTI_SHA256D_AXI_IP_INTR_0_BASEADDR (void*)0x43C10000

#define CMD_LEN 6
#define DATA_LEN 153
#define HASH_LEN 65
#define DATA_CMD "<DTA>"
#define TARGET_CMD "<TRG>"
#define NEW_BLOCK_CMD "<NBF>"
#define NONCE_CMD "<NNC>"
#define LOG_CMD "<LOG>"
#define ACK_CMD "<ACK>"

#define MULTI_SHA256D_RESET 0x0
#define MULTI_SHA256D_START 0x1

void Irq_Handler(void *InstancePtr);

int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr);

int interrupt_init();

void MULTI_SHA256D_writeDataTargetAndStart(const char* data, const char* target);

void MULTI_SHA256D_writeCmd(int cmd);

XScuGic InterruptController;
static XScuGic_Config *GicConfig;

int main(){
	char cmd[CMD_LEN], data[DATA_LEN], target[HASH_LEN];

	init_platform();
	interrupt_init();

	cmd[CMD_LEN-1]=0;
	data[DATA_LEN-1]=0;
	target[HASH_LEN-1]=0;

	while(1){
		fgets(cmd, 6, stdin);

		if(strstr(cmd, DATA_CMD)){
			fgets(data, DATA_LEN, stdin);
		}
		else if(strstr(cmd, TARGET_CMD)){
			fgets(target, HASH_LEN, stdin);
			//uncomment these 2 lines and the returned nonce should be 0x00000005
			//sprintf(data, "2000000426adff961c11c83d7dc1238992172e8994572c710000cedf00000000000000003afb1227e9aa9713ae1fcf532fe3a4aa777fffef7e6a3e28ed7bc11ab14e0bb26128e108170ffaa0");
			//sprintf(target, "000000000000000000000000000000000000000000000000000000000000000f");
			MULTI_SHA256D_writeDataTargetAndStart(data, target);
			xil_printf(LOG_CMD); xil_printf("started mining\n");
		}
		else if(strstr(cmd, NEW_BLOCK_CMD)){
			MULTI_SHA256D_writeCmd(MULTI_SHA256D_RESET);
			xil_printf(ACK_CMD); xil_printf("\n");
		}
		//removes \n from stdin
		getchar();
	}
	cleanup_platform();
	return 0;
}
void Irq_Handler(void *InstancePtr)
{
	char output[20];
	MULTI_SHA256D_writeCmd(MULTI_SHA256D_RESET);

	u32 nonce = MULTI_SHA256D_AXI_IP_INTR_mReadReg(XPAR_MULTI_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, MULTI_SHA256D_AXI_IP_INTR_S00_AXI_SLV_REG0_OFFSET);
	snprintf(output, 20, "%s%08lx\n", NONCE_CMD, nonce);

	xil_printf(output);
	MULTI_SHA256D_AXI_IP_INTR_ACK(MULTI_SHA256D_AXI_IP_INTR_0_BASEADDR);
}

int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr)
{
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XScuGic_InterruptHandler, XScuGicInstancePtr);
	Xil_ExceptionEnable();
	return XST_SUCCESS;
}

int interrupt_init()
{
	int Status;

	GicConfig = XScuGic_LookupConfig(XPAR_PS7_SCUGIC_0_DEVICE_ID);
	if (NULL == GicConfig) {
		return XST_FAILURE;
	}
	Status = XScuGic_CfgInitialize(&InterruptController, GicConfig, GicConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = SetUpInterruptSystem(&InterruptController);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XScuGic_Connect(&InterruptController, XPAR_FABRIC_MULTI_SHA256D_AXI_IP_0_IRQ_INTR, (Xil_ExceptionHandler)Irq_Handler, (void *)NULL);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_Enable(&InterruptController, XPAR_FABRIC_MULTI_SHA256D_AXI_IP_0_IRQ_INTR);

	MULTI_SHA256D_AXI_IP_INTR_EnableInterrupt(MULTI_SHA256D_AXI_IP_INTR_0_BASEADDR);

	return XST_SUCCESS;
}

void MULTI_SHA256D_writeDataTargetAndStart(const char* data, const char* target){
	char input[9];
	input[8] = 0;
	register int i;
	register u32 result;
	for(i=0; i<19; ++i){
		strncpy(input, data+(i*8), 8);
		result = strtoul(input, NULL, 16);
		MULTI_SHA256D_AXI_IP_INTR_mWriteReg(XPAR_MULTI_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, i*4, result);
	}

	for(i=0; i<8; ++i){
		strncpy(input, target+(i*8), 8);
		result = strtoul(input, NULL, 16);
		MULTI_SHA256D_AXI_IP_INTR_mWriteReg(XPAR_MULTI_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, MULTI_SHA256D_AXI_IP_INTR_S00_AXI_SLV_REG19_OFFSET + i*4, result);
	}

	MULTI_SHA256D_writeCmd(MULTI_SHA256D_START);
}

void MULTI_SHA256D_writeCmd(int cmd){
	MULTI_SHA256D_AXI_IP_INTR_mWriteReg(XPAR_MULTI_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, MULTI_SHA256D_AXI_IP_INTR_S00_AXI_SLV_REG27_OFFSET, cmd);
}

