`timescale 1ns / 1ps
module rec_enc_dec #(
    parameter BAUD_RATE = 115200,
    parameter CLOCK_FREQ = 100000000
)(
    input clk,
    input rst,
    input rx,
    output reg rx_data_valid,
    output reg [7:0] rx_data
);

    localparam BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;
    localparam [7:0] XOR_KEY = 8'hAA; // Fixed XOR key

    reg [15:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] shift_reg = 0;
    reg [1:0] state = 0;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            baud_counter <= 0;
            bit_index <= 0;
            rx_data_valid <= 0;
            shift_reg <= 0;
            rx_data <= 0;
        end else begin
            rx_data_valid <= 0;

            case (state)
                IDLE: begin
                    if (!rx) begin
                        state <= START;
                        baud_counter <= BAUD_COUNT >> 1;
                    end
                end

                START: begin
                    if (baud_counter == 0) begin
                        if (!rx) begin
                            state <= DATA;
                            bit_index <= 0;
                            baud_counter <= BAUD_COUNT - 1;
                        end else begin
                            state <= IDLE;
                        end
                    end else
                        baud_counter <= baud_counter - 1;
                end

                DATA: begin
                    if (baud_counter == 0) begin
                        shift_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        baud_counter <= BAUD_COUNT - 1;

                        if (bit_index == 7)
                            state <= STOP;
                    end else
                        baud_counter <= baud_counter - 1;
                end

                STOP: begin
                    if (baud_counter == 0) begin
                        if (rx) begin
                            // Decryption using XOR key
                            rx_data <= shift_reg ^ XOR_KEY;
                            rx_data_valid <= 1;
                        end
                        state <= IDLE;
                    end else
                        baud_counter <= baud_counter - 1;
                end
            endcase
        end
    end
endmodule
