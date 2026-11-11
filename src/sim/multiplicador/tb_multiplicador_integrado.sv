`timescale 1ns/1ps

module tb_top_multiplicador();

    // 1. Declaración de señales
    logic clk;
    logic rst;
    logic start;
    logic [31:0] A_in;
    logic [31:0] B_in;
    
    logic listo; // Si agregaste una señal de DONE (opcional)
    logic [63:0] producto_out;

    // 2. Instanciación del TOP (Caja Negra)
    // Este módulo conecta internamente tu datapath y el controlador
    top_multiplicador UUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .multiplicando_in(A_in),
        .multiplicador_in(B_in),
        .producto_out(producto_out)
    );

    // 3. Generación del Reloj (Periodo de 10ns)
    always #5 clk = ~clk;

    // 4. Tarea de automatización de pruebas
    task probar_multiplicacion(
        input [31:0] operando_a,
        input [31:0] operando_b
    );
        logic [63:0] resultado_esperado;
        begin
            resultado_esperado = operando_a * operando_b; // Referencia matemática ideal
            
            // Aplicar entradas
            A_in = operando_a;
            B_in = operando_b;
            
            // Generar pulso de Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Esperar los 32+ ciclos de arquitectura (o esperar señal 'listo' si existe)
            // Como sabemos que la arquitectura shift-and-add toma aprox 34-65 ciclos:
            repeat(110) @(posedge clk); 
            
            // Comprobación automática
            if (producto_out === resultado_esperado) begin
                $display("[EXITO] %d x %d = %d", operando_a, operando_b, producto_out);
            end else begin
                $display("[ERROR] %d x %d. Esperado: %d, Obtenido: %d", 
                         operando_a, operando_b, resultado_esperado, producto_out);
            end
        end
    endtask

    // 5. Ejecución del Plan de Pruebas
    initial begin
        // Inicialización
        clk = 0;
        start = 0;
        A_in = 0;
        B_in = 0;
        
        // Reset del sistema
        rst = 1;
        #20;
        rst = 0;
        #20;

        $display("--- INICIANDO BATERIA DE PRUEBAS ---");

        // Caso 1: Multiplicación por cero
        probar_multiplicacion(32'd0, 32'd500);
        probar_multiplicacion(32'd42, 32'd0);
        probar_multiplicacion(32'd0, 32'd0);

        // Caso 2: Multiplicación por uno (Identidad)
        probar_multiplicacion(32'd1, 32'd999);
        probar_multiplicacion(32'd854, 32'd1);

        // Caso 3: Operaciones típicas
        probar_multiplicacion(32'd15, 32'd3);
        probar_multiplicacion(32'hAAAAAAAA, 32'h55555555); // Patrones alternados

        // Caso 4: Valores máximos (Edge case)
        probar_multiplicacion(32'hFFFFFFFF, 32'hFFFFFFFF); 

        $display("--- PRUEBAS FINALIZADAS ---");
        $finish;
    end

endmodule