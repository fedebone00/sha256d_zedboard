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
#include "platform.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "sha256d_axi_ip.h"

int meetsTarget(const char* result, const char* target){
	unsigned dataByte, targetByte;
    char dataByteStr[3];
    char targetByteStr[3];
    dataByteStr[2] = 0;
    targetByteStr[2] = 0;

	for(int i=strlen(result)/2 - 1; i>=0; --i){
		strncpy(dataByteStr, result+(i*2), 2);
		dataByte = (unsigned)strtoul(dataByteStr, NULL, 16);

		strncpy(targetByteStr, target+(i*2), 2);
		targetByte = (unsigned)strtoul(targetByteStr, NULL, 16);

		if((dataByte & 0xff) > (targetByte & 0xff))
			return 0;
		if((dataByte & 0xff) < (targetByte & 0xff))
			return 1;
	}
}

int main()
{
	int i;
    u32 result;
    char stringResult[65];
    char input[9];
    char control;
    char cmd[50];

    char data[153];
    char target[65];

    input[8] = 0;
    data[152] = 0;
    target[64] = 0;

	init_platform();

    while(1){
    	fflush(stdin);

    	control = getc(stdin);
    	if(control != '\r' && control != '\n'){
    		ungetc(control, stdin);
    	}


    	fgets(data, 153, stdin);
    	fgets(target, 65, stdin);

    	//write first 18 registers (always the same for a given data)
		for(i=0; i<19; ++i){
			strncpy(input, data+(i*8), 8);
			result = strtoul(input, NULL, 16);
			SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, i*4, result);
		}

    	for(u32 nonce=0; nonce<ULONG_MAX; ++nonce){

    		//check if new blocks are found
    		ungetc('0', stdin);
    		fgets(cmd, strlen(cmd), stdin);
    		if(strstr(cmd, "<nb>")!=NULL){
    			//new block found
    			break;
    		}

    		//write last register (19) that contains the nonce
    		snprintf(input, 9, "%08lx", __builtin_bswap32(nonce));
    		i=19;
			result = strtoul(input, NULL, 16);
			SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, i*4, result);

			//write 0x1 in the last register (20) to start the computation
			SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG20_OFFSET, (u32)1);

			//wait for the result
			while(1){
				result = SHA256D_AXI_IP_mReadReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG20_OFFSET);
				//printf("%lu == %lu\n", result, (u32)1);
				if(result==(u32)1){
					break;
				}
			}

			//while(1);

			for(i=7; i>=0; --i){
				result = SHA256D_AXI_IP_mReadReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, i*4);
				snprintf(stringResult+(8*(7-i)), 9, "%08lx", result);
			}

			//write 0x0 in the last register (20)
			SHA256D_AXI_IP_mWriteReg(XPAR_SHA256D_AXI_IP_0_S00_AXI_BASEADDR, SHA256D_AXI_IP_S00_AXI_SLV_REG20_OFFSET, (u32)0);

			stringResult[64] = 0;

			if(meetsTarget(stringResult, target))
			{
				printf("<nonce>%08lx</nonce>\n", nonce);
				break;
			}

    	}
    }


    cleanup_platform();
    return 0;
}
