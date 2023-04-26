for replacement in {lfu,fifo,lfru,random}
do
        for policy in {cache,l3inclusive,l3exclusive}
        do
                ./build_champsim.sh bimodal no no no no ${replacement} 1 $policy
                if [ $? -ne 0 ]
                then
                        echo $replacement,$policy give error on build >> errors.txt
                        continue
                fi
                for x in $(ls dpc3_traces)
                do
                        ./run_champsim.sh bimodal-no-no-no-no-${replacement}-1core-${policy} 30 60 $x &
                        if [ $? -ne 0 ]
                        then
                                echo $replacement,$policy,$x give error on run >> errors.txt
                                continue
                        fi
                        #ipc=$(cat results_60M/$x-bimodal-no-no-no-no-${replacement}-1core-${policy}.txt | grep "CPU 0 cumulative IPC:" | cut -d ":" -f 2 | cut -d " " -f 2)
                        #echo ${replacement},${policy},${x},${ipc} >> policy_comparison.csv
                done
        done
done

