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
#include "platform.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "sha256d_axi_ip.h"


int main()
{
	int i;
    u32 result;
    char stringResult[256];

    init_platform();

    print("starting sha256d test\n");
    print("writing 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' in registers\n");

    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG0_OFFSET, (u32)0x61626364);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG1_OFFSET, (u32)0x62636465);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG2_OFFSET, (u32)0x63646566);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG3_OFFSET, (u32)0x64656667);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG4_OFFSET, (u32)0x65666768);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG5_OFFSET, (u32)0x66676869);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG6_OFFSET, (u32)0x6768696a);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG7_OFFSET, (u32)0x68696A6b);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG8_OFFSET, (u32)0x696A6B6c);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG9_OFFSET, (u32)0x6a6b6c6d);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG10_OFFSET, (u32)0x6b6c6d6e);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG11_OFFSET, (u32)0x6c6d6e6f);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG12_OFFSET, (u32)0x6d6e6f70);
    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG13_OFFSET, (u32)0x6e6f7071);

    print("written\n");

    print("***************\n");


    print("writing 0x1 in the last register (starts computation)\n");

    SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG16_OFFSET, (u32)1);

    print("written\n");

    print("***************\n");

    print("hopefully read result\n");



    while(1){
    	result = SHA256D_AXI_IP_mReadReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG16_OFFSET);
    	//printf("%lu == %lu\n", r, (u32)1);
    	if(result==(u32)1){
    		break;
    	}
    }


    for(i=7; i>=0; --i){
    	result = SHA256D_AXI_IP_mReadReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, i*4);
    	snprintf(stringResult+(8*(7-i)), 9, "%08lx", result);
    }

    stringResult[64] = 0;

	print("read\n");

	printf("result: %s\n", stringResult);

	print("***************\n");


    cleanup_platform();
    return 0;
}
