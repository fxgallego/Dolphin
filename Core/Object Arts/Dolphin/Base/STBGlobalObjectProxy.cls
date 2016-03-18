"Filed out from Dolphin Smalltalk X6"!

STBProxy subclass: #STBGlobalObjectProxy
	instanceVariableNames: 'symbol object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBGlobalObjectProxy guid: (GUID fromString: '{87B4C6ED-026E-11D3-9FD7-00A0CC3E4A32}')!
STBGlobalObjectProxy comment: ''!
!STBGlobalObjectProxy categoriesForClass!System-Binary storage! !
!STBGlobalObjectProxy methodsFor!

object: anObject
	"Private - Set the receiver's object inst var."

	object := anObject!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	We must not use #become: to swap the receiver with the represented
	object because the object is either:
		a reference to an existing global, or
		a new global that may be nil but in this case there will never
		be other references to the proxy.

	We need to tell inFiler to replace its readMap entry for our answer."

	| anObject |
	anObject := self value.
	inFiler fixup: anInteger to: anObject.
	^anObject!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler.
	This is a rather unusual case. This outputs itself as its own proxy.
	Mmm... It's just a trick used by STBOutFiler, best not to copy this idea."

	anSTBOutFiler saveObject: self as: self!

symbol: aSymbol
	"Private - Set the symbol inst var to aSymbol."

	symbol := aSymbol!

value
	"Install object as a global in the Smalltalk System Dictionary and answer it."

	^Smalltalk at: symbol put: object! !
!STBGlobalObjectProxy categoriesFor: #object:!accessing!private! !
!STBGlobalObjectProxy categoriesFor: #stbFixup:at:!accessing!public! !
!STBGlobalObjectProxy categoriesFor: #stbSaveOn:!binary filing!public! !
!STBGlobalObjectProxy categoriesFor: #symbol:!accessing!private! !
!STBGlobalObjectProxy categoriesFor: #value!converting!public! !

!STBGlobalObjectProxy class methodsFor!

for: anObject name: aSymbol
	"Answer an instance of the receiver representing the global anObject
	which will be made global on load with the name asymbol."

	^self basicNew
		symbol: aSymbol;
		object: anObject;
		yourself! !
!STBGlobalObjectProxy class categoriesFor: #for:name:!instance creation!public! !
