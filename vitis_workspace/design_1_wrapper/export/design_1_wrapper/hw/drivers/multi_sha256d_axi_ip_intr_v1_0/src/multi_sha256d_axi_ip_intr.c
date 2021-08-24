

/***************************** Include Files *******************************/
#include "multi_sha256d_axi_ip_intr.h"

/************************** Function Definitions ***************************/

void MULTI_SHA256D_AXI_IP_INTR_EnableInterrupt(void * baseaddr_p)
{
  u32 baseaddr;
  baseaddr = (u32) baseaddr_p;
  /*
   * Enable all interrupt source from user logic.
   */
  MULTI_SHA256D_AXI_IP_INTR_mWriteReg(baseaddr, 0x4, 0x1);
  /*
   * Set global interrupt enable.
   */
  MULTI_SHA256D_AXI_IP_INTR_mWriteReg(baseaddr, 0x0, 0x1);
}
 
 
void MULTI_SHA256D_AXI_IP_INTR_ACK(void * baseaddr_p)
{
  u32 baseaddr;
  baseaddr = (u32) baseaddr_p;
 
  /*
  * ACK interrupts on MULTI_SHA256D_AXI_IP_INTR.
  */
  MULTI_SHA256D_AXI_IP_INTR_mWriteReg(baseaddr, 0xc, 0x1); 
}