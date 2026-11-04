
`timescale 1ns/1ps

module m3_registro_producto (
    input  logic        clk,
    input  logic        rst,
    input  logic        limpiar,
    input  logic        escribir,
    input  logic [63:0] suma_in,
    output logic [63:0] producto_out
);

    // Registro del producto parcial de 64 bits
    always_ff @(posedge clk) begin

        // Prioridad 1: Reinicio general
        if (rst) begin
            producto_out <= 64'b0;
        end

        // Prioridad 2: Limpiar producto parcial
        else if (limpiar) begin
            producto_out <= 64'b0;
        end

        // Prioridad 3: Guardar resultado de la ALU
        else if (escribir) begin
            producto_out <= suma_in;
        end

        // Sin habilitacion:
        // el registro conserva su valor

    end

endmodule
