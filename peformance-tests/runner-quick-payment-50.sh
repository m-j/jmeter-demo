#!/bin/sh

#paths
WORKSPACE=`dirname $0`
RESULTS=$WORKSPACE/results
JMETER=/Users/mateuszj/SelfContainedApps/apache-jmeter-2.12/bin/jmeter
CMD_RUNNER=/Users/mateuszj/SelfContainedApps/apache-jmeter-2.12/lib/ext/CMDRunner.jar

mkdir -p $RESULTS

test_case=$WORKSPACE/quick-payment-order.jmx
result=$RESULTS/quick-payment-order-50.jtl
number_of_threads=50
duration=30
ramp_up=10

rm -r $result-aggregate.csv

"$JMETER" -n -t $test_case -l $result \
  -JnumberOfThreads=$number_of_threads \
  -Jrampup=$ramp_up \
  -Jduration=$duration

java -jar "$CMD_RUNNER" --tool Reporter --generate-csv $result-aggregate.csv \
         --input-jtl $result --plugin-type AggregateReport 
