"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestCaseResult
	instanceVariableNames: 'case outcome duration signal stacktrace'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestCaseResult guid: (GUID fromString: '{a233feef-eabb-4fa9-9cf3-09531d206233}')!
TestCaseResult comment: 'Represents the results of executing an individual <TestCase>'!
!TestCaseResult categoriesForClass!SUnit! !
!TestCaseResult methodsFor!

case
	"Answer the <TestCase> instance for which this object records results."

	^case!

duration
	"Answer the time the test took to run, in microseconds. If the test didn't pass, the value
	is undefined."

	^duration!

outcome
	"Answer the outcome of the testcase - one of #passed, #failed, #error, #skipped."

	^outcome!

setCase: aTestCase duration: anInteger
	case := aTestCase.
	outcome := #passed.
	duration := anInteger!

setCase: aTestCase error: anException
	case := aTestCase.
	outcome := #error.
	signal := anException.
	stacktrace := anException stackTrace: 20.
	duration := 0!

setCase: aTestCase failure: aTestFailure
	case := aTestCase.
	outcome := #failed.
	signal := aTestFailure.
	stacktrace := aTestFailure stackTrace: 20.
	duration := 0!

signal
	"Answer the <Exception> signalled if the test failed or threw an error, or nil if the test
	passed."

	^signal!

stacktrace
	"Answer the stacktrace capture when the test failed/errored, or nil if the test passed."

	^stacktrace! !
!TestCaseResult categoriesFor: #case!accessing!public! !
!TestCaseResult categoriesFor: #duration!accessing!public! !
!TestCaseResult categoriesFor: #outcome!accessing!public! !
!TestCaseResult categoriesFor: #setCase:duration:!initializing!private! !
!TestCaseResult categoriesFor: #setCase:error:!initializing!private! !
!TestCaseResult categoriesFor: #setCase:failure:!initializing!private! !
!TestCaseResult categoriesFor: #signal!accessing!public! !
!TestCaseResult categoriesFor: #stacktrace!accessing!public! !

!TestCaseResult class methodsFor!

case: aTestCase duration: anInteger
	^self new setCase: aTestCase duration: anInteger!

case: aTestCase error: anException
	^self new
		setCase: aTestCase error: anException!

case: aTestCase failure: anException
	^self new
		setCase: aTestCase failure: anException! !
!TestCaseResult class categoriesFor: #case:duration:!instance creation!public! !
!TestCaseResult class categoriesFor: #case:error:!instance creation!public! !
!TestCaseResult class categoriesFor: #case:failure:!instance creation!public! !
