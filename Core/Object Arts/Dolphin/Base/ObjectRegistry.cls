﻿"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ObjectRegistry
	instanceVariableNames: 'registry'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ObjectRegistry guid: (GUID fromString: '{87b4c4a5-026e-11d3-9fd7-00a0cc3e4a32}')!
ObjectRegistry isAbstract: true!
ObjectRegistry comment: 'ObjectRegistry is part of Dolphin''s external interfacing support, its purpose being to provide a unique <integer> identifier for a specific object, and, depending on the subclass, to maintain a reference to that object to prevent it from being garbage collected. This can be useful, for example, where one needs some unique identifier for an object to be passed to some external entity. 

Note: The Oop (address) of an object is not a suitable candidate for uniquely identifying an object, because it may change over time as the garbage collector moves objects in memory. The identity hash of an object, although time invariant, is not suitable either because it is of limited range (16-bits), and therefore not guaranteed to be unique.

ObjectRegistry itself is abstract: Subclasses implement both permanent registries (that maintain a strong reference to registered objects and thus keep them alive) and weak registries (that reference registered objects only weakly and thus do not prevent them from being garbage collected).

Instance Variables:
	registry		<sequencedCollection>. The collection of registered objects.'!
!ObjectRegistry categoriesForClass!System-Support! !
!ObjectRegistry methodsFor!

addAnsweringIndex: anObject
	"Register the argument, anObject, answering a unique SmallInteger id which can be used
	subsequently to retrieve that object."

	^self subclassResponsibility!

at: anInteger
	"Answer the object registered with the receiver with the specified id.
	If the id is invalid, raise an exception.
	Implementation Note: Although we could check to see if the object 
	with the specified id is a valid object, we cannot detect the situation
	where an id has simply been reused, so we don't bother to incur the overhead."

	^registry basicAt: anInteger!

at: anInteger ifAbsent: exceptionHandler
	"Answer the object registered with the receiver with the specified id.
	If the id is out of bounds, evaluate the niladic valuable argument, exceptionHandler."

	^registry at: anInteger ifAbsent: exceptionHandler!

indexOf: anObject ifAbsent: exceptionHandler
	"Answer the element of the receiver at the specified id. If there is
	no such registered object, answer the result of evaluating the
	the niladic value argument, exceptionHandler.
	Implementation Note: We do an identity search, because object registries
	are intended for registering specific object instances, and because
	it is very fast."

	^registry identityIndexOf: anObject ifAbsent: exceptionHandler!

initialize: anInteger
	"Private - Initialize the receiver with the specified initial capacity."

	^self subclassResponsibility!

lookup: anInteger
	^registry lookup: anInteger!

remove: anObject ifAbsent: exceptionHandler
	"Remove the registration of the argument, anObject, freeing its unique integer id for
	subsequent re-use."

	^self removeAtIndex: (self indexOf: anObject ifAbsent: [ ^exceptionHandler value ])!

removeAtIndex: anInteger
	"Remove, and answer, the registered object with id anInteger in the receiver. 
	Raise an error if there is no element indexed by anInteger."

	^self subclassResponsibility! !
!ObjectRegistry categoriesFor: #addAnsweringIndex:!adding!public! !
!ObjectRegistry categoriesFor: #at:!accessing!debugger-step through!public! !
!ObjectRegistry categoriesFor: #at:ifAbsent:!accessing!public! !
!ObjectRegistry categoriesFor: #indexOf:ifAbsent:!accessing!public! !
!ObjectRegistry categoriesFor: #initialize:!initializing!private! !
!ObjectRegistry categoriesFor: #lookup:!public! !
!ObjectRegistry categoriesFor: #remove:ifAbsent:!public!removing! !
!ObjectRegistry categoriesFor: #removeAtIndex:!public!removing! !

!ObjectRegistry class methodsFor!

defaultCapacity
	"Private - Answer the default capacity for an instance of the receiver."

	^4!

new
	"Answer a new permanent object registry with space for the default number of elements."

	^self new: self defaultCapacity!

new: anInteger
	"Answer a new object registry with initial capacity 
	for anInteger elements."

	^self basicNew initialize: anInteger! !
!ObjectRegistry class categoriesFor: #defaultCapacity!constants!private! !
!ObjectRegistry class categoriesFor: #new!instance creation!public! !
!ObjectRegistry class categoriesFor: #new:!instance creation!public! !

