
`timescale 1ns/1ps

module tb_m6_datapath_multiplicador;

    // ==========================================
    // 1. DECLARACION DE SEÑALES
    // ==========================================

    logic clk;
    logic rst;

    logic [31:0] multiplicando_in;
    logic [31:0] multiplicador_in;

    logic cargar_operandos;
    logic desplazar_multiplicando;
    logic desplazar_multiplicador;

    logic limpiar_producto;
    logic sumar_producto;

    logic limpiar_contador;
    logic incrementar_contador;

    logic bit_multiplicador;
    logic iteraciones_completas;

    logic [63:0] producto_out;

    integer pruebas = 0;
    integer i;


    // ==========================================
    // 2. INSTANCIA DEL DATAPATH M6
    // ==========================================

    m6_datapath_multiplicador dut (

        .clk(clk),
        .rst(rst),

        .multiplicando_in(multiplicando_in),
        .multiplicador_in(multiplicador_in),

        .cargar_operandos(cargar_operandos),

        .desplazar_multiplicando(
            desplazar_multiplicando
        ),

        .desplazar_multiplicador(
            desplazar_multiplicador
        ),

        .limpiar_producto(limpiar_producto),
        .sumar_producto(sumar_producto),

        .limpiar_contador(limpiar_contador),

        .incrementar_contador(
            incrementar_contador
        ),

        .bit_multiplicador(bit_multiplicador),

        .iteraciones_completas(
            iteraciones_completas
        ),

        .producto_out(producto_out)

    );


    // ==========================================
    // 3. GENERACION DEL RELOJ
    // ==========================================

    initial clk = 0;
    always #5 clk = ~clk;


    // ==========================================
    // 4. TAREA PARA REALIZAR MULTIPLICACIONES
    // ==========================================

    task automatic probar_multiplicacion(
        input logic [31:0] a,
        input logic [31:0] b
    );

        logic [63:0] esperado;

        begin

            // Resultado de referencia
            esperado = {32'b0, a} * {32'b0, b};


            // ==================================
            // INICIALIZACION DEL DATAPATH
            // ==================================

            @(negedge clk);

            multiplicando_in = a;
            multiplicador_in = b;

            cargar_operandos = 1;

            limpiar_producto = 1;
            limpiar_contador = 1;

            desplazar_multiplicando = 0;
            desplazar_multiplicador = 0;

            sumar_producto = 0;
            incrementar_contador = 0;


            // Cargar operandos
            @(posedge clk);
            #1;

            if (producto_out !== 64'd0 ||
                iteraciones_completas !== 1'b0) begin

                $fatal(1,
                    "ERROR M6: inicializacion incorrecta"
                );

            end


            // ==================================
            // EJECUTAR LAS 32 ITERACIONES
            // ==================================

            for (i = 0; i < 32; i = i + 1) begin

                @(negedge clk);

                cargar_operandos = 0;

                limpiar_producto = 0;
                limpiar_contador = 0;

                // Sumar solamente si el bit es 1
                sumar_producto = bit_multiplicador;

                // Desplazar ambos registros
                desplazar_multiplicando = 1;
                desplazar_multiplicador = 1;

                // Incrementar contador
                incrementar_contador = 1;


                // Ejecutar una iteracion
                @(posedge clk);
                #1;


                // Verificar contador
                if (dut.cuenta_iteraciones !== (i + 1)) begin

                    $fatal(1,
                        "ERROR M6: iteracion=%0d, cuenta=%0d",
                        i + 1,
                        dut.cuenta_iteraciones
                    );

                end


                // Verificar finalizacion
                if (iteraciones_completas !==
                    (i == 31)) begin

                    $fatal(1,
                        "ERROR M6: señal de finalizacion"
                    );

                end

            end


            // ==================================
            // DETENER LAS OPERACIONES
            // ==================================

            @(negedge clk);

            sumar_producto = 0;

            desplazar_multiplicando = 0;
            desplazar_multiplicador = 0;

            incrementar_contador = 0;


            // ==================================
            // VERIFICAR RESULTADO FINAL
            // ==================================

            if (producto_out !== esperado) begin

                $fatal(1,
                    "ERROR M6: %0d x %0d = %0d, esperado=%0d",
                    a,
                    b,
                    producto_out,
                    esperado
                );

            end


            // Verificar conservacion del resultado
            @(posedge clk);
            #1;

            if (producto_out !== esperado ||
                iteraciones_completas !== 1'b1) begin

                $fatal(1,
                    "ERROR M6: resultado no conservado"
                );

            end


            pruebas = pruebas + 1;

            $display(
                "PASS Prueba %0d: %0d x %0d = %0d",
                pruebas,
                a,
                b,
                producto_out
            );

        end

    endtask


    // ==========================================
    // 5. PRUEBAS DEL DATAPATH COMPLETO
    // ==========================================

    initial begin

        $dumpfile("dump_m6.vcd");
        $dumpvars(0, tb_m6_datapath_multiplicador);


        // Inicializacion de señales
        rst = 1;

        multiplicando_in = 0;
        multiplicador_in = 0;

        cargar_operandos = 0;

        desplazar_multiplicando = 0;
        desplazar_multiplicador = 0;

        limpiar_producto = 0;
        sumar_producto = 0;

        limpiar_contador = 0;
        incrementar_contador = 0;


        // Reinicio inicial
        @(posedge clk);
        #1;

        rst = 0;


        // ======================================
        // PRUEBA 1: 3 x 5 = 15
        // ======================================

        probar_multiplicacion(32'd3, 32'd5);


        // ======================================
        // PRUEBA 2: 7 x 6 = 42
        // ======================================

        probar_multiplicacion(32'd7, 32'd6);


        // ======================================
        // PRUEBA 3: 0 x 25 = 0
        // ======================================

        probar_multiplicacion(32'd0, 32'd25);


        // ======================================
        // PRUEBA 4: 25 x 0 = 0
        // ======================================

        probar_multiplicacion(32'd25, 32'd0);


        // ======================================
        // PRUEBA 5: 1 x 12345
        // ======================================

        probar_multiplicacion(32'd1, 32'd12345);


        // ======================================
        // PRUEBA 6: 15 x 15 = 225
        // ======================================

        probar_multiplicacion(32'd15, 32'd15);


        // ======================================
        // PRUEBA 7: VALORES GRANDES
        // ======================================

        probar_multiplicacion(
            32'hFFFFFFFF,
            32'd2
        );


        // ======================================
        // PRUEBA 8: BIT MAS SIGNIFICATIVO
        // ======================================

        probar_multiplicacion(
            32'h80000000,
            32'd2
        );


        // ======================================
        // PRUEBA 9: MAXIMO POR MAXIMO
        // ======================================

        probar_multiplicacion(
            32'hFFFFFFFF,
            32'hFFFFFFFF
        );


        // ======================================
        // PRUEBA 10: DOS VALORES ARBITRARIOS
        // ======================================

        probar_multiplicacion(
            32'd123456,
            32'd789
        );


        // ======================================
        // 6. RESULTADO FINAL
        // ======================================

        $display(
            "PASS: Todas las %0d pruebas de M6 superadas.",
            pruebas
        );

        $finish;

    end

endmodule
