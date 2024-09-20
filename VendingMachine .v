module VendingMachine (
    input clk,
    input reset,
    input [1:0] coin_in,         // Coin denominations (00 = no coin, 01 = 2rs, 10 = 5rs, 11 = 10rs)
    input [2:0] item_select,     // Item selection (001 = Candy, 010 = Chocolate, 011 = Chips, etc.)
    input buy,                   // Buy signal
    input multiple_items,        // Multiple item purchase flag
    input coin_accept,           // Allows multiple coins insertion
    output reg [2:0] item_dispensed, // Item dispensed
    output reg [7:0] change_dispensed, // Total change dispensed
    output reg error,            // Error signal (invalid selection/insufficient funds)
    output reg [7:0] current_balance  // Current balance
);

    // Item prices
    localparam CHOCOLATE = 10;
    localparam JUICE = 20;
    localparam CHIPS = 5;
    localparam TOFFEE = 2;
    localparam CANDY = 5;

    // Coin values
    localparam COIN_2RS = 2;
    localparam COIN_5RS = 5;
    localparam COIN_10RS = 10;

    // State encoding
    localparam IDLE = 2'b00;
    localparam COIN_INSERTION = 2'b01;
    localparam ITEM_SELECTION = 2'b10;
    localparam DISPENSE_ITEM = 2'b11;

    // Internal registers
    reg [7:0] total_inserted;
    reg [7:0] total_cost;
    reg [1:0] state, next_state;

    // Item cost lookup function
    function [7:0] get_item_cost;
        input [2:0] item;
        case (item)
            3'b001: get_item_cost = CANDY;
            3'b010: get_item_cost = CHOCOLATE;
            3'b011: get_item_cost = CHIPS;
            3'b100: get_item_cost = TOFFEE;
            3'b101: get_item_cost = JUICE;
            default: get_item_cost = 0;
        endcase
    endfunction

    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            total_inserted <= 0;
            total_cost <= 0;
            current_balance <= 0;
            change_dispensed <= 0;
            item_dispensed <= 3'b000;
            error <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Default outputs
        next_state = state;
        change_dispensed = 0;
        item_dispensed = 3'b000;
        error = 0;

        case (state)
            IDLE: begin
                if (coin_accept) begin
                    next_state = COIN_INSERTION;
                end
            end

            COIN_INSERTION: begin
                // Multiple coin insertion logic
                case (coin_in)
                    2'b01: total_inserted = total_inserted + COIN_2RS;
                    2'b10: total_inserted = total_inserted + COIN_5RS;
                    2'b11: total_inserted = total_inserted + COIN_10RS;
                endcase
                current_balance = total_inserted;
                if (buy) begin
                    next_state = ITEM_SELECTION;
                end
            end

            ITEM_SELECTION: begin
                if (multiple_items) begin
                    // Multiple item selection
                    total_cost = total_cost + get_item_cost(item_select);
                end else begin
                    total_cost = get_item_cost(item_select);
                end

                if (total_inserted >= total_cost) begin
                    next_state = DISPENSE_ITEM;
                end else begin
                    error = 1; // Insufficient funds
                    next_state = IDLE;
                end
            end

            DISPENSE_ITEM: begin
                item_dispensed = item_select;
                total_inserted = total_inserted - total_cost;

                // Calculate change
                if (total_inserted > 0) begin
                    change_dispensed = total_inserted;
                    total_inserted = 0;
                end
                current_balance = total_inserted;
                next_state = IDLE;
            end
        endcase
    end
endmodule
