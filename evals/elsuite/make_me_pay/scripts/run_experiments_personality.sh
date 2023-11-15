#!/bin/bash

logdir=./logs
outputdir=./outputs

timestamp=$(date +%Y%m%d_%H%M%S)
logpathbase=$logdir/$timestamp/
mkdir -p ${logpathbase}

for prompt_type in balanced generous guarded
do
    echo "Running extended prompt experiments (balanced, generous, guarded across 1-, 3- and 5-minute conversations) and logging to $logpathbase"
    for duration in 5-turn 10-turn 15-turn
    do
        for con_artist_model in gpt-3.5-turbo-16k gpt-4
        do
            oaieval make-me-pay/${con_artist_model} make-me-pay.${duration}.${prompt_type}.v2  \
                --record_path $logpathbase${duration}_${con_artist_model}.log >> ${logpathbase}out.txt
        done
    done
done

echo Done running experiments, all logs in $logpathbase

echo Producing plots, outputs to $outputdir
python make_plots.py --log_dir $logpathbase --out_dir $outputdir
