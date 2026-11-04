
`timescale 1ns/1ps

module tb_m4_sumador;

    // ==========================================
    // 1. Declaracion de señales
    // ==========================================

    logic [63:0] multiplicando_in;
    logic [63:0] producto_in;
    logic [63:0] suma_out;

    integer pruebas = 0;

    // ==========================================
    // 2. Instancia del modulo M4
    // ==========================================

    m4_sumador dut (
        .multiplicando_in(multiplicando_in),
        .producto_in(producto_in),
        .suma_out(suma_out)
    );

    // ==========================================
    // 3. Tarea de verificacion
    // ==========================================

    task automatic verificar(
        input logic [63:0] a,
        input logic [63:0] b,
        input logic [63:0] esperado
    );
        begin
            multiplicando_in = a;
            producto_in = b;

            // Esperar propagacion combinacional
            #1;

            if (suma_out !== esperado) begin
                $fatal(1,
                    "ERROR M4: %h + %h = %h, esperado=%h",
                    a, b, suma_out, esperado
                );
            end

            pruebas = pruebas + 1;
        end
    endtask

    // ==========================================
    // 4. Pruebas del sumador
    // ==========================================

    initial begin

        $dumpfile("dump_m4.vcd");
        $dumpvars(0, tb_m4_sumador);

        // PRUEBA 1: Cero + cero
        verificar(64'd0, 64'd0, 64'd0);

        // PRUEBA 2: Cero + numero
        verificar(64'd0, 64'd25, 64'd25);

        // PRUEBA 3: Numero + cero
        verificar(64'd15, 64'd0, 64'd15);

        // PRUEBA 4: Suma sencilla
        verificar(64'd3, 64'd5, 64'd8);

        // PRUEBA 5: Suma del algoritmo
        verificar(64'd12, 64'd3, 64'd15);

        // PRUEBA 6: Suma con acarreo
        verificar(64'd255, 64'd1, 64'd256);

        // PRUEBA 7: Valores grandes
        verificar(
            64'h00000000FFFFFFFF,
            64'd1,
            64'h0000000100000000
        );

        // PRUEBA 8: Suma de 64 bits
        verificar(
            64'h8000000000000000,
            64'h0000000000000001,
            64'h8000000000000001
        );

        // PRUEBA 9: Desbordamiento
        verificar(
            64'hFFFFFFFFFFFFFFFF,
            64'd1,
            64'd0
        );

        // PRUEBA 10: Valores maximos
        verificar(
            64'hFFFFFFFFFFFFFFFF,
            64'hFFFFFFFFFFFFFFFF,
            64'hFFFFFFFFFFFFFFFE
        );

        // ==========================================
        // 5. Resultado final
        // ==========================================

        $display(
            "PASS: Todas las %0d pruebas de M4 superadas.",
            pruebas
        );

        $finish;

    end

endmodule
