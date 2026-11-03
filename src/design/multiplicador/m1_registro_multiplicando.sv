`timescale 1ns/1ps
module m1_registro_multiplicando (
    input  logic        clk,
    input  logic        rst,
    input  logic        cargar,
    input  logic        desplazar,
    input  logic [31:0] multiplicando_in,
    output logic [63:0] multiplicando_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            multiplicando_out <= 64'b0;
        end
        else if (cargar) begin
            multiplicando_out <= {32'b0, multiplicando_in};
        end
        else if (desplazar) begin
            multiplicando_out <= multiplicando_out << 1;
        end
    end

endmodule
