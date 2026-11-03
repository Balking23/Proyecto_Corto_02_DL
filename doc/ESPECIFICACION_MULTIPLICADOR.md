
# Especificación funcional del multiplicador

**Proyecto:** Proyecto Corto 02 – Diseño de Sistemas Digitales  
**Responsable:** Persona 1 – Datapath del multiplicador  
**Lenguaje:** SystemVerilog  
**Estado:** En revisión

## 1. Objetivo

Diseñar e implementar un multiplicador binario secuencial mediante el algoritmo de suma y desplazamiento (Shift-and-Add), utilizando una arquitectura modular.

El sistema deberá realizar multiplicaciones entre dos operandos binarios sin signo de 32 bits, generando un producto de 64 bits.

La arquitectura deberá corresponder al diseño presentado en el Proyecto Corto 02 y en el capítulo 3 del libro de Patterson y Hennessy.

## 2. Descripción funcional

El multiplicador utilizará registros para almacenar los operandos y el producto parcial.

La multiplicación se desarrollará de manera iterativa, examinando un bit del multiplicador en cada iteración.

Cuando el bit examinado sea 1, se sumará el multiplicando desplazado al producto parcial.

Cuando el bit sea 0, no se modificará el producto parcial.

Este procedimiento se repetirá durante 32 iteraciones.

## 3. Entradas y salidas

### Entradas funcionales

- Multiplicando: 32 bits sin signo.
- Multiplicador: 32 bits sin signo.
- Solicitud de inicio de operación.
- Reloj del sistema.
- Señal de reinicio.

### Salidas funcionales

- Producto de 64 bits.
- Indicador de finalización de la operación.

Los nombres y el comportamiento exacto de las señales de control se definirán durante la arquitectura.

## 4. Algoritmo de multiplicación

1. Cargar el multiplicando de 32 bits en un registro de 64 bits, extendiéndolo con ceros.
2. Cargar el multiplicador en un registro de 32 bits.
3. Inicializar el registro del producto parcial en cero.
4. Examinar el bit menos significativo del multiplicador.
5. Si el bit es 1, sumar el multiplicando al producto parcial.
6. Si el bit es 0, conservar el producto parcial.
7. Desplazar el multiplicando una posición hacia la izquierda.
8. Desplazar el multiplicador una posición hacia la derecha.
9. Incrementar el número de iteraciones completadas.
10. Repetir hasta completar 32 iteraciones.
11. Presentar el producto final e indicar la finalización.

## 5. Requisitos funcionales

| ID | Requisito |
|---|---|
| RF01 | Aceptar dos operandos sin signo de 32 bits. |
| RF02 | Generar un producto completo de 64 bits. |
| RF03 | Inicializar el producto parcial en cero. |
| RF04 | Realizar sumas condicionales según el bit menos significativo del multiplicador. |
| RF05 | Ejecutar los desplazamientos correspondientes en cada iteración. |
| RF06 | Completar exactamente 32 iteraciones. |
| RF07 | Conservar el producto final hasta una nueva operación o reinicio. |
| RF08 | Permitir la verificación mediante simulaciones y bancos de prueba. |

El requisito RF07 es una decisión de diseño propuesta y deberá confirmarse con el responsable del controlador.

## 6. Comportamiento esperado

El sistema tendrá cuatro fases funcionales:

### Espera

Permanece disponible para recibir una nueva operación.

### Inicialización

Carga los operandos e inicializa los registros necesarios.

### Procesamiento

Ejecuta las sumas condicionales, los desplazamientos y las iteraciones del algoritmo.

### Finalización

Presenta el producto calculado y señala que la operación terminó.

## 7. Casos de verificación

| Multiplicando | Multiplicador | Producto esperado |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 25 | 0 |
| 25 | 0 | 0 |
| 1 | 27 | 27 |
| 3 | 5 | 15 |
| 15 | 15 | 225 |
| 4294967295 | 2 | 8589934590 |
| 4294967295 | 4294967295 | 18446744065119617025 |

También se comprobará:

- La correcta inicialización de los registros.
- La ejecución de 32 iteraciones.
- Los desplazamientos del multiplicando y multiplicador.
- El almacenamiento del producto parcial.
- La estabilidad del resultado final.

## 8. Restricciones

- El diseño se implementará en SystemVerilog.
- Se utilizará una arquitectura modular.
- El multiplicador deberá seguir el algoritmo iterativo del libro.
- No se sustituirá el algoritmo por una única operación de multiplicación directa.
- Se desarrollarán testbenches independientes.
- Se analizarán formas de onda mediante simulación.
- No se requiere una implementación física del circuito.

## 9. Decisiones de diseño

### Confirmadas

- Operandos sin signo de 32 bits.
- Producto de 64 bits.
- Algoritmo Shift-and-Add.
- Ejecución de 32 iteraciones.

### Pendientes de aprobación

- Tipo y polaridad del reinicio.
- Señales de control del datapath.
- Protocolo de inicio y finalización.
- Comunicación con la FSM.
- Tratamiento de nuevas operaciones durante el procesamiento.

## 10. Referencias

- Proyecto Corto 02, páginas 1, 3 y 4.
- Patterson y Hennessy, Computer Organization and Design: RISC-V Edition, segunda edición.
- Capítulo 3, sección 3.3, figuras 3.3 y 3.4.
