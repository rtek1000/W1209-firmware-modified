

>Option bytes
>
>Option bytes are located in the EEPROM and allow configuring device hardware features such as readout protection and alternate function mapping. Each option byte, except for read-out protection, has to be stored in a normal form (OPTx) and complementary form (NOPTx). The procedure for writing option bytes is the same as for writing EEPROM, except for the unlcok sequence: OPT bit has to be set in FLASH_CR2 and FLASH_NCR2 registers.


```$ echo -ne '\x00\x00\xff\x00\xff\x00\xff\x00\xff\x00\xff' > opt.bin```
```$ stm8flash -c stlinkv2 -p stm8s003f3 -s opt -w opt.bin```

Source: https://lujji.github.io/blog/bare-metal-programming-stm8-part2/
