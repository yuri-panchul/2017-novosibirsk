module clock_divider_50_mhz_to_1_49_hz
(
    input  clock_50_mhz,
    input  reset_n,
    output clock_1_49_hz
);

    // 50 mhz / 2 ** 25 = 1.49 hz

    reg [24:0] counter;

    always @ (posedge clock_50_mhz)
    begin
        if (! reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_1_49_hz = counter [24];

endmodule

//--------------------------------------------------------------------

module shift_register_with_enable
(
    input            clock,
    input            reset_n,
    input            in,
    input            enable,
    output           out,
    output reg [9:0] data
);

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            data <= 10'b10_0000_0000;
        else if (enable)
            data <= { in, data [9:1] };
    end
    
    assign out = data [0];

endmodule

//--------------------------------------------------------------------

module single_digit_display
(
    input      [3:0] digit,
    output reg [7:0] seven_segments
);

    always @*
        case (digit)
        'h0: seven_segments = 'b01000000;  // . a b c d e f g
        'h1: seven_segments = 'b01111001;
        'h2: seven_segments = 'b00100100;  //   --a--
        'h3: seven_segments = 'b00110000;  //  |     |
        'h4: seven_segments = 'b00011001;  //  f     b
        'h5: seven_segments = 'b00010010;  //  |     |
        'h6: seven_segments = 'b00000010;  //   --g--
        'h7: seven_segments = 'b01111000;  //  |     |
        'h8: seven_segments = 'b00000000;  //  e     c
        'h9: seven_segments = 'b00011000;  //  |     |
        'ha: seven_segments = 'b00001000;  //   --d-- 
        'hb: seven_segments = 'b00000011;
        'hc: seven_segments = 'b01000110;
        'hd: seven_segments = 'b00100001;
        'he: seven_segments = 'b00000110;
        'hf: seven_segments = 'b00001110;
        endcase

endmodule

//--------------------------------------------------------------------

// smiling snail fsm derived from david harris & sarah harris

module pattern_fsm_moore
(
    input  clock,
    input  reset_n,
    input  a,
    output y
);

    parameter [1:0] s0 = 0, s1 = 1, s2 = 2;

    reg [1:0] state, next_state;

    // state register

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            state <= s0;
        else
            state <= next_state;

    // next state logic

    always @*
        case (state)

        s0:
            if (a)
                next_state = s0;
            else
                next_state = s1;

        s1:
            if (a)
                next_state = s2;
            else
                next_state = s1;

        s2:
            if (a)
                next_state = s0;
            else
                next_state = s1;

        default:

            next_state = s0;

        endcase

    // output logic

    assign y = (state == s2);

endmodule


//--------------------------------------------------------------------

module top
(
    input        clock,
    input  [1:0] key,
    input  [9:0] sw,
    output [9:0] led,
    output [7:0] hex0,
    output [7:0] hex1,
    output [7:0] hex2,
    output [7:0] hex3,
    output [7:0] hex4,
    output [7:0] hex5
);

    wire reset_n = sw [9];

    wire slow_clock, shift_out, fsm_out;

    clock_divider_50_mhz_to_1_49_hz clock_divider_50_mhz_to_1_49_hz
    (
        .clock_50_mhz  ( clock      ),
        .reset_n       ( reset_n    ),
        .clock_1_49_hz ( slow_clock )
    );

    shift_register_with_enable shift_register_with_enable
    (
        .clock   (   slow_clock ),
        .reset_n (   reset_n    ),
        .in      ( ~ key [1]    ),
        .enable  (   key [0]    ),
        .out     (   shift_out  ),
        .data    (   led        )
    );           

    single_digit_display digit_0
    (
        .digit          ( led [3:0] ),
        .seven_segments ( hex0 )
    );

    single_digit_display digit_1
    (
        .digit          ( led [7:4] ),
        .seven_segments ( hex1 )
    );

    single_digit_display digit_2
    (
        .digit          ( { 2'b0 , led [9:8] } ),
        .seven_segments ( hex2 )
    );

    pattern_fsm_moore pattern_fsm_moore
    (
        .clock   ( slow_clock ),
        .reset_n ( reset_n    ),
        .a       ( shift_out  ),
        .y       ( fsm_out    )
    );

    assign hex3 = 8'hff;
    assign hex4 = 8'hff;
    assign hex5 = fsm_out ? 8'h40 : 8'hff;

endmodule
