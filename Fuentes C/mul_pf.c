#include "xparameters.h"
#include "xil_io.h"
#include "mult_pf.h"
#include "xuartps.h"

//====================================================


#define UART_DEVICE_ID 		XPAR_XUARTPS_0_DEVICE_ID
#define RECV_BUFFER_SIZE	1


int res1;
int opA1=0x40200000;
int opB1=0xc1280000;

int res2;
int opA2=0x40300000;
int opB2=0xc1270000;

int res3;
int opA3=0x40100000;
int opB3=0xc1260000;


XUartPs uart_ps;
XUartPs_Config *config;

static u8 RecvBuffer;

int main (void) {

	u8 data_rec;
	char data;

	//configuracion uart======================================================
	config=XUartPs_LookupConfig(UART_DEVICE_ID);
	if(NULL==config)
		return XST_FAILURE;

	int status = XUartPs_CfgInitialize(&uart_ps,config,config->BaseAddress);
	if (status!= XST_SUCCESS)
		return XST_FAILURE;

	XUartPs_SetBaudRate(&uart_ps,115200);
	//========================================================================

	xil_printf("Bienvenidos!\r\n\n");
	while(1) {
		data_rec=XUartPs_Recv(&uart_ps,&RecvBuffer,RECV_BUFFER_SIZE);
		if(data_rec!=0) {
			data=RecvBuffer;

			xil_printf("Operacion: %i \r\n",RecvBuffer);

			switch(data) {
			case 49: // data es igual a #1
				xil_printf(" - Primera multiplicacion: \r\n");

				MULT_PF_mWriteReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG0_OFFSET, opA1);
				MULT_PF_mWriteReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG1_OFFSET, opB1);
				res1 = MULT_PF_mReadReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG2_OFFSET);

				xil_printf("  * Multiplicacion: %x x %x = %x\r\n\n", opA1, opB1, res1);
				break;

			case 50: // data es igual a #2
				xil_printf(" - Segunda multiplicacion: \r\n");

				MULT_PF_mWriteReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG0_OFFSET, opA2);
				MULT_PF_mWriteReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG1_OFFSET, opB2);
				res2 = MULT_PF_mReadReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG2_OFFSET);

				xil_printf("  * Multiplicacion: %x x %x = %x\r\n\n", opA2, opB2, res2);
				break;

			case 51: // data es igual a #3
				xil_printf(" - Tercera multiplicacion: \r\n");

				MULT_PF_mWriteReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG0_OFFSET, opA3);
				MULT_PF_mWriteReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG1_OFFSET, opB3);
				res3 = MULT_PF_mReadReg(XPAR_MULT_PF_0_S_AXI_BASEADDR, MULT_PF_S_AXI_SLV_REG2_OFFSET);

				xil_printf("  * Multiplicacion: %x x %x = %x\r\n\n", opA3, opB3, res3);
				break;

			default:
				xil_printf("Seleccione una operacion correcta! \r\n\n");
				break;
			}
		}
	}
}


