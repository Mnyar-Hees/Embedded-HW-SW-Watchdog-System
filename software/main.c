#include <stdio.h>
#include <io.h>
#include <system.h>
#include <altera_avalon_timer_regs.h>

/*
------------------------------------------------------------------------
  Global Variables
------------------------------------------------------------------------
*/

/* Counts how many times the watchdog has been restarted */
volatile int rst_cnt = 0;

/* Software timer counter (used for simulating time) */
volatile int timer_cnt = 0;

/*
------------------------------------------------------------------------
  7-Segment Display Encoding
  Each entry contains the segment pattern for digits 0–9.
  A '0' bit lights up a segment (active-low 7-segment display).
------------------------------------------------------------------------
*/
const int seven_seg[10] = {
    0b11000000, // 0
    0b11111001, // 1
    0b10100100, // 2
    0b10110000, // 3
    0b10011001, // 4
    0b10010010, // 5
    0b10000010, // 6
    0b11111000, // 7
    0b10000000, // 8
    0b10011000  // 9
};

/*
------------------------------------------------------------------------
  main()
  - Initializes LEDs and 7-seg display
  - Starts hardware timer
  - Periodically restarts the Watchdog Timer (WDT)
  - If the button is pressed, program intentionally "hangs"
------------------------------------------------------------------------
*/
int main()
{
    printf("Starting System \n");

    /* Turn off all LEDs */
    IOWR_32DIRECT(LEDR_BASE, 0, 0x0);

    /* Display 0 on the 7-segment display */
    IOWR_32DIRECT(SEVEN_SEG_BASE, 0, seven_seg[0]);

    /* Reset and start the hardware timer */
    TIMER_RESET();
    TIMER_START();

    while(1)
    {
        /*
        ------------------------------------------------------------
          Software timing:
          When timer_cnt reaches 500000, 1 second has passed
        ------------------------------------------------------------
        */
        if(timer_cnt >= 500000)
        {
            timer_cnt = 0;
            TIMER_RESET();
            TIMER_START();

            /*
            --------------------------------------------------------
              Restart Watchdog Timer
              The restart signal is a momentary 1 → 0 pulse
            --------------------------------------------------------
            */
            IOWR_32DIRECT(WDT_RESTART_BASE, 0, 1);
            IOWR_32DIRECT(WDT_RESTART_BASE, 0, 0);

            /* Update counter (0–9 loop) shown on 7-seg display */
            if (rst_cnt >= 9)
                rst_cnt = 0;
            else
                rst_cnt++;

            IOWR_32DIRECT(SEVEN_SEG_BASE, 0, seven_seg[rst_cnt]);
        }

        /* Increase timer counter every loop iteration */
        timer_cnt++;

        /*
        ------------------------------------------------------------
          Button Check:
          If button is pressed (active-low), simulate a system hang:
            - Turn all LEDs ON
            - Print message
            - Stay in infinite loop (WDT must reset system)
        ------------------------------------------------------------
        */
        if (!(IORD_32DIRECT(BUTTON_BASE, 0) & 0x1))
        {
            /* Turn on all LEDs */
            IOWR_32DIRECT(LEDR_BASE, 0, 0xFF);

            printf("LOOOOOOOOCK\n");

            /* Simulate a system freeze — WDT should take over */
            while(1);
        }
    }

    return 0;
}
