#include "xparameters.h"
#include "xil_io.h"
#include "mul_pf_ip.h"
#include "xuartps.h"

//====================================================


#define UART_DEVICE_ID 		XPAR_XUARTPS_0_DEVICE_ID
#define RECV_BUFFER_SIZE	1


float res1;
float opA1=1.1 ;
float opB1=1.5 ;

float res2;
float opA2=2.2 ;
float opB2=3.1 ;

float res3;
float opA3=1.3 ;
float opB3=1.7 ;


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

	while(1)
	{
		data_rec=XUartPs_Recv(&uart_ps,&RecvBuffer,RECV_BUFFER_SIZE);
		if(data_rec!=0)
		{
			data=RecvBuffer;

			xil_printf("operacion %i:",RecvBuffer);

		}


		switch(data){
		case 49:
				xil_printf("primera multiplcacion: \r\n");

			 	MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET, opA1);
			 	MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET, opB1);
			 	res1 = (float)MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG2_OFFSET);

			 	 xil_printf("multiplicacion: %f * %f = %f\r\n", opA1, opB1, res1);

			break;
		case 50:
			xil_printf("segunda multiplcacion: \r\n");

			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET, opA2);
			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET, opB2);
			res2 = (float) MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG2_OFFSET);

			 xil_printf("multiplicacion: %f * %f = %f\r\n", opA2, opB2, res2);

			break;

		case 51:
			xil_printf("tercera multiplcacion: \r\n");

			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG0_OFFSET, opA3);
			MUL_PF_IP_mWriteReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG1_OFFSET, opB3);
			res3 = (float)MUL_PF_IP_mReadReg(XPAR_MUL_PF_IP_S_AXI_BASEADDR, MUL_PF_IP_S_AXI_SLV_REG2_OFFSET);

			xil_printf("multiplicacion: %d * %d = %d\r\n", opA3, opB3, res3);

			break;

		default:
			xil_printf("seleccione operacion");
			break;
		}
	}
}


