To-Do:

- Add Timer function:

Basic description:

- Range selection:
- - 0.01 second,
- - 0.1 second,
- - 1 second,
- - 1 minute

- Timing range:
- - Minimum 0.01 second
- - Maximum 999 minutes

--------------------------
User's Guide:

There are two sets of time T1 and T2 for users to set.

Precautions
1. All parameters of the relay are automatically memorized in 5s,
2. If you need to stop during operation, press the stop button to stop the relay and reset the data. Press the stop button again to trigger again.
3. When the relay finishes normally, press the stop button to trigger the start again.

- T1 time setting:
Directly press the plus or minus button to set T1, the data will be automatically memorized 5s after setting, and the timing will start.
- T2 time setting:
Short press the setting button, the digital tube flashes, at this time, press the button to increase or decrease to set T2, 5 seconds after the setting is completed, the automatic memory starts to run.

Time range:
- Automatically switch the range.
- The default range is seconds.
- Decrease the number to 0, continue to press the button to decrease, the range will automatically switch to 99.9s;
- Increase the number to 999, continue to press the button to increase, the range will automatically switch to 0.0.0

- The number format is as follows
- - X.X X---time range 0.01s
- - X X.X---time range 0.1s
- - X X X---time range 1s
- - X.X.X---time range 1min

For example:
- Set T1=8.88, the controller counts down at 0.01s, T2=8.8.8, the controller counts down at 1 minute.
Working mode setting:
- Six working modes for users to set.

Long press the setting key to enter the P-0 parameter, and set the required working mode by pressing the key plus or minus on the current interface.

- P-0: The relay is turned off after a delay of T1, and ends
- P-1: The relay is closed after a delay of T1 time and ends
- P-2: The relay is closed after a delay of T1, and then opened after a delay of T2, and ends
- P-3: The relay opens after a delay of T1 time, then closes after a delay of T2 time, and ends
- P-4: The relay is closed after a delay of T1 time, and then opened after a delay of T2 time, loop
- P-5: The relay opens after a delay of T1 time, and then closes after a delay of T2 time, and loops

Typical application:
- First, let the relay open after a delay of 4.05s, then close after a delay of 10 minutes, and end
- - Firstly set the time, T1=4.05 T2=0.1.0 Secondly set the working mode P-3, it will be automatically memorized 5s after setting, and start to run.


Source: https://www.aliexpress.com/item/1005001830924875.html
