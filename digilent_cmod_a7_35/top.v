module counter
(
    input             clock,
    input             reset_n,
    input      [ 7:0] incr,
    input             sign,
    output reg [47:0] count
);

    always @(posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            count <= 48'b0;
        else if (sign)
            count <= count - incr;
        else
            count <= count + incr;
    end

endmodule

//----------------------------------------------------------------------------

module seven_segment_display_driver
(
    input      [3:0] number,
    output reg [6:0] abcdefg
);

    // a b c d e f g  dp   Буквы с картинки
    // 7 6 4 2 1 9 10 5    Выводы 7-сегментного индикатора
    // 7 6 5 4 3 2 1       Выводы сигнала pio в ПЛИС

    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d-- 

    always @*
        case (number)
        4'h0: abcdefg = 7'b1111110;
        4'h1: abcdefg = 7'b0110000;
        4'h2: abcdefg = 7'b1101101;
        4'h3: abcdefg = 7'b1111001;
        4'h4: abcdefg = 7'b0110011;
        4'h5: abcdefg = 7'b1011011;
        4'h6: abcdefg = 7'b1011111;
        4'h7: abcdefg = 7'b1110000;
        4'h8: abcdefg = 7'b1111111;
        4'h9: abcdefg = 7'b1111011;
        4'ha: abcdefg = 7'b1110111;
        4'hb: abcdefg = 7'b0011111;
        4'hc: abcdefg = 7'b1001110;
        4'hd: abcdefg = 7'b0111101;
        4'he: abcdefg = 7'b1001111;
        4'hf: abcdefg = 7'b1000111;
        endcase

endmodule

//----------------------------------------------------------------------------

module top
(
    input         CLK,         // Тактовый сигнал 12 MHz

    output        RGB0_Red,    // Красная часть трехцветного светодиода
    output        RGB0_Green,  // Зеленая часть трехцветного светодиода
    output        RGB0_Blue,   // Синяя часть трехцветного светодиода

    input  [ 1:0] BTN,         // Две кнопки
    inout  [48:1] pio          // GPIO, General-Purpose Input/Output
);

    wire reset_n = ! BTN [0];

    wire [47:0] count1, count2;

    counter counter1
    (
        .clock   ( CLK     ),
        .reset_n ( reset_n ),
        .incr    ( 8'b1    ),
        .sign    ( 1'b0    ),
        .count   ( count1  )
    );

    counter counter2
    (
        .clock   ( CLK            ),
        .reset_n ( reset_n        ),
        .incr    ( count1 [31:24] ),
        .sign    ( 1'b1           ),
        .count   ( count2         )
    );

    assign pio [1] = count2 [25];

    assign RGB0_Red   = count2 [23];
    assign RGB0_Green = count2 [24];
    assign RGB0_Blue  = count2 [25];

    seven_segment_display_driver driver1
    (
        .number  ( count2 [25:22] ),
        .abcdefg ( pio    [ 8: 2] )
    );

    wire [6:0] abcdefg2;

    assign { pio [48:47], pio [14:10] } = abcdefg2;

    seven_segment_display_driver driver2
    (
        .number  ( count2 [29:26] ),
        .abcdefg ( abcdefg2       )
    );

    wire [6:0] abcdefg3;

    assign { pio [46], pio [22:18], pio [45] } = abcdefg3;

    seven_segment_display_driver driver3
    (
        .number  ( count2 [33:30] ),
        .abcdefg ( abcdefg3       )
    );

    seven_segment_display_driver driver4
    (
        .number  ( count2 [37:34] ),
        .abcdefg ( pio    [32:26] )
    );

endmodule
