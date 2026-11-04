
`timescale 1ns/1ps

module tb_m5_contador;

    // ==========================================
    // 1. DECLARACION DE SEÑALES
    // ==========================================

    logic clk;
    logic rst;
    logic limpiar;
    logic incrementar;

    logic [5:0] cuenta_out;
    logic iteraciones_completas;

    integer pruebas = 0;
    integer i;


    // ==========================================
    // 2. INSTANCIA DEL MODULO M5
    // ==========================================

    m5_contador dut (
        .clk(clk),
        .rst(rst),
        .limpiar(limpiar),
        .incrementar(incrementar),
        .cuenta_out(cuenta_out),
        .iteraciones_completas(iteraciones_completas)
    );


    // ==========================================
    // 3. GENERACION DEL RELOJ
    // ==========================================

    initial clk = 0;
    always #5 clk = ~clk;


    // ==========================================
    // 4. TAREA DE VERIFICACION
    // ==========================================

    task automatic verificar(
        input logic [5:0] esperado
    );
        begin

            if (cuenta_out !== esperado ||
                iteraciones_completas !==
                (esperado == 6'd32)) begin

                $fatal(1,
                    "ERROR M5: esperado=%0d, obtenido=%0d, fin=%b",
                    esperado,
                    cuenta_out,
                    iteraciones_completas
                );

            end

            pruebas = pruebas + 1;

        end
    endtask


    // ==========================================
    // 5. INICIO DE LAS PRUEBAS
    // ==========================================

    initial begin

        $dumpfile("dump_m5.vcd");
        $dumpvars(0, tb_m5_contador);

        rst = 1;
        limpiar = 0;
        incrementar = 0;


        // ======================================
        // PRUEBA 1: REINICIO INICIAL
        // ======================================

        @(posedge clk);
        #1;

        verificar(6'd0);


        // ======================================
        // PRUEBA 2: PRIMER INCREMENTO
        // ======================================

        @(negedge clk);

        rst = 0;
        incrementar = 1;

        @(posedge clk);
        #1;

        verificar(6'd1);


        // ======================================
        // PRUEBA 3: SEGUNDO INCREMENTO
        // ======================================

        @(posedge clk);
        #1;

        verificar(6'd2);


        // ======================================
        // PRUEBA 4: CONSERVAR EL VALOR
        // ======================================

        @(negedge clk);

        incrementar = 0;

        @(posedge clk);
        #1;

        verificar(6'd2);


        // ======================================
        // PRUEBA 5: LIMPIAR EL CONTADOR
        // ======================================

        @(negedge clk);

        limpiar = 1;

        @(posedge clk);
        #1;

        verificar(6'd0);


        // ======================================
        // PRUEBA 6: PRIORIDAD DE LIMPIAR
        // ======================================

        @(negedge clk);

        limpiar = 1;
        incrementar = 1;

        @(posedge clk);
        #1;

        verificar(6'd0);


        // ======================================
        // PRUEBA 7: CONTAR DE 1 HASTA 31
        // ======================================

        @(negedge clk);

        limpiar = 0;
        incrementar = 1;

        for (i = 1; i <= 31; i = i + 1) begin

            @(posedge clk);
            #1;

            verificar(i);

        end


        // ======================================
        // PRUEBA 8: LLEGAR A 32
        // ======================================

        @(posedge clk);
        #1;

        verificar(6'd32);


        // ======================================
        // PRUEBA 9: NO SUPERAR 32
        // ======================================

        repeat (3) begin

            @(posedge clk);
            #1;

            verificar(6'd32);

        end


        // ======================================
        // PRUEBA 10: PRIORIDAD DEL RESET
        // ======================================

        @(negedge clk);

        rst = 1;
        limpiar = 1;
        incrementar = 1;

        @(posedge clk);
        #1;

        verificar(6'd0);


        // ======================================
        // 6. RESULTADO FINAL
        // ======================================

        $display(
            "PASS: Todas las pruebas de M5 superadas."
        );

        $display(
            "Comprobaciones realizadas: %0d",
            pruebas
        );

        $finish;

    end

endmodule
