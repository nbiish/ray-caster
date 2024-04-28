#!/bin/bash

ollama list > my-ollama-models.txt || touch my-ollama-models.txt
ollama list > my-ollama-models.txt

sed -i 's/:.*//' my-ollama-models.txt

while read line; do
  for i in $line; do
    ollama pull $i
  done
done < my_ollama_models.txt
