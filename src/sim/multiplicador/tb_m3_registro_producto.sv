
`timescale 1ns/1ps

module tb_m3_registro_producto;

    // ==========================================
    // 1. Declaracion de señales
    // ==========================================

    logic clk;
    logic rst;
    logic limpiar;
    logic escribir;

    logic [63:0] suma_in;
    logic [63:0] producto_out;

    integer pruebas = 0;

    // ==========================================
    // 2. Instancia del modulo M3
    // ==========================================

    m3_registro_producto dut (
        .clk(clk),
        .rst(rst),
        .limpiar(limpiar),
        .escribir(escribir),
        .suma_in(suma_in),
        .producto_out(producto_out)
    );

    // ==========================================
    // 3. Generacion del reloj
    // ==========================================

    initial clk = 0;
    always #5 clk = ~clk;

    // ==========================================
    // 4. Tarea de verificacion
    // ==========================================

    task automatic verificar(
        input logic [63:0] esperado
    );
        begin
            if (producto_out !== esperado) begin
                $fatal(1,
                    "ERROR M3: esperado=%h, obtenido=%h",
                    esperado,
                    producto_out
                );
            end

            pruebas = pruebas + 1;
        end
    endtask

    // ==========================================
    // 5. Pruebas del modulo
    // ==========================================

    initial begin

        $dumpfile("dump_m3.vcd");
        $dumpvars(0, tb_m3_registro_producto);

        // Inicializacion
        rst = 1;
        limpiar = 0;
        escribir = 0;
        suma_in = 64'd0;

        // PRUEBA 1: Reinicio
        @(posedge clk);
        #1;
        verificar(64'd0);

        // PRUEBA 2: Escribir 3
        @(negedge clk);
        rst = 0;
        escribir = 1;
        suma_in = 64'd3;

        @(posedge clk);
        #1;
        verificar(64'd3);

        // PRUEBA 3: Conservar valor
        @(negedge clk);
        escribir = 0;
        suma_in = 64'd100;

        @(posedge clk);
        #1;
        verificar(64'd3);

        // PRUEBA 4: Actualizar a 15
        @(negedge clk);
        escribir = 1;
        suma_in = 64'd15;

        @(posedge clk);
        #1;
        verificar(64'd15);

        // PRUEBA 5: Conservar producto
        @(negedge clk);
        escribir = 0;

        @(posedge clk);
        #1;
        verificar(64'd15);

        // PRUEBA 6: Limpiar producto
        @(negedge clk);
        limpiar = 1;

        @(posedge clk);
        #1;
        verificar(64'd0);

        // PRUEBA 7: Prioridad de limpiar
        @(negedge clk);
        limpiar = 1;
        escribir = 1;
        suma_in = 64'd99;

        @(posedge clk);
        #1;
        verificar(64'd0);

        // PRUEBA 8: Valor maximo de 64 bits
        @(negedge clk);
        limpiar = 0;
        escribir = 1;
        suma_in = 64'hFFFFFFFFFFFFFFFF;

        @(posedge clk);
        #1;
        verificar(64'hFFFFFFFFFFFFFFFF);

        // PRUEBA 9: Conservar valor grande
        @(negedge clk);
        escribir = 0;
        suma_in = 64'd1;

        @(posedge clk);
        #1;
        verificar(64'hFFFFFFFFFFFFFFFF);

        // PRUEBA 10: Prioridad del reinicio
        @(negedge clk);
        rst = 1;
        limpiar = 1;
        escribir = 1;

        @(posedge clk);
        #1;
        verificar(64'd0);

        // ======================================
        // 6. Resultado final
        // ======================================

        $display(
            "PASS: Todas las %0d pruebas de M3 superadas.",
            pruebas
        );

        $finish;

    end

endmodule
