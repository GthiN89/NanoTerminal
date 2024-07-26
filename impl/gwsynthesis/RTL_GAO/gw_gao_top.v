module gw_gao(
    \uart_top/tx_cnt[4] ,
    \uart_top/tx_cnt[3] ,
    \uart_top/tx_cnt[2] ,
    \uart_top/tx_cnt[1] ,
    \uart_top/tx_cnt[0] ,
    \uart_top/command_index[7] ,
    \uart_top/command_index[6] ,
    \uart_top/command_index[5] ,
    \uart_top/command_index[4] ,
    \uart_top/command_index[3] ,
    \uart_top/command_index[2] ,
    \uart_top/command_index[1] ,
    \uart_top/command_index[0] ,
    \uart_top/rx_data[7] ,
    \uart_top/rx_data[6] ,
    \uart_top/rx_data[5] ,
    \uart_top/rx_data[4] ,
    \uart_top/rx_data[3] ,
    \uart_top/rx_data[2] ,
    \uart_top/rx_data[1] ,
    \uart_top/rx_data[0] ,
    \text_to_VGA/o_address[12] ,
    \text_to_VGA/o_address[11] ,
    \text_to_VGA/o_address[10] ,
    \text_to_VGA/o_address[9] ,
    \text_to_VGA/o_address[8] ,
    \text_to_VGA/o_address[7] ,
    \text_to_VGA/o_address[6] ,
    \text_to_VGA/o_address[5] ,
    \text_to_VGA/o_address[4] ,
    \text_to_VGA/o_address[3] ,
    \text_to_VGA/o_address[2] ,
    \text_to_VGA/o_address[1] ,
    \text_to_VGA/o_address[0] ,
    \text_to_VGA/o_data[7] ,
    \text_to_VGA/o_data[6] ,
    \text_to_VGA/o_data[5] ,
    \text_to_VGA/o_data[4] ,
    \text_to_VGA/o_data[3] ,
    \text_to_VGA/o_data[2] ,
    \text_to_VGA/o_data[1] ,
    \text_to_VGA/o_data[0] ,
    \text_to_VGA/idx[6] ,
    \text_to_VGA/idx[5] ,
    \text_to_VGA/idx[4] ,
    \text_to_VGA/idx[3] ,
    \text_to_VGA/idx[2] ,
    \text_to_VGA/idx[1] ,
    \text_to_VGA/idx[0] ,
    \text_to_VGA/col[6] ,
    \text_to_VGA/col[5] ,
    \text_to_VGA/col[4] ,
    \text_to_VGA/col[3] ,
    \text_to_VGA/col[2] ,
    \text_to_VGA/col[1] ,
    \text_to_VGA/col[0] ,
    \text_to_VGA/lin[4] ,
    \text_to_VGA/lin[3] ,
    \text_to_VGA/lin[2] ,
    \text_to_VGA/lin[1] ,
    \text_to_VGA/lin[0] ,
    \text_to_VGA/counter[4] ,
    \text_to_VGA/counter[3] ,
    \text_to_VGA/counter[2] ,
    \text_to_VGA/counter[1] ,
    \text_to_VGA/counter[0] ,
    \text_to_VGA/state[1] ,
    \text_to_VGA/state[0] ,
    \text_to_VGA/init_idx[6] ,
    \text_to_VGA/init_idx[5] ,
    \text_to_VGA/init_idx[4] ,
    \text_to_VGA/init_idx[3] ,
    \text_to_VGA/init_idx[2] ,
    \text_to_VGA/init_idx[1] ,
    \text_to_VGA/init_idx[0] ,
    \text_to_VGA/next_lin[4] ,
    \text_to_VGA/next_lin[3] ,
    \text_to_VGA/next_lin[2] ,
    \text_to_VGA/next_lin[1] ,
    \text_to_VGA/next_lin[0] ,
    \text_to_VGA/next_idx[6] ,
    \text_to_VGA/next_idx[5] ,
    \text_to_VGA/next_idx[4] ,
    \text_to_VGA/next_idx[3] ,
    \text_to_VGA/next_idx[2] ,
    \text_to_VGA/next_idx[1] ,
    \text_to_VGA/next_idx[0] ,
    \charbuf/doutb[7] ,
    \charbuf/doutb[6] ,
    \charbuf/doutb[5] ,
    \charbuf/doutb[4] ,
    \charbuf/doutb[3] ,
    \charbuf/doutb[2] ,
    \charbuf/doutb[1] ,
    \charbuf/doutb[0] ,
    \charbuf/ada[11] ,
    \charbuf/ada[10] ,
    \charbuf/ada[9] ,
    \charbuf/ada[8] ,
    \charbuf/ada[7] ,
    \charbuf/ada[6] ,
    \charbuf/ada[5] ,
    \charbuf/ada[4] ,
    \charbuf/ada[3] ,
    \charbuf/ada[2] ,
    \charbuf/ada[1] ,
    \charbuf/ada[0] ,
    \charbuf/dina[7] ,
    \charbuf/dina[6] ,
    \charbuf/dina[5] ,
    \charbuf/dina[4] ,
    \charbuf/dina[3] ,
    \charbuf/dina[2] ,
    \charbuf/dina[1] ,
    \charbuf/dina[0] ,
    \charbuf/adb[11] ,
    \charbuf/adb[10] ,
    \charbuf/adb[9] ,
    \charbuf/adb[8] ,
    \charbuf/adb[7] ,
    \charbuf/adb[6] ,
    \charbuf/adb[5] ,
    \charbuf/adb[4] ,
    \charbuf/adb[3] ,
    \charbuf/adb[2] ,
    \charbuf/adb[1] ,
    \charbuf/adb[0] ,
    \uart_top/command_buffer[157][7] ,
    \uart_top/command_buffer[157][6] ,
    \uart_top/command_buffer[157][5] ,
    \uart_top/command_buffer[157][4] ,
    \uart_top/command_buffer[157][3] ,
    \uart_top/command_buffer[157][2] ,
    \uart_top/command_buffer[157][1] ,
    \uart_top/command_buffer[157][0] ,
    \uart_top/output_command[5][7] ,
    \uart_top/output_command[5][6] ,
    \uart_top/output_command[5][5] ,
    \uart_top/output_command[5][4] ,
    \uart_top/output_command[5][3] ,
    \uart_top/output_command[5][2] ,
    \uart_top/output_command[5][1] ,
    \uart_top/output_command[5][0] ,
    \uart_top/output_command[4][7] ,
    \uart_top/output_command[4][6] ,
    \uart_top/output_command[4][5] ,
    \uart_top/output_command[4][4] ,
    \uart_top/output_command[4][3] ,
    \uart_top/output_command[4][2] ,
    \uart_top/output_command[4][1] ,
    \uart_top/output_command[4][0] ,
    \uart_top/output_command[3][7] ,
    \uart_top/output_command[3][6] ,
    \uart_top/output_command[3][5] ,
    \uart_top/output_command[3][4] ,
    \uart_top/output_command[3][3] ,
    \uart_top/output_command[3][2] ,
    \uart_top/output_command[3][1] ,
    \uart_top/output_command[3][0] ,
    \uart_top/output_command[2][7] ,
    \uart_top/output_command[2][6] ,
    \uart_top/output_command[2][5] ,
    \uart_top/output_command[2][4] ,
    \uart_top/output_command[2][3] ,
    \uart_top/output_command[2][2] ,
    \uart_top/output_command[2][1] ,
    \uart_top/output_command[2][0] ,
    \uart_top/output_command[1][7] ,
    \uart_top/output_command[1][6] ,
    \uart_top/output_command[1][5] ,
    \uart_top/output_command[1][4] ,
    \uart_top/output_command[1][3] ,
    \uart_top/output_command[1][2] ,
    \uart_top/output_command[1][1] ,
    \uart_top/output_command[1][0] ,
    \uart_top/output_command[0][7] ,
    \uart_top/output_command[0][6] ,
    \uart_top/output_command[0][5] ,
    \uart_top/output_command[0][4] ,
    \uart_top/output_command[0][3] ,
    \uart_top/output_command[0][2] ,
    \uart_top/output_command[0][1] ,
    \uart_top/output_command[0][0] ,
    \uart_top/state[1] ,
    \uart_top/state[0] ,
    \uart_top/tx_data[7] ,
    \uart_top/tx_data[6] ,
    \uart_top/tx_data[5] ,
    \uart_top/tx_data[4] ,
    \uart_top/tx_data[3] ,
    \uart_top/tx_data[2] ,
    \uart_top/tx_data[1] ,
    \uart_top/tx_data[0] ,
    \uart_top/prompt_cnt[5] ,
    \uart_top/prompt_cnt[4] ,
    \uart_top/prompt_cnt[3] ,
    \uart_top/prompt_cnt[2] ,
    \uart_top/prompt_cnt[1] ,
    \uart_top/prompt_cnt[0] ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \uart_top/tx_cnt[4] ;
input \uart_top/tx_cnt[3] ;
input \uart_top/tx_cnt[2] ;
input \uart_top/tx_cnt[1] ;
input \uart_top/tx_cnt[0] ;
input \uart_top/command_index[7] ;
input \uart_top/command_index[6] ;
input \uart_top/command_index[5] ;
input \uart_top/command_index[4] ;
input \uart_top/command_index[3] ;
input \uart_top/command_index[2] ;
input \uart_top/command_index[1] ;
input \uart_top/command_index[0] ;
input \uart_top/rx_data[7] ;
input \uart_top/rx_data[6] ;
input \uart_top/rx_data[5] ;
input \uart_top/rx_data[4] ;
input \uart_top/rx_data[3] ;
input \uart_top/rx_data[2] ;
input \uart_top/rx_data[1] ;
input \uart_top/rx_data[0] ;
input \text_to_VGA/o_address[12] ;
input \text_to_VGA/o_address[11] ;
input \text_to_VGA/o_address[10] ;
input \text_to_VGA/o_address[9] ;
input \text_to_VGA/o_address[8] ;
input \text_to_VGA/o_address[7] ;
input \text_to_VGA/o_address[6] ;
input \text_to_VGA/o_address[5] ;
input \text_to_VGA/o_address[4] ;
input \text_to_VGA/o_address[3] ;
input \text_to_VGA/o_address[2] ;
input \text_to_VGA/o_address[1] ;
input \text_to_VGA/o_address[0] ;
input \text_to_VGA/o_data[7] ;
input \text_to_VGA/o_data[6] ;
input \text_to_VGA/o_data[5] ;
input \text_to_VGA/o_data[4] ;
input \text_to_VGA/o_data[3] ;
input \text_to_VGA/o_data[2] ;
input \text_to_VGA/o_data[1] ;
input \text_to_VGA/o_data[0] ;
input \text_to_VGA/idx[6] ;
input \text_to_VGA/idx[5] ;
input \text_to_VGA/idx[4] ;
input \text_to_VGA/idx[3] ;
input \text_to_VGA/idx[2] ;
input \text_to_VGA/idx[1] ;
input \text_to_VGA/idx[0] ;
input \text_to_VGA/col[6] ;
input \text_to_VGA/col[5] ;
input \text_to_VGA/col[4] ;
input \text_to_VGA/col[3] ;
input \text_to_VGA/col[2] ;
input \text_to_VGA/col[1] ;
input \text_to_VGA/col[0] ;
input \text_to_VGA/lin[4] ;
input \text_to_VGA/lin[3] ;
input \text_to_VGA/lin[2] ;
input \text_to_VGA/lin[1] ;
input \text_to_VGA/lin[0] ;
input \text_to_VGA/counter[4] ;
input \text_to_VGA/counter[3] ;
input \text_to_VGA/counter[2] ;
input \text_to_VGA/counter[1] ;
input \text_to_VGA/counter[0] ;
input \text_to_VGA/state[1] ;
input \text_to_VGA/state[0] ;
input \text_to_VGA/init_idx[6] ;
input \text_to_VGA/init_idx[5] ;
input \text_to_VGA/init_idx[4] ;
input \text_to_VGA/init_idx[3] ;
input \text_to_VGA/init_idx[2] ;
input \text_to_VGA/init_idx[1] ;
input \text_to_VGA/init_idx[0] ;
input \text_to_VGA/next_lin[4] ;
input \text_to_VGA/next_lin[3] ;
input \text_to_VGA/next_lin[2] ;
input \text_to_VGA/next_lin[1] ;
input \text_to_VGA/next_lin[0] ;
input \text_to_VGA/next_idx[6] ;
input \text_to_VGA/next_idx[5] ;
input \text_to_VGA/next_idx[4] ;
input \text_to_VGA/next_idx[3] ;
input \text_to_VGA/next_idx[2] ;
input \text_to_VGA/next_idx[1] ;
input \text_to_VGA/next_idx[0] ;
input \charbuf/doutb[7] ;
input \charbuf/doutb[6] ;
input \charbuf/doutb[5] ;
input \charbuf/doutb[4] ;
input \charbuf/doutb[3] ;
input \charbuf/doutb[2] ;
input \charbuf/doutb[1] ;
input \charbuf/doutb[0] ;
input \charbuf/ada[11] ;
input \charbuf/ada[10] ;
input \charbuf/ada[9] ;
input \charbuf/ada[8] ;
input \charbuf/ada[7] ;
input \charbuf/ada[6] ;
input \charbuf/ada[5] ;
input \charbuf/ada[4] ;
input \charbuf/ada[3] ;
input \charbuf/ada[2] ;
input \charbuf/ada[1] ;
input \charbuf/ada[0] ;
input \charbuf/dina[7] ;
input \charbuf/dina[6] ;
input \charbuf/dina[5] ;
input \charbuf/dina[4] ;
input \charbuf/dina[3] ;
input \charbuf/dina[2] ;
input \charbuf/dina[1] ;
input \charbuf/dina[0] ;
input \charbuf/adb[11] ;
input \charbuf/adb[10] ;
input \charbuf/adb[9] ;
input \charbuf/adb[8] ;
input \charbuf/adb[7] ;
input \charbuf/adb[6] ;
input \charbuf/adb[5] ;
input \charbuf/adb[4] ;
input \charbuf/adb[3] ;
input \charbuf/adb[2] ;
input \charbuf/adb[1] ;
input \charbuf/adb[0] ;
input \uart_top/command_buffer[157][7] ;
input \uart_top/command_buffer[157][6] ;
input \uart_top/command_buffer[157][5] ;
input \uart_top/command_buffer[157][4] ;
input \uart_top/command_buffer[157][3] ;
input \uart_top/command_buffer[157][2] ;
input \uart_top/command_buffer[157][1] ;
input \uart_top/command_buffer[157][0] ;
input \uart_top/output_command[5][7] ;
input \uart_top/output_command[5][6] ;
input \uart_top/output_command[5][5] ;
input \uart_top/output_command[5][4] ;
input \uart_top/output_command[5][3] ;
input \uart_top/output_command[5][2] ;
input \uart_top/output_command[5][1] ;
input \uart_top/output_command[5][0] ;
input \uart_top/output_command[4][7] ;
input \uart_top/output_command[4][6] ;
input \uart_top/output_command[4][5] ;
input \uart_top/output_command[4][4] ;
input \uart_top/output_command[4][3] ;
input \uart_top/output_command[4][2] ;
input \uart_top/output_command[4][1] ;
input \uart_top/output_command[4][0] ;
input \uart_top/output_command[3][7] ;
input \uart_top/output_command[3][6] ;
input \uart_top/output_command[3][5] ;
input \uart_top/output_command[3][4] ;
input \uart_top/output_command[3][3] ;
input \uart_top/output_command[3][2] ;
input \uart_top/output_command[3][1] ;
input \uart_top/output_command[3][0] ;
input \uart_top/output_command[2][7] ;
input \uart_top/output_command[2][6] ;
input \uart_top/output_command[2][5] ;
input \uart_top/output_command[2][4] ;
input \uart_top/output_command[2][3] ;
input \uart_top/output_command[2][2] ;
input \uart_top/output_command[2][1] ;
input \uart_top/output_command[2][0] ;
input \uart_top/output_command[1][7] ;
input \uart_top/output_command[1][6] ;
input \uart_top/output_command[1][5] ;
input \uart_top/output_command[1][4] ;
input \uart_top/output_command[1][3] ;
input \uart_top/output_command[1][2] ;
input \uart_top/output_command[1][1] ;
input \uart_top/output_command[1][0] ;
input \uart_top/output_command[0][7] ;
input \uart_top/output_command[0][6] ;
input \uart_top/output_command[0][5] ;
input \uart_top/output_command[0][4] ;
input \uart_top/output_command[0][3] ;
input \uart_top/output_command[0][2] ;
input \uart_top/output_command[0][1] ;
input \uart_top/output_command[0][0] ;
input \uart_top/state[1] ;
input \uart_top/state[0] ;
input \uart_top/tx_data[7] ;
input \uart_top/tx_data[6] ;
input \uart_top/tx_data[5] ;
input \uart_top/tx_data[4] ;
input \uart_top/tx_data[3] ;
input \uart_top/tx_data[2] ;
input \uart_top/tx_data[1] ;
input \uart_top/tx_data[0] ;
input \uart_top/prompt_cnt[5] ;
input \uart_top/prompt_cnt[4] ;
input \uart_top/prompt_cnt[3] ;
input \uart_top/prompt_cnt[2] ;
input \uart_top/prompt_cnt[1] ;
input \uart_top/prompt_cnt[0] ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \uart_top/tx_cnt[4] ;
wire \uart_top/tx_cnt[3] ;
wire \uart_top/tx_cnt[2] ;
wire \uart_top/tx_cnt[1] ;
wire \uart_top/tx_cnt[0] ;
wire \uart_top/command_index[7] ;
wire \uart_top/command_index[6] ;
wire \uart_top/command_index[5] ;
wire \uart_top/command_index[4] ;
wire \uart_top/command_index[3] ;
wire \uart_top/command_index[2] ;
wire \uart_top/command_index[1] ;
wire \uart_top/command_index[0] ;
wire \uart_top/rx_data[7] ;
wire \uart_top/rx_data[6] ;
wire \uart_top/rx_data[5] ;
wire \uart_top/rx_data[4] ;
wire \uart_top/rx_data[3] ;
wire \uart_top/rx_data[2] ;
wire \uart_top/rx_data[1] ;
wire \uart_top/rx_data[0] ;
wire \text_to_VGA/o_address[12] ;
wire \text_to_VGA/o_address[11] ;
wire \text_to_VGA/o_address[10] ;
wire \text_to_VGA/o_address[9] ;
wire \text_to_VGA/o_address[8] ;
wire \text_to_VGA/o_address[7] ;
wire \text_to_VGA/o_address[6] ;
wire \text_to_VGA/o_address[5] ;
wire \text_to_VGA/o_address[4] ;
wire \text_to_VGA/o_address[3] ;
wire \text_to_VGA/o_address[2] ;
wire \text_to_VGA/o_address[1] ;
wire \text_to_VGA/o_address[0] ;
wire \text_to_VGA/o_data[7] ;
wire \text_to_VGA/o_data[6] ;
wire \text_to_VGA/o_data[5] ;
wire \text_to_VGA/o_data[4] ;
wire \text_to_VGA/o_data[3] ;
wire \text_to_VGA/o_data[2] ;
wire \text_to_VGA/o_data[1] ;
wire \text_to_VGA/o_data[0] ;
wire \text_to_VGA/idx[6] ;
wire \text_to_VGA/idx[5] ;
wire \text_to_VGA/idx[4] ;
wire \text_to_VGA/idx[3] ;
wire \text_to_VGA/idx[2] ;
wire \text_to_VGA/idx[1] ;
wire \text_to_VGA/idx[0] ;
wire \text_to_VGA/col[6] ;
wire \text_to_VGA/col[5] ;
wire \text_to_VGA/col[4] ;
wire \text_to_VGA/col[3] ;
wire \text_to_VGA/col[2] ;
wire \text_to_VGA/col[1] ;
wire \text_to_VGA/col[0] ;
wire \text_to_VGA/lin[4] ;
wire \text_to_VGA/lin[3] ;
wire \text_to_VGA/lin[2] ;
wire \text_to_VGA/lin[1] ;
wire \text_to_VGA/lin[0] ;
wire \text_to_VGA/counter[4] ;
wire \text_to_VGA/counter[3] ;
wire \text_to_VGA/counter[2] ;
wire \text_to_VGA/counter[1] ;
wire \text_to_VGA/counter[0] ;
wire \text_to_VGA/state[1] ;
wire \text_to_VGA/state[0] ;
wire \text_to_VGA/init_idx[6] ;
wire \text_to_VGA/init_idx[5] ;
wire \text_to_VGA/init_idx[4] ;
wire \text_to_VGA/init_idx[3] ;
wire \text_to_VGA/init_idx[2] ;
wire \text_to_VGA/init_idx[1] ;
wire \text_to_VGA/init_idx[0] ;
wire \text_to_VGA/next_lin[4] ;
wire \text_to_VGA/next_lin[3] ;
wire \text_to_VGA/next_lin[2] ;
wire \text_to_VGA/next_lin[1] ;
wire \text_to_VGA/next_lin[0] ;
wire \text_to_VGA/next_idx[6] ;
wire \text_to_VGA/next_idx[5] ;
wire \text_to_VGA/next_idx[4] ;
wire \text_to_VGA/next_idx[3] ;
wire \text_to_VGA/next_idx[2] ;
wire \text_to_VGA/next_idx[1] ;
wire \text_to_VGA/next_idx[0] ;
wire \charbuf/doutb[7] ;
wire \charbuf/doutb[6] ;
wire \charbuf/doutb[5] ;
wire \charbuf/doutb[4] ;
wire \charbuf/doutb[3] ;
wire \charbuf/doutb[2] ;
wire \charbuf/doutb[1] ;
wire \charbuf/doutb[0] ;
wire \charbuf/ada[11] ;
wire \charbuf/ada[10] ;
wire \charbuf/ada[9] ;
wire \charbuf/ada[8] ;
wire \charbuf/ada[7] ;
wire \charbuf/ada[6] ;
wire \charbuf/ada[5] ;
wire \charbuf/ada[4] ;
wire \charbuf/ada[3] ;
wire \charbuf/ada[2] ;
wire \charbuf/ada[1] ;
wire \charbuf/ada[0] ;
wire \charbuf/dina[7] ;
wire \charbuf/dina[6] ;
wire \charbuf/dina[5] ;
wire \charbuf/dina[4] ;
wire \charbuf/dina[3] ;
wire \charbuf/dina[2] ;
wire \charbuf/dina[1] ;
wire \charbuf/dina[0] ;
wire \charbuf/adb[11] ;
wire \charbuf/adb[10] ;
wire \charbuf/adb[9] ;
wire \charbuf/adb[8] ;
wire \charbuf/adb[7] ;
wire \charbuf/adb[6] ;
wire \charbuf/adb[5] ;
wire \charbuf/adb[4] ;
wire \charbuf/adb[3] ;
wire \charbuf/adb[2] ;
wire \charbuf/adb[1] ;
wire \charbuf/adb[0] ;
wire \uart_top/command_buffer[157][7] ;
wire \uart_top/command_buffer[157][6] ;
wire \uart_top/command_buffer[157][5] ;
wire \uart_top/command_buffer[157][4] ;
wire \uart_top/command_buffer[157][3] ;
wire \uart_top/command_buffer[157][2] ;
wire \uart_top/command_buffer[157][1] ;
wire \uart_top/command_buffer[157][0] ;
wire \uart_top/output_command[5][7] ;
wire \uart_top/output_command[5][6] ;
wire \uart_top/output_command[5][5] ;
wire \uart_top/output_command[5][4] ;
wire \uart_top/output_command[5][3] ;
wire \uart_top/output_command[5][2] ;
wire \uart_top/output_command[5][1] ;
wire \uart_top/output_command[5][0] ;
wire \uart_top/output_command[4][7] ;
wire \uart_top/output_command[4][6] ;
wire \uart_top/output_command[4][5] ;
wire \uart_top/output_command[4][4] ;
wire \uart_top/output_command[4][3] ;
wire \uart_top/output_command[4][2] ;
wire \uart_top/output_command[4][1] ;
wire \uart_top/output_command[4][0] ;
wire \uart_top/output_command[3][7] ;
wire \uart_top/output_command[3][6] ;
wire \uart_top/output_command[3][5] ;
wire \uart_top/output_command[3][4] ;
wire \uart_top/output_command[3][3] ;
wire \uart_top/output_command[3][2] ;
wire \uart_top/output_command[3][1] ;
wire \uart_top/output_command[3][0] ;
wire \uart_top/output_command[2][7] ;
wire \uart_top/output_command[2][6] ;
wire \uart_top/output_command[2][5] ;
wire \uart_top/output_command[2][4] ;
wire \uart_top/output_command[2][3] ;
wire \uart_top/output_command[2][2] ;
wire \uart_top/output_command[2][1] ;
wire \uart_top/output_command[2][0] ;
wire \uart_top/output_command[1][7] ;
wire \uart_top/output_command[1][6] ;
wire \uart_top/output_command[1][5] ;
wire \uart_top/output_command[1][4] ;
wire \uart_top/output_command[1][3] ;
wire \uart_top/output_command[1][2] ;
wire \uart_top/output_command[1][1] ;
wire \uart_top/output_command[1][0] ;
wire \uart_top/output_command[0][7] ;
wire \uart_top/output_command[0][6] ;
wire \uart_top/output_command[0][5] ;
wire \uart_top/output_command[0][4] ;
wire \uart_top/output_command[0][3] ;
wire \uart_top/output_command[0][2] ;
wire \uart_top/output_command[0][1] ;
wire \uart_top/output_command[0][0] ;
wire \uart_top/state[1] ;
wire \uart_top/state[0] ;
wire \uart_top/tx_data[7] ;
wire \uart_top/tx_data[6] ;
wire \uart_top/tx_data[5] ;
wire \uart_top/tx_data[4] ;
wire \uart_top/tx_data[3] ;
wire \uart_top/tx_data[2] ;
wire \uart_top/tx_data[1] ;
wire \uart_top/tx_data[0] ;
wire \uart_top/prompt_cnt[5] ;
wire \uart_top/prompt_cnt[4] ;
wire \uart_top/prompt_cnt[3] ;
wire \uart_top/prompt_cnt[2] ;
wire \uart_top/prompt_cnt[1] ;
wire \uart_top/prompt_cnt[0] ;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({\uart_top/tx_cnt[4] ,\uart_top/tx_cnt[3] ,\uart_top/tx_cnt[2] ,\uart_top/tx_cnt[1] ,\uart_top/tx_cnt[0] ,\uart_top/command_index[7] ,\uart_top/command_index[6] ,\uart_top/command_index[5] ,\uart_top/command_index[4] ,\uart_top/command_index[3] ,\uart_top/command_index[2] ,\uart_top/command_index[1] ,\uart_top/command_index[0] ,\uart_top/rx_data[7] ,\uart_top/rx_data[6] ,\uart_top/rx_data[5] ,\uart_top/rx_data[4] ,\uart_top/rx_data[3] ,\uart_top/rx_data[2] ,\uart_top/rx_data[1] ,\uart_top/rx_data[0] ,\text_to_VGA/o_address[12] ,\text_to_VGA/o_address[11] ,\text_to_VGA/o_address[10] ,\text_to_VGA/o_address[9] ,\text_to_VGA/o_address[8] ,\text_to_VGA/o_address[7] ,\text_to_VGA/o_address[6] ,\text_to_VGA/o_address[5] ,\text_to_VGA/o_address[4] ,\text_to_VGA/o_address[3] ,\text_to_VGA/o_address[2] ,\text_to_VGA/o_address[1] ,\text_to_VGA/o_address[0] ,\text_to_VGA/o_data[7] ,\text_to_VGA/o_data[6] ,\text_to_VGA/o_data[5] ,\text_to_VGA/o_data[4] ,\text_to_VGA/o_data[3] ,\text_to_VGA/o_data[2] ,\text_to_VGA/o_data[1] ,\text_to_VGA/o_data[0] ,\text_to_VGA/idx[6] ,\text_to_VGA/idx[5] ,\text_to_VGA/idx[4] ,\text_to_VGA/idx[3] ,\text_to_VGA/idx[2] ,\text_to_VGA/idx[1] ,\text_to_VGA/idx[0] ,\text_to_VGA/col[6] ,\text_to_VGA/col[5] ,\text_to_VGA/col[4] ,\text_to_VGA/col[3] ,\text_to_VGA/col[2] ,\text_to_VGA/col[1] ,\text_to_VGA/col[0] ,\text_to_VGA/lin[4] ,\text_to_VGA/lin[3] ,\text_to_VGA/lin[2] ,\text_to_VGA/lin[1] ,\text_to_VGA/lin[0] ,\text_to_VGA/counter[4] ,\text_to_VGA/counter[3] ,\text_to_VGA/counter[2] ,\text_to_VGA/counter[1] ,\text_to_VGA/counter[0] ,\text_to_VGA/state[1] ,\text_to_VGA/state[0] ,\text_to_VGA/init_idx[6] ,\text_to_VGA/init_idx[5] ,\text_to_VGA/init_idx[4] ,\text_to_VGA/init_idx[3] ,\text_to_VGA/init_idx[2] ,\text_to_VGA/init_idx[1] ,\text_to_VGA/init_idx[0] ,\text_to_VGA/next_lin[4] ,\text_to_VGA/next_lin[3] ,\text_to_VGA/next_lin[2] ,\text_to_VGA/next_lin[1] ,\text_to_VGA/next_lin[0] ,\text_to_VGA/next_idx[6] ,\text_to_VGA/next_idx[5] ,\text_to_VGA/next_idx[4] ,\text_to_VGA/next_idx[3] ,\text_to_VGA/next_idx[2] ,\text_to_VGA/next_idx[1] ,\text_to_VGA/next_idx[0] ,\charbuf/doutb[7] ,\charbuf/doutb[6] ,\charbuf/doutb[5] ,\charbuf/doutb[4] ,\charbuf/doutb[3] ,\charbuf/doutb[2] ,\charbuf/doutb[1] ,\charbuf/doutb[0] ,\charbuf/ada[11] ,\charbuf/ada[10] ,\charbuf/ada[9] ,\charbuf/ada[8] ,\charbuf/ada[7] ,\charbuf/ada[6] ,\charbuf/ada[5] ,\charbuf/ada[4] ,\charbuf/ada[3] ,\charbuf/ada[2] ,\charbuf/ada[1] ,\charbuf/ada[0] ,\charbuf/dina[7] ,\charbuf/dina[6] ,\charbuf/dina[5] ,\charbuf/dina[4] ,\charbuf/dina[3] ,\charbuf/dina[2] ,\charbuf/dina[1] ,\charbuf/dina[0] ,\charbuf/adb[11] ,\charbuf/adb[10] ,\charbuf/adb[9] ,\charbuf/adb[8] ,\charbuf/adb[7] ,\charbuf/adb[6] ,\charbuf/adb[5] ,\charbuf/adb[4] ,\charbuf/adb[3] ,\charbuf/adb[2] ,\charbuf/adb[1] ,\charbuf/adb[0] ,\uart_top/command_buffer[157][7] ,\uart_top/command_buffer[157][6] ,\uart_top/command_buffer[157][5] ,\uart_top/command_buffer[157][4] ,\uart_top/command_buffer[157][3] ,\uart_top/command_buffer[157][2] ,\uart_top/command_buffer[157][1] ,\uart_top/command_buffer[157][0] ,\uart_top/output_command[5][7] ,\uart_top/output_command[5][6] ,\uart_top/output_command[5][5] ,\uart_top/output_command[5][4] ,\uart_top/output_command[5][3] ,\uart_top/output_command[5][2] ,\uart_top/output_command[5][1] ,\uart_top/output_command[5][0] ,\uart_top/output_command[4][7] ,\uart_top/output_command[4][6] ,\uart_top/output_command[4][5] ,\uart_top/output_command[4][4] ,\uart_top/output_command[4][3] ,\uart_top/output_command[4][2] ,\uart_top/output_command[4][1] ,\uart_top/output_command[4][0] ,\uart_top/output_command[3][7] ,\uart_top/output_command[3][6] ,\uart_top/output_command[3][5] ,\uart_top/output_command[3][4] ,\uart_top/output_command[3][3] ,\uart_top/output_command[3][2] ,\uart_top/output_command[3][1] ,\uart_top/output_command[3][0] ,\uart_top/output_command[2][7] ,\uart_top/output_command[2][6] ,\uart_top/output_command[2][5] ,\uart_top/output_command[2][4] ,\uart_top/output_command[2][3] ,\uart_top/output_command[2][2] ,\uart_top/output_command[2][1] ,\uart_top/output_command[2][0] ,\uart_top/output_command[1][7] ,\uart_top/output_command[1][6] ,\uart_top/output_command[1][5] ,\uart_top/output_command[1][4] ,\uart_top/output_command[1][3] ,\uart_top/output_command[1][2] ,\uart_top/output_command[1][1] ,\uart_top/output_command[1][0] ,\uart_top/output_command[0][7] ,\uart_top/output_command[0][6] ,\uart_top/output_command[0][5] ,\uart_top/output_command[0][4] ,\uart_top/output_command[0][3] ,\uart_top/output_command[0][2] ,\uart_top/output_command[0][1] ,\uart_top/output_command[0][0] ,\uart_top/state[1] ,\uart_top/state[0] ,\uart_top/tx_data[7] ,\uart_top/tx_data[6] ,\uart_top/tx_data[5] ,\uart_top/tx_data[4] ,\uart_top/tx_data[3] ,\uart_top/tx_data[2] ,\uart_top/tx_data[1] ,\uart_top/tx_data[0] ,\uart_top/prompt_cnt[5] ,\uart_top/prompt_cnt[4] ,\uart_top/prompt_cnt[3] ,\uart_top/prompt_cnt[2] ,\uart_top/prompt_cnt[1] ,\uart_top/prompt_cnt[0] }),
    .clk_i(clk)
);

endmodule
