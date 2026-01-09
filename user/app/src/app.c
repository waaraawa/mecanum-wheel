#include "app.h"
#include "main.h"
#include "cmsis_os.h"

// LED toggle task
void App_LED_Toggle_Task(void* argument) {
	for (;;) {
		HAL_GPIO_TogglePin(LD3_GPIO_Port, LD3_Pin);
		osDelay(200);
	}
}