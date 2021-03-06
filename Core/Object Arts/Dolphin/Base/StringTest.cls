﻿"Filed out from Dolphin Smalltalk 7"!

ArrayedCollectionTest subclass: #StringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StringTest guid: (GUID fromString: '{262b323f-d574-423e-8571-63b1fab0d021}')!
StringTest isAbstract: true!
StringTest comment: ''!
!StringTest categoriesForClass!Unclassified! !
!StringTest methodsFor!

assimilate: each 
	^Character codePoint: each asInteger!

assimilateString: aString
	^self subclassResponsibility!

caseConversionCases
	^{{'abc £12' asAnsiString. 'ABC £12' asAnsiString}.
		{'oña' asAnsiString. 'OÑA' asAnsiString}.
		{'árvízturo tükörfúrógép' asAnsiString. 'ÁRVÍZTURO TÜKÖRFÚRÓGÉP' asAnsiString}.
		{AnsiString fromByteArray: #[97 0 98]. AnsiString fromByteArray: #[65 0 66]}}!

equalityTestCases
	^#('' 'a' 'abc' '' 'tükörfúrógép' 'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ' 'a🐬' 'a £=1.2€')!

lengthTestCases
	^#(#('' 0) #('a' 1) #('ab' 2) #('oña' 3) #('£€' 2))!

newNumericArray: anInteger 
	^self newCollection: ((1 to: anInteger) collect: [:each | Character digitValue: each])!

reverseTestCases
	^#(#('' '') #('a' 'a') #('ab' 'ba') #('abc' 'cba') #('oña' 'año'))!

testAsByteArray
	super testAsByteArray.
	"Try round-trip"
	#('' 'A' 'AB' 'ABC' 'ABCD' 'ABCDE' 'ABCDEF') do: 
			[:each | 
			| bytes |
			bytes := self byteArrayForSequence: each.
			(self collectionClass fromAddress: bytes yourAddress length: each size) 
				= (self newCopy: each)]!

testAt
	self assert: ((self newCollection: 'Hello') at: 1) equals: $H!

testCapitalized
	| string cap |
	string := self assimilateString: ''.
	self assert: string capitalized equals: string.
	string := self newCollection: 'a'.
	cap := string capitalized.
	self assert: cap equals: (self newCollection: 'A').
	self assert: string equals: (self newCollection: 'a').
	string := self newCollection: 'A'.
	cap := string capitalized.
	self assert: cap equals: (self newCollection: 'A').
	self assert: string equals: (self newCollection: 'A').
	string := self newCollection: 'ab'.
	cap := string capitalized.
	self assert: cap equals: (self newCollection: 'Ab').
	self assert: string equals: (self newCollection: 'ab').
	string := self newCollection: 'Ab'.
	cap := string capitalized.
	self assert: cap equals: (self newCollection: 'Ab').
	self assert: string equals: (self newCollection: 'Ab')!

testCaseConversions
	| subject actual expected |
	self caseConversionCases do: 
			[:each |
			subject := self assimilateString: each first.
			actual := subject asUppercase.
			expected := (self assimilateString: each last).
			self assert: actual equals: expected mutableCopy.
			actual := expected asLowercase.
			self assert: actual equals: subject mutableCopy]!

testClassReadFrom
	"Tests String class>>readFrom:. Some interested cases are:
	- Content before the first quote (skipped - not sure that is right, but has always done that)
	- Unterminated (reads up to end)
	- Embedded (doubled) quotes - quotes are undoubled
	- Trailing content - should be left with the stream positioned after the final quote."

	{#('' '' '').
		#('abc' '' '').
		#('abc''A''B' 'A' 'B').
		#('a''AB''CD' 'AB' 'CD').
		#('''a''' 'a' '').
		#('''a' 'a' '').
		#('''abc''' 'abc' '').
		#('''abc' 'abc' '').
		#('''abc''''d'' ''e''' 'abc''d' ' ''e''')} do: 
				[:each |
				| actual expected stream remainder |
				expected := self assimilateString: each second.
				stream := each first readStream.
				actual := self collectionClass readFrom: stream.
				self assert: actual class identicalTo: self collectionClass.
				self assert: actual equals: expected.
				remainder := stream upToEnd.
				self assert: remainder equals: each last]!

testEmpty
	self assert: self collectionClass empty class identicalTo: self collectionClass!

testEquals
	| abc |
	self equalityTestCases do: 
			[:each |
			| subject |
			subject := self assimilateString: each.
			"Identical must be equal"
			self assert: subject equals: subject.
			"Same characters must be equal"
			self assert: subject equals: subject copy.
			each isEmpty ifFalse: [self deny: subject equals: subject asUppercase].
			self assert: subject equals: subject asUtf8String.
			self assert: subject equals: subject asUtf16String.
			"Not equal to ByteArrays"
			self deny: subject asByteArray equals: subject.
			self deny: subject equals: subject asByteArray.
			"Nor Arrays of characters"
			self deny: subject asArray equals: subject.
			self deny: subject equals: subject asArray].
	"Symbols are now equal to strings with the same characters"
	abc := self assimilateString: 'abc'.
	self assert: #abc equals: abc.
	self assert: abc equals: #abc.
!

testFindStringStartingAt
	| searchee abc a empty ba ab bb bba abba |
	searchee := self newCollection: 'abcdefgabcdef'.
	abc := self newCollection: 'abc'.
	self assert: (searchee findString: abc startingAt: 1) equals: 1.
	self assert: (searchee findString: abc startingAt: 2) equals: 8.
	self assert: (searchee findString: abc startingAt: 9) equals: 0.
	self assert: (searchee findString: abc startingAt: 11) equals: 0.
	self assert: (searchee findString: abc startingAt: 1) equals: 1.
	self assert: (searchee findString: abc startingAt: 9) equals: 0.
	searchee := self newCollection: 'aabcabc'.
	self assert: (searchee findString: abc startingAt: 6) equals: 0.
	a := self newCollection: 'a'.
	empty := self newCollection: ''.
	self assert: (empty findString: a startingAt: 1) equals: 0.
	self assert: ('b' findString: a startingAt: 1) equals: 0.
	self assert: (a findString: a startingAt: 1) equals: 1.

	"Search for empty string, should return zero"
	self assert: (a findString: empty startingAt: 1) equals: 0.
	ba := self newCollection: 'ba'.
	self assert: (ba findString: a startingAt: 1) equals: 2.
	ab := self newCollection: 'ab'.
	self assert: (ab findString: a startingAt: 1) equals: 1.
	bb := self newCollection: 'bb'.
	self assert: (bb findString: a startingAt: 1) equals: 0.
	bba := self newCollection: 'bba'.
	self assert: (bba findString: a startingAt: 1) equals: 3.
	self assert: (bba findString: a startingAt: 2) equals: 3.
	self assert: (bba findString: a startingAt: 3) equals: 3.
	abba := self newCollection: 'abba'.
	self assert: (abba findString: ab startingAt: 3) equals: 0.
	self assert: (abba findString: ab startingAt: 4) equals: 0.
	self assert: (abba findString: ab startingAt: 2) equals: 0.
	self assert: (abba findString: ab startingAt: 1) equals: 1.
	searchee := self
				newCollection: 'Now''s the time for all good men to come to the aid of their country.'.
	self assert: (searchee findString: (self newCollection: 'time') startingAt: 1) equals: 11.
	self assert: (searchee findString: (self newCollection: 'timid') startingAt: 1) equals: 0.
	self assert: (searchee findString: (self newCollection: 'try') startingAt: 1) equals: 65.
	searchee := self newCollection: 'babcbabcabcaabcabcabcacabc'.
	self assert: (searchee findString: 'abcabcacab' startingAt: 1) equals: 16.
	searchee := self newCollection: 'aaaaaaabcabcadefg'.
	self assert: (searchee findString: (self newCollection: 'abcad') startingAt: 1) equals: 10.
	self assert: (searchee findString: ab startingAt: 1) equals: 7!

testFindStringStartingAtIgnoreCase
	| searchee abc a empty ba ab bb bba abba |
	searchee := self newCollection: 'abCdefgAbcdef'.
	(searchee respondsTo: #findString:startingAt:ignoreCase:)
		ifFalse: 
			["Introduced in D6"
			^self].
	abc := self newCollection: 'aBc'.
	self assert: (searchee
				findString: abc
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	self assert: (searchee
				findString: abc
				startingAt: 1
				ignoreCase: false)
		equals: 0.
	self assert: (searchee
				findString: abc
				startingAt: 2
				ignoreCase: true)
		equals: 8.
	self assert: (searchee
				findString: abc
				startingAt: 9
				ignoreCase: true)
		equals: 0.
	self assert: (searchee
				findString: abc
				startingAt: 11
				ignoreCase: true)
		equals: 0.
	self assert: (searchee
				findString: abc
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	self assert: (searchee
				findString: abc
				startingAt: 9
				ignoreCase: true)
		equals: 0.
	searchee := self newCollection: 'aAbcaBC'.
	self assert: (searchee
				findString: abc
				startingAt: 6
				ignoreCase: true)
		equals: 0.
	a := self newCollection: 'a'.
	empty := self newCollection: ''.
	self assert: (empty
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	self assert: ('b'
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	self assert: (a
				findString: a asUppercase
				startingAt: 1
				ignoreCase: true)
		equals: 1.

	"Search for empty string, should return zero"
	self assert: (a findString: empty startingAt: 1) equals: 0.
	ba := self newCollection: 'BA'.
	self assert: (ba
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 2.
	ab := self newCollection: 'AB'.
	self assert: (ab
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	bb := self newCollection: 'BB'.
	self assert: (bb
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	bba := self newCollection: 'BBA'.
	self assert: (bba
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 3.
	self assert: (bba
				findString: a
				startingAt: 2
				ignoreCase: true)
		equals: 3.
	self assert: (bba
				findString: a
				startingAt: 3
				ignoreCase: true)
		equals: 3.
	abba := self newCollection: 'ABBA'.
	self assert: (abba
				findString: ab
				startingAt: 3
				ignoreCase: true)
		equals: 0.
	self assert: (abba
				findString: ab
				startingAt: 4
				ignoreCase: true)
		equals: 0.
	self assert: (abba
				findString: ab
				startingAt: 2
				ignoreCase: true)
		equals: 0.
	self assert: (abba
				findString: ab
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	searchee := self
				newCollection: 'Now''s the time for all good men to come to the aid of their country.'.
	self assert: (searchee
				findString: (self newCollection: 'TIME')
				startingAt: 1
				ignoreCase: true)
		equals: 11.
	self assert: (searchee
				findString: (self newCollection: 'timiD')
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	self assert: (searchee
				findString: (self newCollection: 'tRy')
				startingAt: 1
				ignoreCase: true)
		equals: 65.
	searchee := self newCollection: 'babcbabcabcaabcabcabcacabc'.
	self assert: (searchee
				findString: 'abcABCacab'
				startingAt: 1
				ignoreCase: true)
		equals: 16.
	searchee := self newCollection: 'AaAaAaAbCaBcAdEfG'.
	self assert: (searchee
				findString: (self newCollection: 'abcad')
				startingAt: 1
				ignoreCase: true)
		equals: 10.
	self assert: (searchee
				findString: ab
				startingAt: 1
				ignoreCase: true)
		equals: 7!

testHash
	| abc |
	self equalityTestCases do: 
			[:each |
			| subject |
			subject := self assimilateString: each.
			"Same characters must be equal"
			self assert: subject hash equals: subject copy hash.
			self assert: subject hash equals: subject asUtf8String hash.
			self assert: subject hash equals: subject asUtf16String hash].
	"Symbols are now equal to strings with the same characters"
	abc := self assimilateString: 'abc'.
	self assert: #abc hash equals: abc hash!

testInvalidComparisons
	| str literals |
	str := self newCollection: 'blah'.
	literals := #(1.0 1 16rFFFFFFFF 1s2 $a #()).
	literals do: [:each | self deny: str equals: each].
	literals do: [:each | self deny: str equals: each].
	literals do: [:each | self should: [str < each] raise: Error].
	literals do: [:each | self should: [str <= each] raise: Error].
	literals do: [:each | self should: [str > each] raise: Error].
	literals do: [:each | self should: [str >= each] raise: Error].
	literals do: [:each | self should: [each < str] raise: Error].
	literals do: [:each | self should: [each <= str] raise: Error].
	literals do: [:each | self should: [each > str] raise: Error].
	literals do: [:each | self should: [each >= str] raise: Error]!

testLength
	self lengthTestCases do: 
			[:each |
			| subject |
			subject := self assimilateString: each first.
			self assert: subject length equals: each last]!

testLines
	| subject crlf actual empty |
	crlf := String lineDelimiter.
	subject := self newCollection: 'A' , crlf , crlf , 'bc' , crlf , ' ' , crlf.
	actual := subject lines.
	empty := self newCollection: ''.
	self assert: actual
		equals: {self newCollection: 'A'. empty. self newCollection: 'bc'. self newCollection: ' '. empty}!

testMutableCopy
	self caseConversionCases do: 
			[:each |
			| subject actual |
			subject := self assimilateString: each first.
			actual := subject mutableCopy.
			self deny: actual identicalTo: subject.
			self assert: actual isKindOf: subject species.
			self assert: (actual _cmp: subject) equals: 0]!

testReverse
	"Tests reversing a variety of 1, 2, 3 and 4 byte encodings"

	self reverseTestCases do: 
			[:each |
			| subject expected actual |
			subject := self assimilateString: each first.
			expected := self assimilateString: each last.
			actual := subject reverse.
			self assert: actual equals: expected mutableCopy.
			"Reverse it back"
			actual := actual reverse.
			self assert: actual equals: subject mutableCopy]!

testSplitByString
	"Test String>>split:, which tokenizes the argument string into sequences that are separated by the receiver string."

	| sep empty |
	empty := self newCollection: ''.
	"The separator but must not be empty"
	self should: [empty split: (self newCollection: 'abc')] raise: Error.

	"And again but using a string argument of more than one character"
	sep := self newCollection: String lineDelimiter.
	self assert: (sep split: empty) equals: (#() collect: [:e | self newCollection: e]).
	self assert: (sep split: (self newCollection: 'a'))
		equals: (#('a') collect: [:e | self newCollection: e]).
	self assert: (sep split: (self newCollection: sep , 'a'))
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'a' , sep))
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: sep , sep , 'a'))
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'a' , sep , sep))
		equals: (#('a' '' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'ab'))
		equals: (#('ab') collect: [:e | self newCollection: e]).
	self assert: (sep split: (self newCollection: sep , 'ab'))
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'ab' , sep))
		equals: (#('ab' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'ab' , sep , sep , sep))
		equals: (#('ab' '' '' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: sep , sep , 'ab'))
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'a' , sep , 'b'))
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'a' , sep , sep , 'b'))
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'ab' , sep , 'c' , sep))
		equals: (#('ab' 'c' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self newCollection: 'a' , sep , 'b' , sep , sep , 'c'))
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self
						newCollection: (String streamContents: [:strm | i timesRepeat: [strm nextPutAll: 'ab']]).
			self assert: ('ab' split: subject) equals: (Array new: i + 1 withAll: empty)]!

testSplitSingle
	"Test split by a single character string"

	| empty sep |
	empty := ''.
	"And again but using a string argument of only one character"
	sep := '-'.
	self assert: (sep split: empty) equals: #().
	self assert: (sep split: sep) equals: {empty. empty}.
	self assert: (sep split: 'a') equals: #('a').
	self assert: (sep split: '-a') equals: #('' 'a').
	self assert: (sep split: 'a-') equals: #('a' '').
	self assert: (sep split: '--a') equals: #('' '' 'a').
	self assert: (sep split: 'a--') equals: #('a' '' '').
	self assert: (sep split: 'ab') equals: #('ab').
	self assert: (sep split: '-ab') equals: #('' 'ab').
	self assert: (sep split: 'ab-') equals: #('ab' '').
	self assert: (sep split: 'ab---') equals: #('ab' '' '' '').
	self assert: (sep split: '--ab') equals: #('' '' 'ab').
	self assert: (sep split: 'a-b') equals: #('a' 'b').
	self assert: (sep split: 'a--b') equals: #('a' '' 'b').
	self assert: (sep split: 'ab-c-') equals: #('ab' 'c' '').
	self assert: (sep split: 'a-b--c') equals: #('a' 'b' '' 'c')!

testStreamUtfRoundTrip
	| expected actual |
	self collectionClass == Symbol ifTrue: [^self].
	"Test a variety of 1 to 4 byte encodings"
	{''.
		'a'.
		'abc'.
		'£'.
		'être'.
		Utf8String fromByteArray: #[228 185 157 233 190 141 231 129 163].
		Utf8String
			fromByteArray: #[230 150 135 229 173 151 229 140 150 227 129 145 227 131 134 227 130 185 227 131 136].
		Utf8String
			fromByteArray: #[216 167 217 132 216 165 216 185 217 132 216 167 217 134 32 216 167 217 132 216 185 216 167 217 132 217 133 217 137 32 217 132 216 173 217 130 217 136 217 130 32 216 167 217 132 216 165 217 134 216 179 216 167 217 134].
		Utf8String fromByteArray: #[240 144 140 176 240 144 140 177 240 144 140 178]} do: 
				[:each |
				expected := self assimilateString: each.
				actual := expected species writeStream
							nextPutAll: expected;
							contents.
				self assert: (self assimilateString: actual) equals: expected]!

testSubStringsByCharacter
	"Test legacy subStrings: behavior for single character delimiter. This will be changed in 7.2"

	| empty sep |
	empty := self newCollection: ''.
	self assert: (empty subStrings: $-) equals: (#() collect: [:e | self newCollection: e]).
	self assert: ('-' subStrings: $-) equals: {empty}.
	self assert: ((self newCollection: 'a') subStrings: $-)
		equals: (#('a') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-a') subStrings: $-)
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-') subStrings: $-)
		equals: (#('a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--a') subStrings: $-)
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--') subStrings: $-)
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab') subStrings: $-)
		equals: (#('ab') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-ab') subStrings: $-)
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-') subStrings: $-)
		equals: (#('ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab---') subStrings: $-)
		equals: (#('ab' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--ab') subStrings: $-)
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b') subStrings: $-)
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--b') subStrings: $-)
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-c-') subStrings: $-)
		equals: (#('ab' 'c') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b--c') subStrings: $-)
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).

	"And again but using a string argument of only one character"
	sep := self newCollection: '-'.
	self assert: (empty subStrings: sep) equals: (#() collect: [:e | self newCollection: e]).
	self assert: (sep subStrings: sep) equals: {empty}.
	self assert: ((self newCollection: 'a') subStrings: sep)
		equals: (#('a') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-a') subStrings: sep)
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-') subStrings: sep)
		equals: (#('a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--a') subStrings: sep)
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--') subStrings: sep)
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab') subStrings: sep)
		equals: (#('ab') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-ab') subStrings: sep)
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-') subStrings: sep)
		equals: (#('ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab---') subStrings: sep)
		equals: (#('ab' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--ab') subStrings: sep)
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b') subStrings: sep)
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--b') subStrings: sep)
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-c-') subStrings: sep)
		equals: (#('ab' 'c') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b--c') subStrings: sep)
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).

	"Note that if the string consists only of separators, then we get N empty strings if there are N chars"
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self newCollection: (String new: i withAll: $a).
			self assert: (subject subStrings: $a) equals: (Array new: i withAll: empty)]!

testSubStringsByString
	"Test subStrings: with a multi-character string argument. This is the historic behaviour, which ignored a trailing terminator. This will be corrected in 7.2 which will also adopt the ANSI specified behaviour of splitting by any of the 
	characters in the argument string. The String>>split: allows for splitting by all of a sequence of characters."

	| sep empty |
	empty := self newCollection: ''.
	"The separator but must not be empty"
	self should: [(self newCollection: 'abc') subStrings: empty] raise: Error.

	"And again but using a string argument of more than one character"
	sep := self newCollection: String lineDelimiter.

	"Note historic incorrect behaviour that splitting an empty string by anything yields a result with one empty element. Corrected in 7.2."
	self assert: (empty subStrings: sep) equals: (#('') collect: [:e | self newCollection: e]).

	self assert: ((self newCollection: 'a') subStrings: sep)
		equals: (#('a') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: sep , 'a') subStrings: sep)
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a' , sep) subStrings: sep)
		equals: (#('a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: sep , sep , 'a') subStrings: sep)
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	"Note asymmetry - two leading separators and we get a 3 element result, two trailing separator and we get a 2 element result."
	self assert: ((self newCollection: 'a' , sep , sep) subStrings: sep)
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab') subStrings: sep)
		equals: (#('ab') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: sep , 'ab') subStrings: sep)
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab' , sep) subStrings: sep)
		equals: (#('ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab' , sep , sep , sep) subStrings: sep)
		equals: (#('ab' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: sep , sep , 'ab') subStrings: sep)
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a' , sep , 'b') subStrings: sep)
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a' , sep , sep , 'b') subStrings: sep)
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab' , sep , 'c' , sep) subStrings: sep)
		equals: (#('ab' 'c') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a' , sep , 'b' , sep , sep , 'c') subStrings: sep)
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self
						newCollection: (String streamContents: [:strm | i timesRepeat: [strm nextPutAll: 'ab']]).
			self assert: (subject subStrings: 'ab') equals: (Array new: i  withAll: empty)]!

testTrimNulls
	"#1187"

	| string trimmed |
	string := self newCollection: #($a $\0 $\0).
	trimmed := string trimNulls.
	self assert: trimmed size equals: 1.
	self assert: (self newCollection: trimmed) equals: (self newCollection: 'a')!

testUrlDecoded
	"Test URI decoding per RFC3986"

	| unreserved misencoded |
	#(#('' '') #('+' ' ') #('A' 'A') #('+A' ' A') #('++A' '  A') #('A+' 'A ') #('A++' 'A  ') #('AB' 'AB') #('+A+B+' ' A B ') #('++A++B++' '  A  B  ') #('%41' 'A') #('+%41+' ' A ') #('%41B' 'AB') #('%41+B' 'A B') #('%41++B' 'A  B') #('%41BC' 'ABC') #('%41%42' 'AB') #('%41B%43' 'ABC') #('%41BC%44' 'ABCD') #('A%42%43' 'ABC') #('AB%43%44' 'ABCD') #('AB%43D%45' 'ABCDE') #('AB%43DE%46' 'ABCDEF') #('AB%43DE%46G' 'ABCDEFG') #('AB%43DE%46GH' 'ABCDEFGH') #('~25%25' '~25%'))
		do: 
			[:each |
			| subject actual |
			subject := self collectionClass fromString: each first.
			actual := subject urlDecoded.
			self assert: actual equals: each last].
	"Test case from @fxgallego"
	self assert: (self collectionClass fromString: 'Ca%C3%B1%C3%B3n') urlDecoded equals: 'Cañón'.
	"Non-latin 3-byte encoding test case from RFC3986"
	self assert: (self collectionClass fromString: '%E3%82%A2') urlDecoded equals: $\x30A2 asUtf8String.
	"And a 4-byte encoding for fun"
	self assert: (self collectionClass fromString: '%F0%9F%90%AC') urlDecoded equals: '🐬'.

	"All reserved characters in RFC3986, exception '+', should be unaffected by decoding"
	self assert: (self collectionClass fromString: ':/?#[]@!!$&''()*+,;=') urlDecoded
		equals: ':/?#[]@!!$&''()* ,;='.

	"Unreserved characters, also untouched"
	unreserved := (Character byteCharacterSet select: [:each | each isEnglishLetter or: [each isDigit]])
				, '-._~'.
	self assert: (self collectionClass fromString: unreserved) urlDecoded equals: unreserved.
	"But should be coded if found encoded"
	misencoded := String writeStream.
	unreserved do: 
			[:each |
			misencoded nextPut: $%.
			each asciiValue
				printOn: misencoded
				base: 16
				showRadix: false].
	misencoded := misencoded contents.
	self assert: (self collectionClass fromString: misencoded) urlDecoded equals: unreserved.

	"Invalid cases, therefore assume not an escaped string"
	#('%GA' '%AG' '%[1' '%1[' '+%A' '%1' '100%' '%+') do: 
			[:each |
			| subject actual |
			subject := self collectionClass fromString: each.
			actual := subject urlDecoded.
			self assert: actual equals: (self newCopy: subject)].

	"Special cases of non-ASCII input - these should be detected and not decoded"
	#('€5+&+change' '£5+') do: 
			[:each |
			| subject actual |
			subject := self collectionClass fromString: each.
			actual := subject urlDecoded.
			self assert: actual equals: each].
	self collectionClass == AnsiString
		ifFalse: 
			[| subject |
			subject := self collectionClass fromString: '%97+🐬'.
			self assert: subject urlDecoded equals: subject]!

testUrlEncoded
	"Test URI encoding per RFC3986"

	| unreserved reserved |
	unreserved := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~'.
	reserved := ':/?#[]@!!$&''()*+,;='.
	
	"Unreserved shouldn't be encoded"
	self assert: (self collectionClass withAll: unreserved) urlEncoded equals: unreserved.
	"Reserved should allways be encoded when used for some other purpose."
	self assert: (self collectionClass withAll: reserved) urlEncoded equals: '%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D'.
	self assert: (self collectionClass with: Character space) urlEncoded equals: '%20'.
	self assert: (self collectionClass with: $%) urlEncoded equals: '%25'.
	self assert: (self collectionClass withAll: String lineDelimiter) urlEncoded equals: '%0D%0A'.
	"Other common characters found in urls."
	self assert: (self collectionClass withAll: '"<>\^`{|}') urlEncoded equals: '%22%3C%3E%5C%5E%60%7B%7C%7D'.
	"Some unicode"
	self assert: '🐬 cañón CAÑÓN' urlEncoded equals: '%F0%9F%90%AC%20ca%C3%B1%C3%B3n%20CA%C3%91%C3%93N'.
	self assert: '🐬 cañón CAÑÓN' asUtf16String urlEncoded equals: '%F0%9F%90%AC%20ca%C3%B1%C3%B3n%20CA%C3%91%C3%93N'.
	self assert: '日本語' urlEncoded equals: '%E6%97%A5%E6%9C%AC%E8%AA%9E'.
	"Test reversions"
	self assert: '🐬 cañón CAÑÓN' urlEncoded urlDecoded equals: '🐬 cañón CAÑÓN'.
	self assert: String lineDelimiter urlEncoded urlDecoded equals: String lineDelimiter.
	self assert: ' ' urlEncoded urlDecoded equals: ' '.
	self assert: (self collectionClass withAll: unreserved) urlEncoded urlDecoded equals: unreserved.
	self assert: (self collectionClass withAll: reserved) urlEncoded urlDecoded equals: reserved.
!

testWithAll
	self withAllTestCases do: 
			[:each |
			| actual |
			actual := self collectionClass withAll: each.
			self assert: actual equals: each]!

testWithNormalizedLineDelimiters
	"Empty"

	| cr lf crlf char |
	char := self newCollection: '+'.
	cr := self newCollection: (self collectionClass with: Character cr).
	crlf := self newCollection: self collectionClass lineDelimiter.
	lf := self newCollection: (self collectionClass with: Character lf).
	self assert: (self newCollection: '') withNormalizedLineDelimiters equals: (self newCopy: '').
	"Not empty, but no delims"
	self assert: (self newCollection: '') withNormalizedLineDelimiters equals: (self newCopy: '').
	"Single CR"
	self assert: cr withNormalizedLineDelimiters equals: (self newCopy: crlf).
	self assert: (char , cr) withNormalizedLineDelimiters equals: char , crlf.
	self assert: (char , cr , char) withNormalizedLineDelimiters equals: char , crlf , char.
	"Single LF"
	self assert: lf withNormalizedLineDelimiters equals: (self newCopy: crlf).
	self assert: (char , lf) withNormalizedLineDelimiters equals: char , crlf.
	self assert: (char , lf , char) withNormalizedLineDelimiters equals: char , crlf , char.
	"Single CR/LF - no change"
	self assert: crlf withNormalizedLineDelimiters equals: (self newCopy: crlf).
	self assert: (char , crlf) withNormalizedLineDelimiters equals: char , crlf.
	self assert: (char , crlf , char) withNormalizedLineDelimiters equals: char , crlf , char.
	"LF,CR"
	self assert: (lf , cr) withNormalizedLineDelimiters equals: crlf , crlf.
	self assert: (lf , cr , char) withNormalizedLineDelimiters equals: crlf , crlf , char.
	self assert: (char , lf , cr , char) withNormalizedLineDelimiters equals: char , crlf , crlf , char.
	"LF,LF"
	self assert: (lf , lf) withNormalizedLineDelimiters equals: crlf , crlf.
	self assert: (lf , lf , char) withNormalizedLineDelimiters equals: crlf , crlf , char.
	self assert: (char , lf , lf , char) withNormalizedLineDelimiters equals: char , crlf , crlf , char.
	"CR,CR"
	self assert: (cr , cr) withNormalizedLineDelimiters equals: crlf , crlf.
	self assert: (cr , cr , char) withNormalizedLineDelimiters equals: crlf , crlf , char.
	self assert: (char , cr , cr , char) withNormalizedLineDelimiters equals: char , crlf , crlf , char.
	"CRLFLF"
	self assert: (cr , lf , lf) withNormalizedLineDelimiters equals: crlf , crlf.
	"CRLFCR"
	self assert: (cr , lf , cr) withNormalizedLineDelimiters equals: crlf , crlf!

verifyConcatenationResult: resultString of: receiverString with: argumentString
	"When concatenating strings the result should be of the same type as the receiver, unless a
	UTF string is being concatenated with an AnsiString, in which case the result will be of the
	same type as the argument."

	| expected |
	expected := Utf8String writeStream
				nextPutAll: receiverString;
				nextPutAll: argumentString;
				contents.
	self assert: resultString equals: expected!

withAllTestCases
	^#('' 'a' 'abc' '£€')! !
!StringTest categoriesFor: #assimilate:!helpers!private! !
!StringTest categoriesFor: #assimilateString:!helpers!private! !
!StringTest categoriesFor: #caseConversionCases!constants!private! !
!StringTest categoriesFor: #equalityTestCases!constants!private! !
!StringTest categoriesFor: #lengthTestCases!constants!private! !
!StringTest categoriesFor: #newNumericArray:!helpers!private! !
!StringTest categoriesFor: #reverseTestCases!constants!private! !
!StringTest categoriesFor: #testAsByteArray!public!unit tests! !
!StringTest categoriesFor: #testAt!public!unit tests! !
!StringTest categoriesFor: #testCapitalized!public!unit tests! !
!StringTest categoriesFor: #testCaseConversions!public!unit tests! !
!StringTest categoriesFor: #testClassReadFrom!public!unit tests! !
!StringTest categoriesFor: #testEmpty!public!testing / accessing! !
!StringTest categoriesFor: #testEquals!public!unit tests! !
!StringTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!StringTest categoriesFor: #testFindStringStartingAtIgnoreCase!public!unit tests! !
!StringTest categoriesFor: #testHash!public!unit tests! !
!StringTest categoriesFor: #testInvalidComparisons!public!unit tests! !
!StringTest categoriesFor: #testLength!public!unit tests! !
!StringTest categoriesFor: #testLines!public!unit tests! !
!StringTest categoriesFor: #testMutableCopy!public!unit tests! !
!StringTest categoriesFor: #testReverse!public!unit tests! !
!StringTest categoriesFor: #testSplitByString!public!unit tests! !
!StringTest categoriesFor: #testSplitSingle!public!unit tests! !
!StringTest categoriesFor: #testStreamUtfRoundTrip!public!unit tests! !
!StringTest categoriesFor: #testSubStringsByCharacter!public!unit tests! !
!StringTest categoriesFor: #testSubStringsByString!public!unit tests! !
!StringTest categoriesFor: #testTrimNulls!public!unit tests! !
!StringTest categoriesFor: #testUrlDecoded!public!unit tests! !
!StringTest categoriesFor: #testUrlEncoded!public!unit tests! !
!StringTest categoriesFor: #testWithAll!public!unit tests! !
!StringTest categoriesFor: #testWithNormalizedLineDelimiters!public!unit tests! !
!StringTest categoriesFor: #verifyConcatenationResult:of:with:!helpers!private! !
!StringTest categoriesFor: #withAllTestCases!constants!private! !

