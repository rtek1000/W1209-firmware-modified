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
   Control functions for analog-to-digital converter (ADC).
   The ADC1 interrupt (22) is used to get signal on end of convertion event.
   The port D6 (pin 3) is used as analog input (AIN6).
*/

#include "stm8.h"
#include "adc.h"
//#include "stm8s003/adc.h"
#include "params.h"
#include "ntc_table.h"

#define SENSOR_pin 0x20 // PD5

// Averaging bits
#define ADC_AVERAGING_BITS      4
#define ADC_AVERAGING_FAIL_BITS 1
#define ADC_RAW_TABLE_SIZE      sizeof rawAdc / sizeof rawAdc[0]
// Base temperature in tenth of degrees of Celsius.
#define ADC_RAW_TABLE_BASE_TEMP -520

static unsigned long result;
static unsigned long resultFail;
static unsigned long averaged;

// const unsigned int rawAdc[] // Moved to ntc_table.h file 

/**
   @brief Initialize ADC's configuration registers.
*/
void initADC()
{
      ADC_CR1 |= 0x70;    // Prescaler f/18 (SPSEL)
      ADC_CSR |= 0x05;    // select AIN5
//      ADC_CSR |= 0x20;    // Interrupt enable (EOCIE)
      ADC_CR1 |= 0x01;    // Power up ADC

  //pinMode(SENSOR_pin, INPUT);
  result = 0;
  averaged = ADC_RAW_TABLE_BASE_TEMP << ADC_AVERAGING_BITS;
}

/**
   @brief Sets bit in ADC control register to start data convertion.
*/
void startADC()
{
  ADC_CR1 |= 0x01;
}

/**
   @brief Gets raw result of last data conversion.
   @return raw result.
*/
unsigned int getAdcResult()
{
  return result;
}

/**
   @brief Gets averaged over 2^ADC_AVERAGING_BITS times result of data
    convertion.
   @return averaged result.
*/
unsigned int getAdcAveraged()
{
  return (unsigned int) (averaged >> ADC_AVERAGING_BITS);
}

/**
   @brief Calculation of real temperature using averaged result of
    AnalogToDigital conversion and the lookup table.
   @return temperature in tenth of degrees of Celsius.
*/
int getTemperature()
{
  unsigned int val = averaged >> ADC_AVERAGING_BITS;
  unsigned char rightBound = ADC_RAW_TABLE_SIZE;
  unsigned char leftBound = 0;

  // search through the rawAdc lookup table
  while ( (rightBound - leftBound) > 1) {
    unsigned char midId = (leftBound + rightBound) >> 1;

    if (val > rawAdc[midId]) {
      rightBound = midId;
    } else {
      leftBound = midId;
    }
  }

  // reusing the "val" for storing an intermediate result
  if (val >= rawAdc[leftBound]) {
    val = leftBound * 10;
  } else {
    val = (rightBound * 10) - ( (val - rawAdc[rightBound]) * 10)
          / (rawAdc[leftBound] - rawAdc[rightBound]);
  }

  // Final calculation and correction
  return ADC_RAW_TABLE_BASE_TEMP + val + getParamById (PARAM_TEMPERATURE_CORRECTION);
}

/**
   @brief This function is (not) ADC's interrupt request handler
    so keep it extremely small and fast.
*/
//void ADC1_EOC_handler() __interrupt (22)
void ADC_handler()
{
  ADC_CSR &= ~0x80;   // reset EOC

  ADC_CR1 |= 0x01;    // ADC start

  while((ADC_CSR & 0x80) != 0x80);

  result = ADC_DRH << 2;
  result |= ADC_DRL;
  // ADC_CSR &= ~0x80;   // reset EOC

  // Averaging result
  if (averaged == 0) {
    averaged = result << ADC_AVERAGING_BITS;
  } else {
    averaged += result - (averaged >> ADC_AVERAGING_BITS);
  }

  // Averaging result sensor fail
  if (resultFail == 0) {
    resultFail = result << ADC_AVERAGING_FAIL_BITS;
  } else {
    resultFail += result - (resultFail >> ADC_AVERAGING_FAIL_BITS);
  }
}

unsigned char getSensorFail()
{
  unsigned int _result = resultFail >> ADC_AVERAGING_FAIL_BITS;

  if (_result > rawAdc[0]) {
    return 2;
  } else if (_result < rawAdc[ADC_RAW_TABLE_SIZE - 1]) {
    return 1;
  } else {
    return 0;
  }
}
