/*
   This file is part of the W1209 firmware replacement project
   (https://github.com/mister-grumbler/w1209-firmware).

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, version 3.

   This program is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

/*
   - Modified by RTEK1000
   - Mar/27/2023
   - Code adaptation for Arduino IDE sketch.ino
   - Some bug fixes
   - Some functions added
   - Note: Track the size of the code when uploading,
     The maximum I got was 93%
     --> (Sketch uses 7589 bytes (92%))
     --> (Bytes written: 8136)
     --> (Maximum is 8192 bytes)

   References:
   - https://github.com/rtek1000/NTC_Lookup_Table_Generator
   - https://github.com/rtek1000/W1209-firmware-modified
*/

/**
   Control functions for relay.
*/

#include "relay.h"
#include "stm8s003/gpio.h"
#include "adc.h"
#include "params.h"

#define RELAY_PORT              PA_ODR
#define RELAY_BIT               0x08
#define RELAY_TIMER_MULTIPLIER  240 // inc (@250ms): (x4)s (x60)min: 4x60=240 (@1min)

static unsigned int timer = 0;
static bool state_pin = false;
static bool state_waiting = false;
static bool state_toggle = false;
static bool incTimerEn;

bool getRelayState(bool _blink)
{
  return state_pin || (_blink && state_waiting);
}

void incRelayTimer()
{
  timer += incTimerEn;
}

/**
   @brief Configure appropriate bits for GPIO port A, reset local timer
    and reset state.
*/
void initRelay()
{
  PA_DDR |= RELAY_BIT;
  PA_CR1 |= RELAY_BIT;
}

/**
   @brief Sets state of the relay.
   @param on - true, off - false
*/
void setRelay (bool _on)
{
  state_pin = _on;

  if (_on) {
    RELAY_PORT |= RELAY_BIT;
  } else {
    RELAY_PORT &= ~RELAY_BIT;
  }

}

/**
   @brief This function is being called during timer's interrupt
    request so keep it extremely small and fast.
*/
void refreshRelay()
{
  bool mode;
  bool alarm_mode;

  unsigned char sensor_fail = getSensorFail();

  int _temperature = getTemperature();

  int _MIN_TEMPERATURE = getParamById (PARAM_MIN_TEMPERATURE) * 10;
  int _MAX_TEMPERATURE = getParamById (PARAM_MAX_TEMPERATURE) * 10;

  unsigned char _RELAY_MODE = getParamById (PARAM_RELAY_MODE);
  int _THRESHOLD = getParamById (PARAM_THRESHOLD);
  int _RELAY_HYSTERESIS = getParamById (PARAM_RELAY_HYSTERESIS);

  unsigned int _RELAY_DELAY = getParamById (PARAM_RELAY_DELAY) * RELAY_TIMER_MULTIPLIER;

  bool _HYSTERESIS_UP;
  bool _HYSTERESIS_DOWN;
  bool _HYSTERESIS_DUAL;

  if (_RELAY_MODE == RELAY_MODE_A1) {
    alarm_mode = true;
    mode = true;
  } else if (_RELAY_MODE == RELAY_MODE_A2) {
    alarm_mode = true;
    mode = false;
  } else {
    alarm_mode = false;

    if ((_RELAY_MODE >= RELAY_MODE_C1) && (_RELAY_MODE <= RELAY_MODE_C3)) {
      mode = false;
      _HYSTERESIS_DUAL = (_RELAY_MODE >> 1) & 1;                          // 0B10
      _HYSTERESIS_UP = (!(_RELAY_MODE & 1)) && (!_HYSTERESIS_DUAL);       // 0B00
      _HYSTERESIS_DOWN = (_RELAY_MODE & 1) && (!_HYSTERESIS_DUAL);        // 0B01

    } else if ((_RELAY_MODE >= RELAY_MODE_H1) && (_RELAY_MODE <= RELAY_MODE_H3)) {
      mode = true;
      unsigned char _RELAY_MODE_tmp = _RELAY_MODE - RELAY_MODE_H1;
      _HYSTERESIS_DUAL = (_RELAY_MODE_tmp >> 1) & 1;                      // 0B10
      _HYSTERESIS_DOWN = (!(_RELAY_MODE_tmp & 1)) && (!_HYSTERESIS_DUAL); // 0B00
      _HYSTERESIS_UP = (_RELAY_MODE_tmp & 1) && (!_HYSTERESIS_DOWN);      // 0B01
    }
  }

  if (sensor_fail == sensor_ok) {
    if (alarm_mode == true) {
      if ((_temperature > _MIN_TEMPERATURE) &&
          (_temperature < _MAX_TEMPERATURE) ) {
        setRelay (!mode);
      }

      if ((_temperature < _MIN_TEMPERATURE) ||
          (_temperature > _MAX_TEMPERATURE) ) {
        setRelay (mode);
      }
    } else { // alarm_mode == false
      if (state_toggle == true) { // Relay state is enabled
        if ((((_HYSTERESIS_DOWN == true) || (_HYSTERESIS_DUAL == true)) &&
             (_temperature < (_THRESHOLD - _RELAY_HYSTERESIS))) ||
            ((_HYSTERESIS_UP == true) && (_temperature < _THRESHOLD))) {
          incTimerEn = true; // timer++;

          if ((_RELAY_DELAY < timer) || (!mode)) {
            state_toggle = false;
            setRelay (mode);
            state_waiting = false;
          } else {
            state_waiting = true;
            setRelay (!mode);
          }
        } else {
          timer = 0;
          setRelay (!mode);
        }

      } else { // Relay state is disabled
        if (((_HYSTERESIS_DOWN == true) && (_temperature > _THRESHOLD)) ||
            (((_HYSTERESIS_UP == true) || (_HYSTERESIS_DUAL == true)) &&
             (_temperature > (_THRESHOLD + _RELAY_HYSTERESIS)))) {
          incTimerEn = true; // timer++;

          if ((_RELAY_DELAY < timer) || (mode)) {
            state_toggle = true;
            setRelay (!mode);
            state_waiting = false;
          } else {
            state_waiting = true;
            setRelay (mode);
          }
        } else {
          timer = 0;
          setRelay (mode);
        }
      }
    }
  } else { // (sensor_fail != sensor_ok) {

    setRelay ((bool) ( _RELAY_MODE == RELAY_MODE_A1));

  }
}
