
`timescale 1ns/1ps

module m2_registro_multiplicador (
    input  logic        clk,
    input  logic        rst,
    input  logic        cargar,
    input  logic        desplazar,
    input  logic [31:0] multiplicador_in,
    output logic [31:0] multiplicador_out,
    output logic        bit_multiplicador
);

    // Registro de 32 bits
    always_ff @(posedge clk) begin

        if (rst) begin
            multiplicador_out <= 32'b0;
        end

        else if (cargar) begin
            multiplicador_out <= multiplicador_in;
        end

        else if (desplazar) begin
            multiplicador_out <= multiplicador_out >> 1;
        end

    end

    // Bit menos significativo del multiplicador
    assign bit_multiplicador = multiplicador_out[0];

endmodule
