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
    input  [1:0] key,  // Кнопки
    output [9:0] led   // Светодиоды
);

    wire a = ~ key [0];
    wire b = ~ key [1];

    // Basic gates AND, OR and NOT
    
    // Базовые логические элементы И, ИЛИ, НЕ

    assign led [0] = a & b;
    assign led [1] = a | b;
    assign led [2] = ~ a;
    
    // XOR gates (useful for adders, comparisons,
    // parity and control sum calculation)

    // Логический элемент ИСКЛЮЧАЮЩЕЕ ИЛИ (полезный для сумматоров,
    // сравнений, вычисления четности и контрольных сумм)

    assign led [3] = a ^ b;

    // NAND and NOR gates (useful to explain how a gate is built from
    // transistors)
 
    // Логические элементы И-НЕ и ИЛИ-НЕ (полезны для объяснения,
    // как логический элемент строится из транзисторов

    assign led [4] = a ~& b;
    assign led [5] = a ~| b;

    // De Morgan law illustration
    
    // Иллюстрация законов де Моргана

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
    input  [1:0] key,
    output [9:0] led
);

    reg a, b;

    always @*
    begin
        a = ~ key [0];
        b = ~ key [1];

        led [0] = a & b;
        led [1] = a | b;
        led [2] = ~ a;
    
        led [3] = a ^ b;

        led [4] = a ~& b;
        led [5] = a ~| b;

        led [6] = ~ ( a &   b ) ;
        led [7] = ~   a | ~ b   ;
        led [8] = ~ ( a |   b ) ;
        led [9] = ~   a & ~ b   ;
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
    input  [1:0] key,
    output [9:0] led
);

    wire a, b;
    
    not  not_1  (a, key [0]);
    not  not_2  (b, key [1]);

    and  and_1  (led [0], a, b);
    or   or_1   (led [1], a, b);
    not  not_3  (led [2], a);
    xor  xor_1  (led [3], a, b);
    nand nand_1 (led [4], a, b);
    nor  nor_1  (led [5], a, b);

    // led [6] = ~ (a & b)

    wire w1;

    and and_2 (w1, a, b);
    not not_4 (led [6], w1);
    
    // led [7] = ~ a | ~ b  

    wire w2, w3;

    not not_5 (w2, a);
    not not_6 (w3, b);
    or  or_2  (led [7], w2, w3);

    // led [8] = ~ (a | b)

    wire w4;

    or  or_3 (w4, a, b);
    not not_7 (led [8], w4);

    // led [9] = ~ a & ~ b

    wire w5, w6;

    not not_8 (w5, a);
    not not_9 (w6, b);
    and and_3 (led [9], w5, w6);

endmodule
