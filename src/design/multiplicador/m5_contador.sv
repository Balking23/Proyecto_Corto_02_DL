
`timescale 1ns/1ps

module m5_contador (
    input  logic       clk,
    input  logic       rst,
    input  logic       limpiar,
    input  logic       incrementar,
    output logic [5:0] cuenta_out,
    output logic       iteraciones_completas
);

    // ==========================================
    // Contador secuencial de 0 a 32
    // ==========================================

    always_ff @(posedge clk) begin

        // Prioridad 1: Reinicio general
        if (rst) begin
            cuenta_out <= 6'd0;
        end

        // Prioridad 2: Limpiar contador
        else if (limpiar) begin
            cuenta_out <= 6'd0;
        end

        // Prioridad 3: Incrementar
        else if (incrementar && cuenta_out < 6'd32) begin
            cuenta_out <= cuenta_out + 6'd1;
        end

        // Sin habilitacion:
        // Conserva el valor almacenado

    end

    // Señal de finalizacion
    assign iteraciones_completas = (cuenta_out == 6'd32);

endmodule
