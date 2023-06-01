#!/bin/bash
# run all *.m file in directory and redirect output to file with same name
fstr="\n\nCPU time: %S+%U sec\tMax. resident set size: %M KB\t Elapsed: %e sec."
mfiles=(crauste.m crauste_JRB.m crauste_JRB2.m daisy_ex3_JRB.m daisy_ex3_local.m daisy_mamil3.m daisy_mamil3_JRB.m daisy_mamil4_JRB.m daisy_mamil4_local.m FHN.m HIV.m HIV_JRB.m HIV_JRB2.m LotkaVolterra.m LotkaVolterra_JRB.m simple.m)
mkdir -p outputs
for file in ${mfiles[@]}; do
    echo "Running $file, output to outputs/${file%.m}.out"
    /usr/bin/time -f "$fstr" matlab -nodisplay -nosplash -nodesktop -r "run $file; exit" &>outputs/${file%.m}.out
    # break
done
