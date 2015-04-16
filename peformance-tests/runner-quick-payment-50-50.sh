#!/bin/sh

#paths
WORKSPACE=`dirname $0`
RESULTS=$WORKSPACE/results
CMD_RUNNER=$WORKSPACE/../apache-jmeter-2.12\ 2/lib/ext/CMDRunner.jar
JMETER=$WORKSPACE/../apache-jmeter-2.12\ 2/bin/jmeter
XALAN=$WORKSPACE/../apache-jmeter-2.12\ 2/lib/xalan-2.7.0.jar
XLS=$WORKSPACE/../apache-jmeter-2.12\ 2/extras/jmeter-results-detail-report_21.xsl
ICONS=$WORKSPACE/../apache-jmeter-2.12\ 2/extras

rm -r $WORKSPACE/results/*
mkdir -p $RESULTS

test_case=$WORKSPACE/quick-payment-order.jmx
result=$RESULTS/quick-payment-order-50-50.jtl

"$JMETER" -n -t $test_case -l $result \
  -Jtest.defaultUrl=$DEFAULT_URL \
  -Jtest.numberOfThreads=$NUMBER_OF_THREADS \
  -Jtest.rampup=$RAMP_UP \
  -Jtest.duration=$DURATION \
  -Jtest.environment=$1
