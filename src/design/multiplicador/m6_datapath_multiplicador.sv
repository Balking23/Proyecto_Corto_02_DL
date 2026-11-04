`timescale 1ns/1ps

module m6_datapath_multiplicador (

    // Reloj y reinicio
    input  logic        clk,
    input  logic        rst,

    // Operand os de entrada
    input  logic [31:0] multiplicando_in,
    input  logic [31:0] multiplicador_in,

    // Señales del controlador
    input  logic        cargar_operandos,
    input  logic        desplazar_multiplicando,
    input  logic        desplazar_multiplicador,
    input  logic        limpiar_producto,
    input  logic        sumar_producto,
    input  logic        limpiar_contador,
    input  logic        incrementar_contador,

    // Salidas hacia el controlador
    output logic        bit_multiplicador,
    output logic        iteraciones_completas,

    // Resultado
    output logic [63:0] producto_out

);

    // ==========================================
    // 1. Señales internas
    // ==========================================

    logic [63:0] multiplicando_reg;
    logic [31:0] multiplicador_reg;
    logic [63:0] suma_alu;
    logic [5:0]  cuenta_iteraciones;


    // ==========================================
    // 2. M1 - Registro del multiplicando
    // ==========================================

    m1_registro_multiplicando u_m1 (
        .clk(clk),
        .rst(rst),
        .cargar(cargar_operandos),
        .desplazar(desplazar_multiplicando),
        .multiplicando_in(multiplicando_in),
        .multiplicando_out(multiplicando_reg)
    );


    // ==========================================
    // 3. M2 - Registro del multiplicador
    // ==========================================

    m2_registro_multiplicador u_m2 (
        .clk(clk),
        .rst(rst),
        .cargar(cargar_operandos),
        .desplazar(desplazar_multiplicador),
        .multiplicador_in(multiplicador_in),
        .multiplicador_out(multiplicador_reg),
        .bit_multiplicador(bit_multiplicador)
    );


    // ==========================================
    // 4. M3 - Registro del producto
    // ==========================================

    m3_registro_producto u_m3 (
        .clk(clk),
        .rst(rst),
        .limpiar(limpiar_producto),
        .escribir(sumar_producto),
        .suma_in(suma_alu),
        .producto_out(producto_out)
    );


    // ==========================================
    // 5. M4 - Sumador combinacional
    // ==========================================

    m4_sumador u_m4 (
        .multiplicando_in(multiplicando_reg),
        .producto_in(producto_out),
        .suma_out(suma_alu)
    );


    // ==========================================
    // 6. M5 - Contador de iteraciones
    // ==========================================

    m5_contador u_m5 (
        .clk(clk),
        .rst(rst),
        .limpiar(limpiar_contador),
        .incrementar(incrementar_contador),
        .cuenta_out(cuenta_iteraciones),
        .iteraciones_completas(iteraciones_completas)
    );

endmodule
