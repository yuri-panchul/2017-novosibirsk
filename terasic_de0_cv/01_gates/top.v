//----------------------------------------------------------------------------
//
//  Exercise   1. Simple combinational logic
//
//  Упражнение 1. Простая комбинационная логика
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Method 1. Using continuous assignments
//
//  Метод  1. Используем операторы непрерывного присваивания
//
//----------------------------------------------------------------------------

module top
(
    output [9:0] led,
    input  [3:0] key
);

    wire a = ~ key [0];
    wire b = ~ key [1];
    wire c = ~ key [2];
    wire d = ~ key [3];

    // Basic gates AND, OR and ~

    assign led [0] = a & b;
    assign led [1] = a | b;
    assign led [2] = ~ a;
    
    // Multiple input gates

    assign led [3] = a & b & c;
    assign led [4] = a | b | c | d;
    
    // XOR gates (useful for adders, comparisons and control sum calculator)

    assign led [5] = a ^ b;

    // De Morgan law illustration

    assign led [6] = ~ ( a &   b ) ;
    assign led [7] = ~   a | ~ b   ;
    assign led [8] = ~ ( a |   b ) ;
    assign led [9] = ~   a & ~ b   ;
    
endmodule

//----------------------------------------------------------------------------
//
//  Вариант 2. Используем always-блок и блокирующие присваивания
//  (blocking assignments)
//
//----------------------------------------------------------------------------

module top_2
(
    output reg [1:0] LED,  // Два светодиода
    input      [1:0] BTN   // Две кнопки
);

    always @*
    begin
        LED [0] = BTN [0] & BTN [1];
        LED [1] = BTN [0] | BTN [1];
    end

endmodule

//----------------------------------------------------------------------------
//
//  Вариант 3. Используем экземляры примитивов and и or
//  (instances)
//
//----------------------------------------------------------------------------

module top_3
(
    output [1:0] LED,  // Два светодиода
    input  [1:0] BTN   // Две кнопки
);

    and and_i (LED [0], BTN [0], BTN [1]);
    or  or_i  (LED [1], BTN [0], BTN [1]);
    
endmodule
