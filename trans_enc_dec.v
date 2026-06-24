`timescale 1ns / 1ps
module trans_enc_dec #(
    parameter BAUD_RATE = 115200,
    parameter CLOCK_FREQ = 100000000
)(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    localparam BAUD_COUNT = CLOCK_FREQ / BAUD_RATE;
    localparam [7:0] XOR_KEY = 8'hAA; // Fixed XOR key

    reg [15:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg = 10'b1111111111;

    reg tx_start_prev = 0;
    wire tx_start_edge;

    assign tx_start_edge = tx_start & ~tx_start_prev;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            tx_busy <= 0;
            baud_counter <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
            tx_start_prev <= 0;
        end else begin
            tx_start_prev <= tx_start;

            if (tx_start_edge && !tx_busy) begin
                // XOR encryption here
                shift_reg <= {1'b1, tx_data ^ XOR_KEY, 1'b0}; // Stop + Encrypted data + Start
                tx_busy <= 1;
                bit_index <= 0;
                baud_counter <= 0;
            end else if (tx_busy) begin
                if (baud_counter < BAUD_COUNT) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    tx <= shift_reg[0];                      // send LSB
                    shift_reg <= {1'b1, shift_reg[9:1]};     // shift right
                    if (bit_index == 9) begin
                        tx_busy <= 0;
                        tx <= 1;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end
            end
        end
    end
endmodule
