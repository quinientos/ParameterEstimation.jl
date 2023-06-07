#!/bin/bash
# run all *.jl file in directory and redirect output to file with same name
fstr="\n\nCPU time: %S+%U sec\tMax. resident set size: %M KB\t Elapsed: %e sec."
#testfiles=(crauste.jl daisy_mamil3.jl daisy_ex3.jl daisy_mamil4.jl fitzhugh-nagumo.jl hiv.jl lotka-volterra.jl simple.jl)
testfiles=(daisy_mamil4.jl daisy_ex3.jl)
mkdir -p outputs
for file in ${testfiles[@]}; do
    echo "Running $file, output to outputs/${file%.jl}.out"
    /usr/bin/time -f "$fstr" julia $file &>outputs/${file%.jl}.out
    # break
done
