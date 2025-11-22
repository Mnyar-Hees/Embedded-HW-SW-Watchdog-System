/**
 * \file       timer.c
 * \details    Functions for communicating with Timer hardware component.
 * \author     Jens Lind
 * \version    1.0
 * \date       2017-2021
 * \copyright  AGSTU AB
 */
 
#include <io.h>
#include <system.h>

#include "timer.h"

void timer_start()
{
	IOWR_32DIRECT(TIMER_HW_IP_0_BASE, 4, 0x80000000);
}

void timer_stop()
{
	IOWR_32DIRECT(TIMER_HW_IP_0_BASE, 4, 0x00000000);
}

void timer_reset()
{
	IOWR_32DIRECT(TIMER_HW_IP_0_BASE, 4, 0x40000000);
}

uint32_t timer_read()
{
	return IORD_32DIRECT(TIMER_HW_IP_0_BASE, 0);
}
