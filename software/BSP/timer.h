/*!
 * \file       timer.h
 * \details    Functions for communicating with Timer hardware component.
 * \author     Jens Lind
 * \version    1.0
 * \date       2017-2021
 * \copyright  AGSTU AB
 */

#ifndef _TIMER_H_
#define _TIMER_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*! \brief Starts the timer.
 */
void timer_start();

/*! \brief Stops the timer.
 */
void timer_stop();

/*! \brief Resets current time value and stops the timer.
 */
void timer_reset();

/*! \brief Reads the current time value from the timer. The time value is updated every system clock
           tick. The system clock frequency is hardware dependent, but the example(s) provided with
		   this IP component assume 50 MHz.
    \return Time value as number of ticks (32-bit resolution).
 */
uint32_t timer_read();

#ifdef __cplusplus
}
#endif

#endif
