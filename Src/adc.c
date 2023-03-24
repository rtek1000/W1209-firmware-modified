/*
 * This file is part of the W1209 firmware replacement project
 * (https://github.com/mister-grumbler/w1209-firmware).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Control functions for analog-to-digital converter (ADC).
 * The ADC1 interrupt (22) is used to get signal on end of convertion event.
 * The port D6 (pin 3) is used as analog input (AIN6).
 */

#include "adc.h"
#include "stm8s003/adc.h"
#include "params.h"

//#define rawAdc_R2_5k1 1
#define rawAdc_R2_20k 1

// Averaging bits
#define ADC_AVERAGING_BITS      4
#define ADC_AVERAGING_FAIL_BITS 1
#define ADC_RAW_TABLE_SIZE      sizeof rawAdc / sizeof rawAdc[0]
// Base temperature in tenth of degrees of Celsius.
#define ADC_RAW_TABLE_BASE_TEMP -520

#ifdef rawAdc_R2_5k1
/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [677 = 25°C; ] (R2 = 5.1k Ohms)*/
const unsigned int rawAdc[] = {
    1019, 1018, 1018, 1017, 1017, 1016, 1016, 1015, 1014, 1014,
    1013, 1012, 1011, 1010, 1009, 1008, 1007, 1006, 1004, 1003,
    1002, 1000, 999, 997, 995, 993, 991, 989, 987, 984,
    982, 979, 977, 974, 971, 968, 965, 961, 957, 954,
    950, 946, 942, 937, 933, 928, 923, 918, 912, 907,
    901, 895, 889, 883, 876, 870, 863, 856, 848, 841,
    833, 825, 817, 809, 801, 792, 783, 775, 766, 756,
    747, 737, 728, 718, 708, 698, 688, 678, 668, 658,
    647, 637, 626, 616, 606, 595, 585, 574, 564, 553,
    543, 532, 522, 512, 501, 491, 481, 471, 461, 452,
    442, 432, 423, 414, 404, 395, 386, 378, 369, 360,
    352, 344, 336, 328, 320, 312, 305, 297, 290, 283,
    276, 269, 263, 256, 250, 244, 238, 232, 226, 220,
    215, 209, 204, 199, 194, 189, 184, 180, 175, 171,
    167, 163, 158, 154, 151, 147, 143, 140, 136, 133,
    130, 126, 123, 120, 117, 114, 112, 109, 106, 104,
    101, 99, 96, 94, 92
};
#endif

#ifdef rawAdc_R2_20k
/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [341 = 25°C; ] (R2 = 20k Ohms) */
const unsigned int rawAdc[] = {
    974, 971, 967, 964, 960, 956, 953, 948, 944, 940,
    935, 930, 925, 920, 914, 909, 903, 897, 891, 884,
    877, 871, 864, 856, 849, 841, 833, 825, 817, 809,
    800, 791, 782, 773, 764, 754, 745, 735, 725, 715,
    705, 695, 685, 675, 664, 654, 644, 633, 623, 612,
    601, 591, 580, 570, 559, 549, 538, 528, 518, 507,
    497, 487, 477, 467, 457, 448, 438, 429, 419, 410,
    401, 392, 383, 375, 366, 358, 349, 341, 333, 326,
    318, 310, 303, 296, 289, 282, 275, 269, 262, 256,
    250, 244, 238, 232, 226, 221, 215, 210, 205, 200,
    195, 191, 186, 181, 177, 173, 169, 165, 161, 157,
    153, 149, 146, 142, 139, 136, 132, 129, 126, 123,
    120, 117, 115, 112, 109, 107, 104, 102, 100, 97,
    95, 93, 91, 89, 87, 85, 83, 81, 79, 78,
    76, 74, 73, 71, 69, 68, 67, 65, 64, 62,
    61, 60, 58, 57, 56, 55, 54, 53, 52, 51,
    49, 48, 47, 47, 46
};
#endif

static unsigned int result;
static unsigned long result_fail;
static unsigned long averaged;

/**
 * @brief Initialize ADC's configuration registers.
 */
void initADC()
{
    ADC_CR1 |= 0x70;    // Prescaler f/18 (SPSEL)
    ADC_CSR |= 0x06;    // select AIN6
    ADC_CSR |= 0x20;    // Interrupt enable (EOCIE)
    ADC_CR1 |= 0x01;    // Power up ADC
    result = 0;
    averaged = 0;
}

/**
 * @brief Sets bit in ADC control register to start data convertion.
 */
void startADC()
{
    ADC_CR1 |= 0x01;
}

/**
 * @brief Gets raw result of last data conversion.
 * @return raw result.
 */
unsigned int getAdcResult()
{
    return result;
}

/**
 * @brief Gets averaged over 2^ADC_AVERAGING_BITS times result of data
 *  convertion.
 * @return averaged result.
 */
unsigned int getAdcAveraged()
{
    return (unsigned int) (averaged >> ADC_AVERAGING_BITS);
}

/**
 * @brief Calculation of real temperature using averaged result of
 *  AnalogToDigital conversion and the lookup table.
 * @return temperature in tenth of degrees of Celsius.
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
 * @brief This function is ADC's interrupt request handler
 *  so keep it extremely small and fast.
 */
void ADC1_EOC_handler() __interrupt (22)
{
    result = ADC_DRH << 2;
    result |= ADC_DRL;
    ADC_CSR &= ~0x80;   // reset EOC

    // Averaging result
    if (averaged == 0) {
        averaged = result << ADC_AVERAGING_BITS;
    } else {
        averaged += result - (averaged >> ADC_AVERAGING_BITS);
    }

    // Averaging result sensor fail
    if (result_fail == 0) {
        result_fail = result << ADC_AVERAGING_FAIL_BITS;
    } else {
        result_fail += result - (result_fail >> ADC_AVERAGING_FAIL_BITS);
    }
}

int getSensorFail()
{
    if((result_fail >> ADC_AVERAGING_FAIL_BITS) > rawAdc[0]) {
        return 2;
    } else if((result_fail >> ADC_AVERAGING_FAIL_BITS) < rawAdc[ADC_RAW_TABLE_SIZE - 1]) {
        return 1;
    } else {
        return 0;
    }
}
