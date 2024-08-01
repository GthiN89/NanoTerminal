module keyboard_interface (
    input wire clk,                   // Systémový hodinový signál
    input wire reset,                 // Signál resetu systému
    input wire enable,        // Strobe signál pro HID z mcu_spi
    input wire [7:0] spi_in_data,     // Data z SPI
    output reg [15:0] vram_addr,      // Adresa pro video RAM
    output reg [7:0] vram_data,       // Data k zápisu do video RAM
    output reg printable,             // Signál povolení zápisu do video RAM
    input reg [6:0] x,
    input reg [4:0] y,
    output  cursor_active
);
    reg [6:0] cursor_x;
    reg [4:0] cursor_y;
    reg printable;
    reg [7:0] vram_data;
    reg [15:0] vram_addr;
    reg default_executed;

    // Konstanty pro rozměry obrazovky
    localparam SCREEN_WIDTH = 80;     // Šířka obrazovky v počtu znaků
    localparam SCREEN_HEIGHT = 30;    // Výška obrazovky v počtu znaků

    // FSM stavy
    typedef enum logic [1:0] {
        STATE_INIT,                   // Inicializační stav
        STATE_WAIT_CMD,               // Čekání na příkaz
        STATE_WRITE_TEXT,             // Zápis textu
        STATE_SCREEN_FULL             // Obrazovka je plná
    } state_t;
    state_t current_state ; // Proměnné pro aktuální a další stav FSM

    // Proměnné pro kontrolu kurzoru a znaků
    reg [7:0] current_char;           // Aktuální znak
    reg [7:0] prev_char;              // Předchozí znak (pro detekci uvolnění klávesy)
    reg [7:0] idx;                    // Index znaku
    reg done_flag;                    // Příznak dokončení
    reg full;                         // Příznak plné obrazovky

    // Maximální hodnoty
    localparam maxcol = SCREEN_WIDTH - 1;
    localparam maxlin = SCREEN_HEIGHT - 1;

    wire cursor_active = (cursor_x == x) && (cursor_y == y); 
 
    // Řízení VRAM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cursor_x <= 0;            // Reset pozice kurzoru na sloupci
            cursor_y <= 0;            // Reset pozice kurzoru na řádku
            idx <= 0;                 // Reset indexu
            current_state <= STATE_INIT; // Inicializační stav
            full <= 0;                // Reset plného stavu
        end else begin
            case (current_state)
                STATE_INIT: begin
                    current_state <= STATE_WAIT_CMD; // Po inicializaci přejde do čekacího stavu
                end

                STATE_WAIT_CMD: begin
                    printable <= 0;               // Zakázání zápisu
                    default_executed <=0;
             //       current_char <= 0;   
                    if (enable) begin        // Kontrola strobe signálu
                        current_char <= spi_in_data; // Uložení přijatého znaku
                        current_state <= STATE_WRITE_TEXT; // Přechod do stavu zápisu textu
                    end
                end

                STATE_WRITE_TEXT: begin
                    // Zabránění opakování znaku, pokud nebyl uvolněn

                        vram_addr <= {cursor_y, cursor_x}; // Nastavení adresy pro VRAM

                      //  prev_char <= current_char;         // Aktualizace předchozího znaku
                        idx <= idx + 1;                    // Zvýšení indexu


                           if(current_char == 8'h1c) begin
                              if(cursor_y > 0) begin
                                 printable <= 0;
                                 cursor_y <= cursor_y - 1;
                                 current_state <= STATE_WAIT_CMD; // Návrat do čekacího stavu
                              end
                              end
                             if(current_char ==  8'h4c) begin
                              if(cursor_y < maxlin) begin
                                 printable <= 0;
                                 cursor_y <= cursor_y + 1;
                                 current_state <= STATE_WAIT_CMD; // Návrat do čekacího stavu
                              end
                              end
                             if(current_char == 8'h3c) begin
                              if(cursor_x > 0) begin
                                 printable <= 0;
                                 cursor_x <= cursor_x - 1;
                                 current_state <= STATE_WAIT_CMD; // Návrat do čekacího stavu
                              end
                              end
                             if(current_char ==  8'h5c) begin
                              if(cursor_x < maxcol) begin
                                 printable <= 0;
                                 cursor_x <= cursor_x + 1;
                                 current_state <= STATE_WAIT_CMD; // Návrat do čekacího stavu
                              end
                              end else begin // Výchozí případ pro povolení zápisu

                            printable <= 1;                 
                            vram_data <= current_char;         
                            cursor_x <= cursor_x + 1;
                            default_executed <= 1; // Nastavit flag, že default proběhl
                            current_state <= STATE_WAIT_CMD; // Návrat do čekacího stavu

                              end
                                          
                              


                        end
//                    end
            endcase
        end
    end

endmodule
