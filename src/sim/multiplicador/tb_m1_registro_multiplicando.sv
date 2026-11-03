
`timescale 1ns/1ps

module tb_m1_registro_multiplicando;

    logic clk;
    logic rst;
    logic cargar;
    logic desplazar;
    logic [31:0] multiplicando_in;
    logic [63:0] multiplicando_out;

    m1_registro_multiplicando dut (
        .clk(clk),
        .rst(rst),
        .cargar(cargar),
        .desplazar(desplazar),
        .multiplicando_in(multiplicando_in),
        .multiplicando_out(multiplicando_out)
    );

    // Reloj de periodo 10 ns.
    initial clk = 0;
    always #5 clk = ~clk;

    // Verifica el valor del registro.
    task automatic verificar(
        input logic [63:0] esperado
    );
        if (multiplicando_out !== esperado) begin
            $fatal(1,
                "ERROR: esperado=%h, obtenido=%h",
                esperado, multiplicando_out
            );
        end
    endtask

    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_m1_registro_multiplicando);

        rst = 1;
        cargar = 0;
        desplazar = 0;
        multiplicando_in = 0;

        // PRUEBA 1: Reinicio.
        @(posedge clk);
        #1;
        verificar(64'd0);

        // PRUEBA 2: Cargar el numero 5.
        @(negedge clk);
        rst = 0;
        cargar = 1;
        multiplicando_in = 32'd5;

        @(posedge clk);
        #1;
        verificar(64'd5);

        // PRUEBA 3: Primer desplazamiento.
        @(negedge clk);
        cargar = 0;
        desplazar = 1;

        @(posedge clk);
        #1;
        verificar(64'd10);

        // PRUEBA 4: Segundo desplazamiento.
        @(posedge clk);
        #1;
        verificar(64'd20);

        // PRUEBA 5: Conservacion del valor.
        @(negedge clk);
        desplazar = 0;

        @(posedge clk);
        #1;
        verificar(64'd20);

        // PRUEBA 6: Prioridad de carga.
        @(negedge clk);
        cargar = 1;
        desplazar = 1;
        multiplicando_in = 32'd7;

        @(posedge clk);
        #1;
        verificar(64'd7);

        // PRUEBA 7: Desplazamiento de 64 bits.
        @(negedge clk);
        cargar = 1;
        desplazar = 0;
        multiplicando_in = 32'h80000000;

        @(posedge clk);
        #1;
        verificar(64'h0000000080000000);

        @(negedge clk);
        cargar = 0;
        desplazar = 1;

        @(posedge clk);
        #1;
        verificar(64'h0000000100000000);

        // PRUEBA 8: Reinicio con controles activos.
        @(negedge clk);
        rst = 1;
        cargar = 1;
        desplazar = 1;

        @(posedge clk);
        #1;
        verificar(64'd0);

        $display("PASS: Todas las pruebas de M1 superadas.");
        $finish;
    end

endmodule
