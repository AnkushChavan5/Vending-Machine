# Vending-Machine 
A Verilog-based vending machine controller that accepts multiple coin inputs and allows the user to select multiple items. The machine calculates the total cost of the selected items, deducts it from the total balance, and returns the correct change using available coin denominations.

Features
Accepts multiple coin denominations: 2rs, 5rs, and 10rs.
Allows multiple item selection per transaction.
Supports items with different costs: Chocolate (10rs), Juice (20rs), Chips (5rs), Toffee (2rs), Candy (5rs).
Returns correct change based on the amount entered and item cost.
Handles transactions with multiple items and multiple coins.

Module Overview
Vending_Machine.v
The vending machine operates as a Finite State Machine (FSM) with states for coin insertion, item selection, and item dispensing.

Inputs:
clk: Clock signal for the FSM.
reset: Resets the vending machine.
coin_in: Coin denomination input (00 = no coin, 01 = 2rs, 10 = 5rs, 11 = 10rs).
item_select: Item selection input (001 = Chocolate, 010 = Juice, 011 = Chips, etc.).
buy: Signal to confirm the purchase.
multiple_items: Flag to indicate multiple item purchase.
coin_accept: Allows multiple coin insertion.
Outputs:
item_dispensed: Item(s) dispensed.
change_dispensed: Change to be returned.
error: Error signal in case of invalid selection or insufficient balance.
current_balance: Displays the current balance.

Vending_Machine_TB.v
This test bench simulates the behavior of the vending machine by applying various inputs, including multiple coin insertions, multiple item selections, and validating the correct change return.

Test Case Example:
Insert 10rs 2 coins , 5rs 1 coin and 2rs 1 coin(total 27rs).
Select Candy (cost 5rs) and Chocolate (cost 10rs).
The machine should return 12rs in change.

Future Enhancements
Add a feature to track stock levels of items and notify the user when an item is out of stock.
Introduce a cancel button to allow the user to return inserted coins without buying an item.
