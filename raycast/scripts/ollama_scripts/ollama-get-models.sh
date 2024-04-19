#!/bin/bash

while read model; do
    ollama pull "$model"
done < "ollama-get-models.txt"