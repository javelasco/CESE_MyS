#include "xparameters.h"
#include "xil_io.h"
#include "mul_pf_ip.h"
#include "xuartps.h"

//====================================================


#define UART_DEVICE_ID 		XPAR_XUARTPS_0_DEVICE_ID
#define RECV_BUFFER_SIZE	1


int res1 = 0;
int opA1 = 0;
int opB1 = 0;
//int opA1=0x40200000;
//int opB1=0xc1280000;

int res2;
int opA2=0xA0200000;
int opB2=0xc3280000;

int res3;
int opA3=0x2A200000;
int opB3=0xcE280000;


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

	xil_printf("Bienvenidos!\r\n");
	while(1)
	{
		data_rec=XUartPs_Recv(&uart_ps,&RecvBuffer,RECV_BUFFER_SIZE);
		if(data_rec!=0)
		{
			data=RecvBuffer;

			xil_printf("Operacion: %i \r\n",RecvBuffer);

		}

		switch(data){
		case 49: // data es igual a #1
			xil_printf("Primera multiplicacion: \r\n");

			//MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET, opA1);
			//MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET, opB1);
			opA1 = MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET);
			opB1 = MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET);
			res1 = MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG2_OFFSET);

			xil_printf(" --Multiplicacion: %x * %x = %x\r\n", opA1, opB1, res1);
			break;

		case 50: // data es igual a #2
			xil_printf("Segunda multiplicacion: \r\n");

			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET, opA2);
			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET, opB2);
			res2 = MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG2_OFFSET);

			xil_printf(" --Multiplicacion: %x * %x = %x\r\n", opA2, opB2, res2);
			break;

		case 51: // data es igual a #3
			xil_printf("Tercera multiplicacion: \r\n");

			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET, opA3);
			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET, opB3);
			res3 = MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG2_OFFSET);

			xil_printf(" --Multiplicacion: %x * %x = %x\r\n", opA3, opB3, res3);
			break;

		default:
			//xil_printf("seleccione operacion. \r\n");
			break;
		}
	}
}


