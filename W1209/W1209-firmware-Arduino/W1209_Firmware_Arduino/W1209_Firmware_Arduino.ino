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
     --> Parameter P0: C1/C2/C3/H1/H2/H3/A1/A2
         - C1: Cooler mode (hysteresis above Threshold)
         - C2: Cooler mode (hysteresis below Threshold)
         - C3: Cooler mode (hysteresis above and below Threshold)
         - H1: Cooler mode (hysteresis below Threshold)
         - H2: Cooler mode (hysteresis above Threshold)
         - H3: Cooler mode (hysteresis above and below Threshold)
     --> Parameter P1: Hysteresis
     --> Parameter P2: Up limit
         (Used in the alert indication; Activated in Parameter P6)
         (Used in Alarm mode Parameter P0: A1 and A2; Activated in Parameter P6)
     --> Parameter P3: Down limit
         (Used in the alert indication; Activated in P6)
         (Used in Alarm mode Parameter P0: A1 and A2; Activated in Parameter P6)
     --> Parameter P4: Temperature sensor offset
         (From -7.0 up to +7.0)
     --> Parameter P5: Delay time before activating the relay
         (From 0 to 10 minutes)
         (Does not affect relay deactivation, deactivation is immediate)
     --> Parameter P6: ON/OFF
         (Alarm mode; Need setup Parameter P2 and P3)
     --> Parameter P7: ON/OFF
         (Threshold value change access blocking)
         (Factory reset lockout with Up "+" and Down "-" keys)
     --> Parameter P8: ON/OFF
         (Automatic brightness reduction after 15 seconds)
     --> Output status indication:
         - Decimal point (DOT) right side off:
           Relay deactivated (contacts open)
         - Decimal point (DOT) right side blinking:
           Relay deactivated (contacts open), but
           Waiting delay time programmed in Parameter P5
     --> Factory reset:
         - Set Parameter P7 in OFF
         - Turn power supply Off
         - Press and hold Up "+" and Down "-" keys
         - Turn power supply On
         - Wait for "rSt" to appear on the display
         - Release all keys
         - Wait for the current temperature to appear
     --> Troubleshoot:
         - Microcontroller resetting:
           Try using a pull up resistor on the reset line
         - Microcontroller no longer responds:
           High voltage return may have occurred through the relay LED
         - The temperature does not correspond to the real:
           Try adjusting the offset Parameter P5
           Try to replace the sensor
           Test using a resistor of NTC equivalent value for 25°C (10k)
           Try modifying the lookup table corresponding to the sensor
         - Display flickering:
           Disconnect STlink programmer from SWIM port (next to display)

   - Note for Arduino IDE and Sduino core:
     Track the size of the code when uploading,
     The maximum I got was 93%
     --> (Sketch uses 7589 bytes (92%))
     --> (Bytes written: 8136)
     --> (Maximum is 8192 bytes)
   - Sduino core:
     --> Select STM8S Board / STM8S103F3 Breadout Board
     --> Programmer ST-link/V2
     --> Connect STlink: GND/SWIM/RST

   References:
   - https://github.com/rtek1000/NTC_Lookup_Table_Generator
   - https://github.com/rtek1000/W1209-firmware-modified
*/

/**
   Control functions for main routines.
   - Menu (and Button) tree
   - Display tree
   - Timer tree (using millis() and micros())
*/

#include <stm8s.h>

#include "main.h"
#include "adc.h"
#include "display.h"
#include "menu.h"
#include "params.h"
#include "relay.h"

// #define SWIM_pin PD1 // In use on display

#define BTN1_pin PC3
#define BTN2_pin PC4
#define BTN3_pin PC5

bool BTN1_old = false;
bool BTN2_old = false;
bool BTN3_old = false;

unsigned long BTN1_longPress = 0;
unsigned long BTN2_longPress = 0;
unsigned long BTN3_longPress = 0;

bool isBTN1_longPress = false;
bool isBTN2_longPress = false;
bool isBTN3_longPress = false;

#define buttonLongPressTime 1500
#define buttonFastPulseTime 50

// unsigned long BTN1_fastPulse = 0;
unsigned long BTN2_fastPulse = 0;
unsigned long BTN3_fastPulse = 0;

unsigned long millis_5ms;
byte func_refresh = 0;

unsigned long millis_base;
unsigned long millis_250ms;
unsigned long millis_display1 = 0;
unsigned long millis_display2 = 0;

byte menuState = MENU_ROOT;
byte menuDisplay = 0;
unsigned char* stringBuffer;
bool blink_disp = false;
bool blink_disp_enabled = false;
#define timeoutRecall 20 // 250ms x20 = 5s
byte timeout = 7;

#define timeoutDisplayDimmRecall 60 // 250ms x20 = 15s
byte timeoutDisplayDimm = timeoutDisplayDimmRecall;

bool blinkSpeed = false;

bool factoryMode = false;

#include "stm8s003/gpio.h"

/* Definition for buttons */
// Port C control input from buttons.
#define BUTTONS_PORT   PC_IDR
// PC.3
#define BUTTON1_BIT    0x08
// PC.4
#define BUTTON2_BIT    0x10
// PC.5
#define BUTTON3_BIT    0x20

void button_init() {
  PC_DDR &= ~(BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT);
  PC_CR1 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;

  //  pinMode(BTN1_pin, INPUT_PULLUP);
  //  pinMode(BTN2_pin, INPUT_PULLUP);
  //  pinMode(BTN3_pin, INPUT_PULLUP);
}

bool buttons_pressed12()
{
  return (!digitalRead(BTN2_pin)) && (!digitalRead(BTN3_pin));
}

bool buttons_pressed123()
{
  return ((!digitalRead(BTN1_pin)) && (!digitalRead(BTN2_pin)) ||
          (!digitalRead(BTN1_pin)) && (!digitalRead(BTN3_pin)) ||
          buttons_pressed12());
}

static unsigned char status;

void setup() {
  // put your setup code here, to run once:

  /*
     Pin PD1 in use for Display
     CFG->GCR |= 0x01; // disable SWIM interface enabled at wiring-init.c file SDUINO core

     Free the SWIM pin (STlink port) to be used as a general I/O-Pin
     https://github.com/tenbaht/sduino/blob/development/sduino/stm8/cores/sduino/wiring-init.c

     Do not arbitrarily disable this function SWIM in STM8S001 (has no RESET pin)

  */

  button_init();

  initADC();

  initRelay();

  initDisplay();

  loadParamsEEPROM();

  if (getParamById (PARAM_LOCK_BUTTONS)) {
    menuDisplay = menuState = MENU_EEPROM_LOCKED;

  } else {
    factoryMode = buttons_pressed12(); //(!digitalRead(BTN2_pin)) && (!digitalRead(BTN3_pin));
    
    if (factoryMode == true) {
      menuDisplay = menuState = MENU_EEPROM_RESET;

      resetParamsEEPROM();

    }
  }

  initParamsEEPROM();

}

void loop() {
  // put your main code here, to run repeatedly:
  millis_base = millis();

  if ((millis_base - millis_5ms) >= 5) {
    millis_5ms = millis_base;

    refreshDisplay();

    ADC_handler();

    mainControl();

    refreshRelay();
  } else {
    if ((millis_base - millis_250ms) >= 250) {
      millis_250ms = millis_base;

      incRelayTimer();

      if (menuState > MENU_ROOT) {
        if (!((timeout--) > 0)) {

          if (menuState == MENU_EEPROM_LOCKED) {
            menuDisplay = menuState = MENU_EEPROM_LOCKED2;

            timeout = timeoutRecall / 3;

          } else {
            menuDisplay = menuState = MENU_ROOT;

          }

          blink_disp_enabled = false;

        }
      }

      if (getParamById (PARAM_AUTO_BRIGHT) ) {
        if (timeoutDisplayDimm == timeoutDisplayDimmRecall) {
          dimmerBrightness(brightnessHigh); // clearer
        }

        if (timeoutDisplayDimm > 0) {
          timeoutDisplayDimm--;
        } else {
          dimmerBrightness(brightnessLow); // darker
        }
      }
    }

    mainDisplay();
  }
}

void mainDisplay(void) {
  int temp = 0;
  unsigned char sensor_fail = 0;
  unsigned char paramMsg[] = "P0";
  unsigned char alarmMsg[] = "AL1";

  if ((millis() - millis_display2) < (500 >> blinkSpeed)) {
    return;
  } else {
    millis_display2 = millis();
  }

  blink_disp = !blink_disp;

  controlDot(getRelayState(blink_disp));

  setDisplayOff ( !blink_disp && blink_disp_enabled );

  switch (menuDisplay) {
    case MENU_ROOT:
      sensor_fail = getSensorFail();

      if (sensor_fail != sensor_ok) {
        if (sensor_fail == sensor_fail_HHH) {
          setDisplayStr("HHH");

        } else {
          setDisplayStr("LLL");
        }

        blinkSpeed = blink_disp_enabled = true;

      } else {
        temp = getTemperature();
        setDisplayInt(temp);

        if (getParamById (PARAM_OVERHEAT_INDICATION) ) {
          if ((temp < (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) ||
              (temp >= (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) ) {
            blinkSpeed = blink_disp_enabled = true;
          } else {
            blinkSpeed = blink_disp_enabled = false;
          }
        } else {
          setDisplayOff (0);
        }

      }

      break;

    case MENU_SET_THRESHOLD:
      paramToString (PARAM_THRESHOLD, stringBuffer);

      setDisplayStr (stringBuffer);

      break;

    case MENU_SELECT_PARAM:
      paramMsg[1] = '0' + getParamId();

      setDisplayStr ( (unsigned char*) &paramMsg);

      break;

    case MENU_CHANGE_PARAM:
      paramToString (getParamId(), stringBuffer);

      setDisplayStr (stringBuffer);

      break;

    case MENU_EEPROM_LOCKED:
      paramMsg[1] = '7';

      setDisplayStr ( (unsigned char*) &paramMsg);

      break;

    case MENU_EEPROM_LOCKED2:
      setDisplayStr("LOC");

      break;

    case MENU_ALARM:
      if (getParamById(PARAM_RELAY_MODE) == RELAY_MODE_A2) {
        alarmMsg[2] = '2';
      }

      setDisplayStr((unsigned char*) &alarmMsg);

      break;

    case MENU_ALARM_HIGH:
      setDisplayInt(getParamById (PARAM_MAX_TEMPERATURE) * 10);

      break;

    case MENU_ALARM_LOW:
      setDisplayInt(getParamById (PARAM_MIN_TEMPERATURE) * 10);

      break;

    case MENU_EEPROM_RESET:
      setDisplayStr("RST");

      break;

    default:
      // statements
      break;

  }
}

void mainControl(void) {
  unsigned long millis_control = millis();

  if (buttons_pressed123()) return;

  if (!digitalRead(BTN1_pin)) {
    timeoutDisplayDimm = timeoutDisplayDimmRecall;

    if (BTN1_old == false) {
      BTN1_old = true;

      BTN1_longPress = millis_control;

      isBTN1_longPress = false;

      timeout = timeoutRecall;
    } else {
      if ((millis_control - BTN1_longPress) > buttonLongPressTime) {
        if (menuState == MENU_ROOT) {
          menuDisplay = menuState = MENU_SELECT_PARAM;

          BTN1_longPress = millis_control;

          setParamId (PARAM_RELAY_MODE);

          blink_disp_enabled = false;

          timeout = timeoutRecall;

        } else if (menuState == MENU_SELECT_PARAM) {
          BTN1_longPress = millis_control;

          menuDisplay = menuState = MENU_ROOT;

          timeout = timeoutRecall;
        }

        isBTN1_longPress = true;
      }
    }
  } else {
    BTN1_longPress = millis_control;

    if (BTN1_old == true) {
      BTN1_old = false;

      if (isBTN1_longPress == false) {
        if (menuState == MENU_ROOT) {
          if ((getParamById (PARAM_RELAY_MODE) == RELAY_MODE_A1) || (getParamById (PARAM_RELAY_MODE) == RELAY_MODE_A2)) {
            menuState = menuDisplay = MENU_ALARM;
          } else {
            menuState = menuDisplay = MENU_SET_THRESHOLD;
          }

          blink_disp_enabled = true;

          blinkSpeed = false;

          timeout = timeoutRecall;

          setParamId (PARAM_THRESHOLD);

        } else if ((menuState == MENU_SET_THRESHOLD) ||
                   (menuState == MENU_ALARM) ||
                   (menuState == MENU_ALARM_HIGH) || (menuState == MENU_ALARM_LOW)) {
          menuDisplay = menuState = MENU_ROOT;

          blink_disp_enabled = false;

          storeParams();

        } else {
          if (menuState == MENU_SELECT_PARAM) {
            menuDisplay = menuState = MENU_CHANGE_PARAM;

          } else if (menuState == MENU_CHANGE_PARAM) {
            menuDisplay = menuState = MENU_SELECT_PARAM;

            storeParams();
          }
        }
      }

      isBTN1_longPress = false;
    }
  }

  if (!digitalRead(BTN2_pin)) {
    timeoutDisplayDimm = timeoutDisplayDimmRecall;

    if (BTN2_old == false) {
      BTN2_old = true;

      BTN2_longPress = millis_control;

      timeout = timeoutRecall;

    } else {
      if ((millis_control - BTN2_longPress) > buttonLongPressTime) {
        if ((millis_control - BTN2_fastPulse) > buttonFastPulseTime) {
          BTN2_fastPulse = millis_control;

          if (menuState == MENU_SELECT_PARAM) {
            incParamId();

          } else if (menuState >= MENU_SET_THRESHOLD) {
            if ((getParamById (PARAM_LOCK_BUTTONS) ) && (menuState == MENU_SET_THRESHOLD)) {
              menuDisplay = MENU_EEPROM_LOCKED2;

            } else {
              incParam();

            }
          }

          timeout = timeoutRecall;

        }

        isBTN2_longPress = true;
      }
    }
  } else {
    BTN2_longPress = millis_control;

    if (BTN2_old == true) {
      BTN2_old = false;

      if (isBTN2_longPress == false) {
        if (menuState == MENU_SELECT_PARAM) {
          incParamId();

        } else if (menuState >= MENU_SET_THRESHOLD) {
          if ((menuState == MENU_ALARM) || (menuState == MENU_ALARM_LOW)) {
            menuDisplay = menuState = MENU_ALARM_HIGH;

          } else if ((getParamById (PARAM_LOCK_BUTTONS) ) && (menuState == MENU_SET_THRESHOLD)) {
            menuDisplay = MENU_EEPROM_LOCKED2;

          } else {
            incParam();

          }
        }

        timeout = timeoutRecall;
      }

      isBTN2_longPress = false;
    }
  }

  if (!digitalRead(BTN3_pin)) {
    timeoutDisplayDimm = timeoutDisplayDimmRecall;

    if (BTN3_old == false) {
      BTN3_old = true;

      BTN3_longPress = millis_control;

      timeout = timeoutRecall;

    } else {
      if ((millis_control - BTN3_longPress) > buttonLongPressTime) {
        if ((millis_control - BTN3_fastPulse) > buttonFastPulseTime) {
          BTN3_fastPulse = millis_control;

          if (menuState == MENU_SELECT_PARAM) {
            decParamId();

          } else if (menuState >= MENU_SET_THRESHOLD) {
            if ((getParamById (PARAM_LOCK_BUTTONS) ) && (menuState == MENU_SET_THRESHOLD)) {
              menuDisplay = MENU_EEPROM_LOCKED2;

            } else {
              decParam();

            }

          }

          timeout = timeoutRecall;

        }

        isBTN3_longPress = true;
      }
    }
  } else {
    BTN3_longPress = millis_control;

    if (BTN3_old == true) {
      BTN3_old = false;

      if (isBTN3_longPress == false) {
        if (menuState == MENU_SELECT_PARAM) {
          decParamId();

        } else if (menuState >= MENU_SET_THRESHOLD) {
          if ((menuState == MENU_ALARM) || (menuState == MENU_ALARM_HIGH)) {
            menuDisplay = menuState = MENU_ALARM_LOW;

          } else if ((getParamById (PARAM_LOCK_BUTTONS) ) && (menuState == MENU_SET_THRESHOLD)) {
            menuDisplay = MENU_EEPROM_LOCKED2;

          } else {
            decParam();

          }

        }

        timeout = timeoutRecall;
      }

      isBTN3_longPress = false;
    }
  }
}
