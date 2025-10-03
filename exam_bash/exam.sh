#!/bin/bash

OUTPUT="sales.txt"

echo "$(date)" >> $OUTPUT


# function to scrape all cards
scrape_sales() {
    echo "$(date)" >>  $OUTPUT
    for card in rtx3060 rtx3070 rtx3080 rx6700 rx6900xt; do
        echo "$card: $(curl -s http://0.0.0.0:5000/$card)" >>  $OUTPUT
    done
    echo "----" >>  $OUTPUT
}

scrape_sales
