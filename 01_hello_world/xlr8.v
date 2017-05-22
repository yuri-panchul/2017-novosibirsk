module xlr8
(
    //Clock and Reset

    input          CLOCK,    // 16MHz
    input          RESET_N,

    //Arduino I/Os

    inout          SCL,
    inout          SDA,

    // The D13..D2,TX,RX go through level shift on board before getting to pins

    inout          D13, D12, D11, D10, D9, D8,       // Port B
    inout          D7, D6, D5, D4, D3, D2, TX, RX,   // Port D

    // A5..A0 are labeled DIG_IO_5-0 on schematic

    inout          A5, A4, A3, A2, A1, A0,  // Some stuff on board between here and the actual header pins
    output         PIN13_LED,

    // We can disconnect Ana_Dig from ADC inputs if necessary (don't know if it is) by driving
    //   OE low. Else leave OE as high-Z (don't drive it high).

    inout   [5:0]  DIG_IO_OE,
    output         ANA_UP,      // Choose ADC ref between 1=AREF pin and 0=regulated 3.3V
    output         I2C_ENABLE,  // 0=disable pullups on sda/scl, 1=enable pullups

    // JTAG connector reused as digial IO. On that connector, pin 4 is power, pins 2&10 are ground
    //   and pin 8 selects between gpio (low) and jtag (high) modes and has a pulldown.

    inout          JT9,  // external pullup. JTAG function is TDI
    inout          JT7,  // no JTAG function
    inout          JT6,  // no JTAG function
    inout          JT5,  // external pullup. JTAG function is TMS
    inout          JT3,  // JTAG function TDO
    inout          JT1,  // external pulldown, JTAG function is TCK

    // Interface to EEPROM or other device in SOIC-8 spot on the board

    inout          SOIC7,  // WP in the case of an 24AA128SM EEPROM
    inout          SOIC6,  // SCL in the case of an 24AA128SM EEPROM
    inout          SOIC5,  // SDA in the case of an 24AA128SM EEPROM
    inout          SOIC3,  // A2 in the case of an 24AA128SM EEPROM
    inout          SOIC2,  // A1 in the case of an 24AA128SM EEPROM
    inout          SOIC1   // A0 in the case of an 24AA128SM EEPROM
);

    reg [31:0] n;

    always @(posedge CLOCK or negedge RESET_N)
    begin
        if (! RESET_N)
            n <= 32'b0;
        else
            n <= n + 32'b1;
    end

    assign PIN13_LED = n [20];

endmodule
