module keyboard_interface (
    input wire clk,                   // System clock
    input wire reset,                 // System reset
    input wire mosi,                  // SPI Master Out Slave In
    input wire sck,                   // SPI clock
    input wire csn,                   // SPI chip select
    input wire irq,                   // Interrupt request (not used in this example)
    output reg [11:0] cursor_pos,     // Cursor position (row and column)
    output reg [15:0] vram_addr,      // Address for video RAM
    output reg [7:0] vram_data,       // Data to be written to video RAM
    output reg printable              // Write enable signal for video RAM
);

    // SPI receiver signals
    wire [7:0] spi_data;              // Přijatá SPI data
    wire spi_data_ready;              // Příznak připravenosti přijatých dat

    // Constants for screen dimensions
    localparam SCREEN_WIDTH = 80;     // Šířka obrazovky v znacích
    localparam SCREEN_HEIGHT = 30;    // Výška obrazovky v znacích

    // FSM states
    typedef enum logic [1:0] {
        IDLE,                         // Klidový stav
        RECEIVE,                      // Příjem dat
        PROCESS                       // Zpracování dat
    } state_t;
    state_t current_state, next_state; // Aktuální stav a další stav FSM


    // Cursor control
    reg [11:0] current_pos;           // Aktuální pozice kurzoru
    reg [7:0] current_char;           // Aktuální znak

    // VRAM control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;    // Při resetu přejít do stavu IDLE
            cursor_pos <= 12'b0;      // Při resetu nastavit kurzor na počáteční pozici
            current_pos <= 12'b0;     // Při resetu nastavit aktuální pozici na počáteční
            printable <= 1'b0;        // Při resetu zakázat zápis do video paměti
        end else begin
            current_state <= next_state; // Přechod do dalšího stavu FSM

            case (current_state)
                IDLE: begin
                    printable <= 1'b0; // Zakázat zápis do video paměti
                    if (spi_data_ready) begin
                        next_state = RECEIVE; // Pokud jsou data připravena, přejít do stavu RECEIVE
                    end
                end

                RECEIVE: begin
                    current_char <= spi_data; // Uložit přijatá data jako aktuální znak
                    next_state = PROCESS;     // Přechod do stavu PROCESS
                end

                PROCESS: begin
                    case (current_char)
                        8'h0D: begin  // Znak Enter
                            // Přesunout kurzor na nový řádek
                            current_pos <= {current_pos[11:8] + 1, 8'b0};
                            if (current_pos[11:8] == (SCREEN_HEIGHT - 1)) begin
                                current_pos <= 12'b0; // Pokud je na posledním řádku, vrátit kurzor na začátek
                            end
                            printable <= 1'b0; // Zakázat zápis do video paměti
                        end

                        8'h08: begin  // Znak Backspace
                            // Přesunout kurzor zpět a smazat znak
                            if (current_pos[7:0] > 0) begin
                                current_pos <= current_pos - 1; // Přesunout kurzor zpět o jednu pozici
                                vram_data <= 8'h20; // Nastavit znak na mezeru
                                printable <= 1'b1; // Povolit zápis do video paměti
                            end else begin
                                printable <= 1'b0; // Zakázat zápis do video paměti
                            end
                        end

                        default: begin
                            // Tisknutelné ASCII znaky
                            if (current_char >= 32 && current_char <= 126) begin
                                vram_data <= current_char; // Nastavit data pro zápis jako aktuální znak
                                printable <= 1'b1; // Povolit zápis do video paměti
                                if (current_pos[7:0] == (SCREEN_WIDTH - 1)) begin
                                    current_pos <= {current_pos[11:8] + 1, 8'b0}; // Přesunout kurzor na nový řádek
                                end else begin
                                    current_pos <= current_pos + 1; // Přesunout kurzor o jednu pozici doprava
                                end
                            end else begin
                                printable <= 1'b0; // Zakázat zápis do video paměti
                            end
                        end
                    endcase
                    cursor_pos <= current_pos; // Aktualizovat pozici kurzoru
                    vram_addr <= current_pos;  // Nastavit aktuální pozici jako adresu pro zápis do VRAM
                    next_state = IDLE;         // Přechod do stavu IDLE
                end
            endcase
        end
    end

endmodule
