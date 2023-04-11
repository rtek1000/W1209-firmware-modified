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

#ifndef NTC_TABLE_H
#define NTC_TABLE_H

/*
 * 
 * Use only one option, if necessary change the values.
 * 
 * You can measure NTC at known temperatures and compare with
 * datasheet tables to find the curve, or use an online curve calculator.
 * 
 * See:
 * - https://www.thinksrs.com/downloads/programs/therm%20calc/ntccalibrator/ntccalculator.html
 * 
 * - https://github.com/rtek1000/NTC_Lookup_Table_Generator
 * 
 */
#define select_table_R2_5k1_NTC_10k_B3950

//#define select_table_R2_5k1_NTC_10k_B3135

//#define select_table_R2_10k_NTC_10k_B3950

//#define select_table_R2_10k_NTC_10k_B3135

//#define select_table_R2_20k_NTC_10k_B3950

//#define select_table_R2_20k_NTC_10k_B3135

#ifdef select_table_R2_5k1_NTC_10k_B3950
#warning "Using table for R2: 5k1; NTC: 10k curve B3950"

/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [668 = 25°C] (R2 = 5.1k Ohms) (NTC 10k B3950)*/
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
#endif // select_table_R2_5k1_NTC_10k_B3950

#ifdef select_table_R2_5k1_NTC_10k_B3135
#warning "Using table for R2: 5k1; NTC: 10k curve B3135"

/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [670 = 25°C] (R2 = 5.1k Ohms) (NTC 10k B3135)*/
const unsigned int rawAdc[] = {
  1011, 1010, 1009, 1008, 1007, 1006, 1005, 1004, 1002, 1001,
  1000, 998, 997, 995, 994, 992, 990, 988, 986, 984,
  982, 980, 978, 975, 973, 970, 968, 965, 962, 959,
  956, 953, 949, 946, 942, 939, 935, 931, 927, 923,
  918, 914, 909, 905, 900, 895, 890, 885, 880, 874,
  869, 863, 857, 851, 845, 839, 833, 826, 820, 813,
  806, 799, 792, 785, 778, 771, 764, 756, 749, 741,
  733, 726, 718, 710, 702, 694, 686, 678, 670, 662,
  654, 646, 637, 629, 621, 613, 604, 596, 588, 580,
  572, 563, 555, 547, 539, 531, 523, 515, 507, 499,
  492, 484, 476, 469, 461, 454, 446, 439, 432, 424,
  417, 410, 403, 396, 390, 383, 376, 370, 363, 357,
  351, 345, 339, 333, 327, 321, 315, 309, 304, 298,
  293, 288, 283, 278, 273, 268, 263, 258, 253, 249,
  244, 240, 235, 231, 227, 223, 219, 215, 211, 207,
  203, 200, 196, 193, 189, 186, 182, 179, 176, 173,
  170, 167, 164, 161, 158
};
#endif // select_table_R2_5k1_NTC_10k_B3135

#ifdef select_table_R2_10k_NTC_10k_B3950
#warning "Using table for R2: 10k; NTC: 10k curve B3950"

/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [501 = 25°C] (R2 = 10k Ohms) (NTC 10k B3950)*/
const unsigned int rawAdc[] = {
  1014, 1013, 1012, 1011, 1010, 1009, 1008, 1007, 1005, 1004,
  1002, 1001, 999, 997, 995, 993, 991, 989, 986, 984,
  981, 978, 975, 972, 969, 965, 962, 958, 954, 949,
  945, 940, 935, 930, 925, 919, 914, 908, 901, 895,
  888, 881, 874, 867, 859, 851, 843, 834, 826, 817,
  808, 799, 789, 780, 770, 760, 749, 739, 728, 718,
  707, 696, 685, 673, 662, 651, 639, 628, 616, 604,
  593, 581, 570, 558, 546, 535, 523, 512, 501, 489,
  478, 467, 456, 445, 435, 424, 414, 404, 394, 384,
  374, 364, 355, 346, 336, 328, 319, 310, 302, 294,
  286, 278, 270, 263, 256, 249, 242, 235, 228, 222,
  216, 210, 204, 198, 193, 187, 182, 177, 172, 167,
  162, 158, 153, 149, 145, 141, 137, 133, 129, 126,
  122, 119, 115, 112, 109, 106, 103, 100, 98, 95,
  92, 90, 87, 85, 83, 81, 78, 76, 74, 72,
  70, 69, 67, 65, 63, 62, 60, 59, 57, 56,
  54, 53, 51, 50, 49
};
#endif // select_table_R2_10k_NTC_10k_B3950

#ifdef select_table_R2_10k_NTC_10k_B3135
#warning "Using table for R2: 10k; NTC: 10k curve B3135"
/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [503 = 25°C] (R2 = 10k Ohms) (NTC 10k B3135)*/
const unsigned int rawAdc[] = {
  998, 997, 995, 993, 991, 989, 987, 985, 983, 980,
  978, 975, 972, 969, 966, 963, 960, 956, 953, 949,
  945, 941, 937, 933, 928, 924, 919, 914, 909, 904,
  898, 893, 887, 881, 875, 869, 863, 856, 849, 843,
  836, 828, 821, 814, 806, 798, 791, 783, 775, 766,
  758, 750, 741, 732, 724, 715, 706, 697, 688, 679,
  669, 660, 651, 642, 632, 623, 614, 604, 595, 586,
  576, 567, 558, 549, 539, 530, 521, 512, 503, 494,
  485, 476, 468, 459, 451, 442, 434, 425, 417, 409,
  401, 393, 386, 378, 371, 363, 356, 349, 342, 335,
  328, 321, 315, 308, 302, 295, 289, 283, 277, 272,
  266, 260, 255, 249, 244, 239, 234, 229, 224, 220,
  215, 210, 206, 202, 197, 193, 189, 185, 181, 178,
  174, 170, 167, 163, 160, 157, 153, 150, 147, 144,
  141, 138, 135, 133, 130, 127, 125, 122, 120, 117,
  115, 113, 110, 108, 106, 104, 102, 100, 98, 96,
  94, 92, 91, 89, 87
};
#endif // select_table_R2_10k_NTC_10k_B3135

#ifdef select_table_R2_20k_NTC_10k_B3950
#warning "Using table for R2: 20k; NTC: 10k curve B3950"

/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [331 = 25°C] (R2 = 20k Ohms) (NTC 10k B3950)*/
const unsigned int rawAdc[] = {
  1004, 1002, 1001, 999, 997, 995, 992, 990, 987, 985,
  982, 979, 975, 972, 968, 964, 960, 956, 952, 947,
  942, 937, 931, 925, 919, 913, 906, 899, 892, 885,
  877, 869, 861, 852, 843, 834, 825, 815, 805, 795,
  784, 773, 762, 751, 740, 728, 716, 704, 692, 680,
  667, 655, 642, 629, 617, 604, 591, 578, 565, 552,
  540, 527, 514, 502, 489, 477, 465, 453, 441, 429,
  417, 406, 395, 383, 373, 362, 352, 341, 331, 322,
  312, 303, 294, 285, 276, 268, 259, 251, 244, 236,
  229, 221, 215, 208, 201, 195, 189, 183, 177, 172,
  166, 161, 156, 151, 146, 141, 137, 133, 129, 125,
  121, 117, 113, 110, 106, 103, 100, 97, 94, 91,
  88, 85, 83, 80, 78, 76, 73, 71, 69, 67,
  65, 63, 61, 59, 58, 56, 54, 53, 51, 50,
  48, 47, 46, 44, 43, 42, 41, 40, 39, 37,
  36, 35, 35, 34, 33, 32, 31, 30, 29, 29,
  28, 27, 26, 26, 25
};
#endif // select_table_R2_20k_NTC_10k_B3950

#ifdef select_table_R2_20k_NTC_10k_B3135
#warning "Using table for R2: 20k; NTC: 10k curve B3135"

/* The lookup table contains raw ADC values for every degree of Celsius
   from -52C to 112C. [341 = 25°C] (R2 = 20k Ohms) (NTC 10k B3135) */
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
#endif // select_table_R2_20k_NTC_10k_B3135

#endif // NTC_TABLE_H
