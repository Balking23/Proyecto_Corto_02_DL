`timescale 1ns/1ps

module multiplier #(
    parameter WIDTH = 32 // Parametrización base
)(
    // Puertos externos escalables
    input  logic               clk,
    input  logic               rst,
    input  logic               start,
    input  logic [WIDTH-1:0]   multiplicando_in,
    input  logic [WIDTH-1:0]   multiplicador_in,
    
    output logic [(WIDTH*2)-1:0] producto_out
);

    // ==========================================
    // 1. Cables internos de interconexión
    // ==========================================
    logic cargar_operandos;
    logic desplazar_multiplicando;
    logic desplazar_multiplicador;
    logic limpiar_producto;
    logic sumar_producto;
    logic limpiar_contador;
    logic incrementar_contador;
    
    logic bit_multiplicador;
    logic iteraciones_completas;

    // ==========================================
    // 2. Cerebro (Controlador) - No requiere WIDTH
    // ==========================================
    // La máquina de estados no maneja datos, solo señales de control.
    // Su lógica es idéntica sin importar si son 8, 32 o 64 bits.
    controlador_multiplicador u_controlador (
        .clk(clk),
        .reset(rst), 
        .start(start),
        .bit_multiplicador(bit_multiplicador),
        .iteraciones_completas(iteraciones_completas),
        
        .cargar_operandos(cargar_operandos),
        .desplazar_multiplicando(desplazar_multiplicando),
        .desplazar_multiplicador(desplazar_multiplicador),
        .limpiar_producto(limpiar_producto),
        .sumar_producto(sumar_producto),
        .limpiar_contador(limpiar_contador),
        .incrementar_contador(incrementar_contador)
    );

    // ==========================================
    // 3. Músculo (Datapath) - Recibe el parámetro WIDTH
    // ==========================================
    m6_datapath_multiplicador #(
        .WIDTH(WIDTH) // Aquí pasas el tamaño hacia los sub-módulos
    ) u_datapath (
        .clk(clk),
        .rst(rst),
        .multiplicando_in(multiplicando_in),
        .multiplicador_in(multiplicador_in),
        
        .cargar_operandos(cargar_operandos),
        .desplazar_multiplicando(desplazar_multiplicando),
        .desplazar_multiplicador(desplazar_multiplicador),
        .limpiar_producto(limpiar_producto),
        .sumar_producto(sumar_producto),
        .limpiar_contador(limpiar_contador),
        .incrementar_contador(incrementar_contador),
        
        .bit_multiplicador(bit_multiplicador),
        .iteraciones_completas(iteraciones_completas),
        .producto_out(producto_out)
    );

endmodule