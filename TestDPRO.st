"Load in the tests appropriate for DPRO and run them,"
Package manager install: 'Core\Object Arts\Dolphin\Base\Dolphin Base Tests.pax'.

[ | results |
Processor sleep: 5000.
results := SmalltalkSystem current runRegressionTests.
SessionManager current quit: results failureCount+results errorCount] postToInputQueue!