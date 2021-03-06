﻿"Filed out from Dolphin Smalltalk 7"!

STONWriter subclass: #DolphinSTONWriter
	instanceVariableNames: 'classInstVarMaps stringQuote'
	classVariableNames: 'ExtendedCharacters'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSTONWriter guid: (GUID fromString: '{56f95579-e6b4-4cd5-8ca6-c7cf2f754593}')!
DolphinSTONWriter comment: ''!
!DolphinSTONWriter categoriesForClass!Unclassified! !
!DolphinSTONWriter methodsFor!

encodeString: aString

	writeStream nextPut: stringQuote.
	keepNewLines
		ifTrue: [self encodeStringKeepingNewLines: aString]
		ifFalse: 
			[| stream ch |
			"Superclass implementation does not work correctly for Dolphin's UTF-encoded Strings, as these enumerate code units, not code points. We must stream over the string instead."
			stream := aString readStream.
			[(ch := stream nextAvailable) isNil] whileFalse: [self encodeCharacter: ch]].
	writeStream nextPut: stringQuote!

escape: char with: anObject
	"Instruct me to escape char with object, either a replacement string or #pass"
	
	"self escape: $/ with: '\/'."
	
	self assert: [anObject isString | (anObject == #pass)].
	self assert: [char isAtomic].
	self writeableStonCharacters at: char codePoint + 1 put: anObject!

initialize
	super initialize.
	classInstVarMaps := IdentityDictionary new.
	stonCharacters := STONCharacters.
	stringQuote := $'!

instVarMapFor: aClass
	^classInstVarMaps at: aClass
		ifAbsentPut: 
			[| names |
			names := aClass stonAllInstVarNames asSet.
			"The 'map' is an actually array of all named inst vars, with nils in the slots of those not to be stored"
			aClass allInstVarNames collect: [:each | (names includes: each) ifTrue: [each]]]!

isSimpleSymbol: aSymbol
	"In Dolphin Symbols are always potentially 'wide strings' in that they are Utf8Strings, and may or may not contain extended characters."

	| count |
	count := aSymbol size.
	count == 0 ifTrue: [^false].
	"The acceptable simple symbol characters in STON are all ASCII, so any surrogate code unit we encounter will be considered a non-simple symbol character. Consequently we can perform this check by iterating through the code units, rather than streaming the characters."
	1 to: count
		do: [:i | (STONSimpleSymbolCharacters at: (aSymbol basicAt: i) + 1) == 0 ifFalse: [^false]].
	^true!

jsonMode: aBoolean
	super jsonMode: aBoolean.
	stringQuote := aBoolean ifTrue: [$"] ifFalse: [$']!

stonCharacters
	^stonCharacters!

writeObject: anObject
	"Override to use cached instance variable names"

	self writeObject: anObject extra: #()!

writeObject: anObject extra: extraPairs
	"Override to use cached instance variable names"

	| names |
	names := self instVarMapFor: anObject class.
	(names isEmpty and: [extraPairs isEmpty])
		ifTrue: [self writeObject: anObject do: [self encodeMap: #()]]
		ifFalse: 
			[self writeObject: anObject
				streamMap: 
					[:dictionary |
					"The map is an array of all inst var names with nil entries for those inst vars that should be skipped. Since the array is in inst var order, we can just enumerate over it by index and avoid the need to map from names to indices."
					1 to: names size
						do: 
							[:i |
							(names at: i)
								ifNotNil: 
									[:each |
									(anObject instVarAt: i)
										ifNotNil: [:value | dictionary at: each asSymbol put: value]
										ifNil: [anObject stonShouldWriteNilInstVars ifTrue: [dictionary at: each asSymbol put: nil]]]].
					extraPairs do: [:each | dictionary at: each key put: each value]]]! !
!DolphinSTONWriter categoriesFor: #encodeString:!private! !
!DolphinSTONWriter categoriesFor: #escape:with:!initialize/release!public! !
!DolphinSTONWriter categoriesFor: #initialize!private! !
!DolphinSTONWriter categoriesFor: #instVarMapFor:!private! !
!DolphinSTONWriter categoriesFor: #isSimpleSymbol:!private! !
!DolphinSTONWriter categoriesFor: #jsonMode:!initialize/release!public! !
!DolphinSTONWriter categoriesFor: #stonCharacters!accessing!private! !
!DolphinSTONWriter categoriesFor: #writeObject:!public!writing! !
!DolphinSTONWriter categoriesFor: #writeObject:extra:!public!writing! !

!DolphinSTONWriter class methodsFor!

initialize
	STONCharacters isImmutable: true.
	STONSimpleSymbolCharacters isImmutable: true! !
!DolphinSTONWriter class categoriesFor: #initialize!class initialization!public! !

