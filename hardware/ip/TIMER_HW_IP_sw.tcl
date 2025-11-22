create_driver timer_driver
set_sw_property hw_class_name TIMER_HW_IP
set_sw_property version 1
set_sw_property min_compatible_hw_version 1.0
add_sw_property bsp_subdirectory drivers
add_sw_property c_source HAL/src/timer.c
add_sw_property include_source HAL/inc/altera_avalon_timer_regs.h
add_sw_property include_source HAL/inc/timer.h
add_sw_property supported_bsp_type HAL