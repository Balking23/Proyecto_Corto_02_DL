
`timescale 1ns/1ps

module tb_m2_registro_multiplicador;

    logic clk;
    logic rst;
    logic cargar;
    logic desplazar;

    logic [31:0] multiplicador_in;
    logic [31:0] multiplicador_out;
    logic bit_multiplicador;

    integer pruebas = 0;

    // Instancia del modulo M2
    m2_registro_multiplicador dut (
        .clk(clk),
        .rst(rst),
        .cargar(cargar),
        .desplazar(desplazar),
        .multiplicador_in(multiplicador_in),
        .multiplicador_out(multiplicador_out),
        .bit_multiplicador(bit_multiplicador)
    );

    // Reloj de periodo 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Verificacion automatica
    task automatic verificar(
        input logic [31:0] esperado
    );
        begin
            if (multiplicador_out !== esperado ||
                bit_multiplicador !== esperado[0]) begin

                $fatal(1,
                    "ERROR: esperado=%h bit=%b, obtenido=%h bit=%b",
                    esperado, esperado[0],
                    multiplicador_out, bit_multiplicador
                );
            end

            pruebas = pruebas + 1;
        end
    endtask

    initial begin

        $dumpfile("dump_m2.vcd");
        $dumpvars(0, tb_m2_registro_multiplicador);

        rst = 1;
        cargar = 0;
        desplazar = 0;
        multiplicador_in = 0;

        // PRUEBA 1: Reinicio
        @(posedge clk);
        #1;
        verificar(32'd0);

        // PRUEBA 2: Cargar numero 5
        @(negedge clk);
        rst = 0;
        cargar = 1;
        multiplicador_in = 32'd5;

        @(posedge clk);
        #1;
        verificar(32'd5);

        // PRUEBA 3: Primer desplazamiento
        @(negedge clk);
        cargar = 0;
        desplazar = 1;

        @(posedge clk);
        #1;
        verificar(32'd2);

        // PRUEBA 4: Segundo desplazamiento
        @(posedge clk);
        #1;
        verificar(32'd1);

        // PRUEBA 5: Tercer desplazamiento
        @(posedge clk);
        #1;
        verificar(32'd0);

        // PRUEBA 6: Conservacion del valor
        @(negedge clk);
        desplazar = 0;

        @(posedge clk);
        #1;
        verificar(32'd0);

        // PRUEBA 7: Prioridad de carga
        @(negedge clk);
        cargar = 1;
        desplazar = 1;
        multiplicador_in = 32'd15;

        @(posedge clk);
        #1;
        verificar(32'd15);

        // PRUEBA 8: Bit mas significativo
        @(negedge clk);
        multiplicador_in = 32'h80000000;
        desplazar = 0;

        @(posedge clk);
        #1;
        verificar(32'h80000000);

        // PRUEBA 9: Desplazamiento grande
        @(negedge clk);
        cargar = 0;
        desplazar = 1;

        @(posedge clk);
        #1;
        verificar(32'h40000000);

        // PRUEBA 10: Reinicio con controles activos
        @(negedge clk);
        rst = 1;
        cargar = 1;
        desplazar = 1;

        @(posedge clk);
        #1;
        verificar(32'd0);

        $display(
            "PASS: Todas las %0d pruebas de M2 superadas.",
            pruebas
        );

        $finish;
    end

endmodule
