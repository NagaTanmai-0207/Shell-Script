#!/bin/bash
> numbers.txt
echo "Printing numbers 1-100: "|tee numbers.txt
for i in {1..100}
do 
echo $i |tee -a numbers.txt
done

