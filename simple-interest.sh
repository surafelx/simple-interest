#!/bin/bash

# Simple Interest Calculator with Validation and Error Handling

# Function to calculate simple interest
calculate_simple_interest() {
    local principal=$1
    local rate=$2
    local time=$3

    # Formula for Simple Interest
    local interest=$(echo "scale=2; $principal * $rate * $time / 100" | bc)
    echo "Simple Interest: $interest"
}

# Function to validate input (only numbers and greater than 0)
validate_input() {
    local input=$1
    if [[ ! "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(echo "$input <= 0" | bc -l) )); then
        echo "Error: Please enter a valid positive number greater than 0."
        return 1
    fi
    return 0
}

# Function to prompt user for input
get_user_input() {
    local prompt=$1
    local value

    while true; do
        read -p "$prompt: " value
        validate_input "$value" && break
    done
    echo "$value"
}

# Welcome message
echo "Welcome to the Simple Interest Calculator!"

# Get user inputs for Principal, Rate, and Time
principal=$(get_user_input "Enter Principal amount")
rate=$(get_user_input "Enter Rate of interest (in %)")
time=$(get_user_input "Enter Time period (in years)")

# Call function to calculate and display the Simple Interest
calculate_simple_interest "$principal" "$rate" "$time"

# Option to calculate compound interest for comparison
read -p "Do you want to calculate Compound Interest as well? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    # Compound interest formula: A = P(1 + r/n)^(nt)
    # For simplicity, assuming n = 1 (annual compounding)
    compound_interest=$(echo "scale=2; $principal * (1 + $rate / 100) ^ $time - $principal" | bc)
    echo "Compound Interest: $compound_interest"
fi

# Option to save the result to a file
read -p "Do you want to save the results to a file? (y/n): " save_choice

if [[ "$save_choice" =~ ^[Yy]$ ]]; then
    read -p "Enter filename to save the results (e.g., results.txt): " filename
    echo "Principal: $principal" > "$filename"
    echo "Rate: $rate%" >> "$filename"
    echo "Time: $time years" >> "$filename"
    echo "Simple Interest: $principal * $rate% * $time years = $(echo "scale=2; $principal * $rate * $time / 100" | bc)" >> "$filename"
    echo "Results saved to $filename"
fi

# Goodbye message
echo "Thank you for using the Simple Interest Calculator. Have a great day!"
