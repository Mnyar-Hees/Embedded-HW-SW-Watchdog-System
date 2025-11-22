/*!
 * \file       altera_avalon_timer_regs.h
 * \details    Drivers for interfacing with Timer component on the DE10-Lite board.
 *             Functionality is implemented as macros which wrap non-altera specific implementation.
 * \author     Unknown
 * \author     Jens Lind
 * \version    2.0
 * \date       2017-2021
 * \copyright  AGSTU AB
 */

#ifndef _ALTERA_AVALON_TIMER_REGS_H_
#define _ALTERA_AVALON_TIMER_REGS_H_

#include "timer.h"

#define TIMER_STOP() timer_stop()
#define TIMER_RESET() timer_reset()
#define TIMER_START() timer_start()
#define TIMER_READ() timer_read()

#endif
