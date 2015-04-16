#!/bin/sh

#paths
WORKSPACE=`dirname $0`
RESULTS=$WORKSPACE/results
CMD_RUNNER=$WORKSPACE/../apache-jmeter-2.12\ 2/lib/ext/CMDRunner.jar
JMETER=$WORKSPACE/../apache-jmeter-2.12\ 2/bin/jmeter
XALAN=$WORKSPACE/../apache-jmeter-2.12\ 2/lib/xalan-2.7.0.jar
XLS=$WORKSPACE/../apache-jmeter-2.12\ 2/extras/jmeter-results-detail-report_21.xsl
ICONS=$WORKSPACE/../apache-jmeter-2.12\ 2/extras

IMAGE_WIDTH=1280
IMAGE_HEIGHT=800
#configuration variables
DEFAULT_URL=capd-preview-internal.kainos.com 
if [ "$1" != "" ]
then
    DEFAULT_URL=capd-$1-internal.kainos.com
    if [ ${1:0:4} = http ]
    then
        DEFAULT_URL=$1
    fi
fi

NUMBER_OF_THREADS=2
if [ "$2" != "" ]
then
    NUMBER_OF_THREADS=$2
fi

RAMP_UP=1 
if [ "$3" != "" ]
then
    RAMP_UP=$3
fi

DURATION=60
if [ "$4" != "" ]
then
    DURATION=$4
fi

TEST_CASES=$WORKSPACE/jmeterTests/*.jmx
if [ "$5" != "" ]
then
    TEST_CASES=$WORKSPACE/$5/*.jmx
fi

rm -r $WORKSPACE/results/*
mkdir -p $RESULTS
cp "$ICONS/expand.png" $WORKSPACE/results/
cp "$ICONS/collapse.png" $WORKSPACE/results/

numberOfTests=`find $TEST_CASES -maxdepth 1 -type f | wc -l`
echo "=============="
echo "About to run load with $NUMBER_OF_THREADS threads, for $DURATION seconds for each test, ramp up time is $RAMP_UP seconds"
echo "Environment is '$DEFAULT_URL'"
echo "Number of tests to run: $numberOfTests"
echo "Tests to be run:"
find $TEST_CASES -maxdepth 1 -type f | grep '[a-zA-Z\-]*\.jmx' -o | grep '[a-zA-Z\-]*' -o 
echo "=============="

echo "<html><head><title>JMeter results</title></head><body><h1>JMeter results</h1><ul>" >> $WORKSPACE/results/results.html
for test_case in $TEST_CASES
do
    #result files
    result=$WORKSPACE/results/`basename $test_case .jmx`.jtl
    resultResponses=$WORKSPACE/results/`basename $test_case .jmx`ResponseTimesOverTime.png
    resultBytesThroughputOverTime=$WORKSPACE/results/`basename $test_case .jmx`BytesThroughputOverTime.png
    resultHitsPerSecond=$WORKSPACE/results/`basename $test_case .jmx`HitsPerSecond.png
    resultResponseTimesPercentiles=$WORKSPACE/results/`basename $test_case .jmx`ResponseTimesPercentiles.png
    resultCSV=$WORKSPACE/results/`basename $test_case .jmx`.csv
    resultAggregateReport=$WORKSPACE/results/`basename $test_case .jmx`AggregateReport.csv
    resultHtml=$WORKSPACE/results/`basename $test_case .jmx`.html
    
    #run load test
    "$JMETER" -n -t $test_case -l $result \
      -Jtest.defaultUrl=$DEFAULT_URL \
      -Jtest.numberOfThreads=$NUMBER_OF_THREADS \
      -Jtest.rampup=$RAMP_UP \
      -Jtest.duration=$DURATION \
      -Jtest.environment=$1
    
    #create reports
    java -cp "$XALAN" org.apache.xalan.xslt.Process -IN $result -XSL "$XLS" -OUT $resultHtml
    java -jar "$CMD_RUNNER" --tool Reporter --generate-csv $resultCSV \
             --input-jtl $result --plugin-type SynthesisReport 
    java -jar "$CMD_RUNNER" --tool Reporter --generate-csv $resultAggregateReport \
             --input-jtl $result --plugin-type AggregateReport 
    java -jar "$CMD_RUNNER" --tool Reporter --generate-png $resultResponses \
             --input-jtl $result --plugin-type ResponseTimesOverTime --width $IMAGE_WIDTH --height $IMAGE_HEIGHT
    java -jar "$CMD_RUNNER" --tool Reporter --generate-png $resultBytesThroughputOverTime \
             --input-jtl $result --plugin-type BytesThroughputOverTime --width $IMAGE_WIDTH --height $IMAGE_HEIGHT
    java -jar "$CMD_RUNNER" --tool Reporter --generate-png $resultHitsPerSecond \
             --input-jtl $result --plugin-type HitsPerSecond --width $IMAGE_WIDTH --height $IMAGE_HEIGHT
    java -jar "$CMD_RUNNER" --tool Reporter --generate-png $resultResponseTimesPercentiles \
             --input-jtl $result --plugin-type ResponseTimesPercentiles --width $IMAGE_WIDTH --height $IMAGE_HEIGHT
    
    echo "<li><a href='`basename $test_case .jmx`.html' target='_blank'>`basename $test_case .jmx`</a> </li>" >> $WORKSPACE/results/results.html
done

echo "</ul></body></html>" >> $WORKSPACE/results/results.html
