module controlador_multiplicador (
    input  clk, 
    input  reset, 
    
    // Entradas que dictan las transiciones
    input  start,
    input  bit_multiplicador,
    input  iteraciones_completas,
    
    // Salidas hacia el Datapath
    output cargar_operandos,
    output desplazar_multiplicando,
    output desplazar_multiplicador,
    output limpiar_producto,
    output sumar_producto,
    output limpiar_contador,
    output incrementar_contador
);

   reg [2:0] state, nextstate;

   // Codificación Binaria de los 5 estados
   parameter IDLE  = 3'b000;
   parameter INIT  = 3'b001;
   parameter EVAL  = 3'b010;
   parameter ADD   = 3'b011;
   parameter SHIFT = 3'b100;

   // 1. Registro de Estado (Secuencial)
   always @(posedge clk or posedge reset) begin
      if (reset) state <= IDLE;
      else       state <= nextstate;
   end

   // 2. Lógica del Siguiente Estado (Combinacional)
   always @(*) begin
      case (state)
         IDLE: 
            if (start) nextstate = INIT;
            else       nextstate = IDLE;
            
         INIT: 
            nextstate = EVAL; // Transición incondicional
            
         EVAL: 
            if (bit_multiplicador) nextstate = ADD;
            else                   nextstate = SHIFT;
            
         ADD:  
            nextstate = SHIFT; // Transición incondicional
            
         SHIFT: 
            if (iteraciones_completas) nextstate = IDLE;
            else                       nextstate = EVAL;
            
         default: 
            nextstate = IDLE;
      endcase
   end

   // 3. Lógica de Salidas (Moore pura: solo dependen del estado actual)
   assign cargar_operandos        = (state == INIT);
   assign limpiar_producto        = (state == INIT);
   assign limpiar_contador        = (state == INIT);
   
   assign sumar_producto          = (state == ADD);
   
   assign desplazar_multiplicando = (state == SHIFT);
   assign desplazar_multiplicador = (state == SHIFT);
   assign incrementar_contador    = (state == SHIFT);

endmodule