`timescale 1ns/1ps

module m4_sumador (
    input  logic [63:0] multiplicando_in,
    input  logic [63:0] producto_in,
    output logic [63:0] suma_out
);

    // Suma combinacional de 64 bits
    always_comb begin
        suma_out = multiplicando_in + producto_in;
    end

endmodule
