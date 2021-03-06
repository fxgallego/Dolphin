﻿"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ADODBProperty
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBProperty guid: (IID fromString: '{00000503-0000-0010-8000-00AA006D2EA4}')!
ADODBProperty comment: '<ADODBProperty> is a wrapper class for the COM interface ''ADODB.Property'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBProperty categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBProperty methodsFor!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Attributes: answer.
	^answer asObject
!

attributes: plAttributes
	"Set the 'Attributes' property of the receiver to the <sdword> value of the argument."

	self put_Attributes: plAttributes
!

get_Attributes: plAttributes
	"Private - Get the value of the 'Attributes' property of the receiver.
				HRESULT __stdcall Attributes(
			[out, retval] long* plAttributes);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_Name: pbstr
	"Private - Get the value of the 'Name' property of the receiver.
				HRESULT __stdcall Name(
			[out, retval] BSTR* pbstr);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_Type: ptype
	"Private - Get the value of the 'Type' property of the receiver.
				HRESULT __stdcall Type(
			[out, retval] DataTypeEnum* ptype);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_Value: pval
	"Private - Get the value of the 'Value' property of the receiver.
				HRESULT __stdcall Value(
			[out, retval] VARIANT* pval);"

	<virtual stdcall: hresult 8 variant*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

printValueOn: aStream
	aStream
		print: self name;
		nextPutAll: '=';
		print: self value!

put_Attributes: plAttributes
	"Private - Set the value of the 'Attributes' property of the object wrapped by the 
	 receiver to the <sdword> argument, plAttributes.
				HRESULT __stdcall Attributes(
			[in] long plAttributes);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall: _failureCode!

put_Value: pval
	"Private - Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <variant> argument, pval.
				HRESULT __stdcall Value(
			[in] VARIANT pval);"

	<virtual stdcall: hresult 9 variant>
	^self invalidCall: _failureCode!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Type: answer.
	^answer asObject
!

value
	"Answer the <variant> value of the 'Value' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Value: answer.
	^answer asObject
!

value: pval
	"Set the 'Value' property of the receiver to the <variant> value of the argument."

	self put_Value: pval asVariant
! !
!ADODBProperty categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODBProperty categoriesFor: #attributes:!**auto generated**!properties!public! !
!ADODBProperty categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-Property!private! !
!ADODBProperty categoriesFor: #get_Name:!**auto generated**!COM Interfaces-Property!private! !
!ADODBProperty categoriesFor: #get_Type:!**auto generated**!COM Interfaces-Property!private! !
!ADODBProperty categoriesFor: #get_Value:!**auto generated**!COM Interfaces-Property!private! !
!ADODBProperty categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODBProperty categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODBProperty categoriesFor: #name!**auto generated**!properties!public! !
!ADODBProperty categoriesFor: #printValueOn:!printing!private! !
!ADODBProperty categoriesFor: #put_Attributes:!**auto generated**!COM Interfaces-Property!private! !
!ADODBProperty categoriesFor: #put_Value:!**auto generated**!COM Interfaces-Property!private! !
!ADODBProperty categoriesFor: #type!**auto generated**!properties!public! !
!ADODBProperty categoriesFor: #value!**auto generated**!properties!public! !
!ADODBProperty categoriesFor: #value:!**auto generated**!properties!public! !

!ADODBProperty class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Property'
		ADODBProperty defineTemplate"

	self
		defineFunction: #get_Value:
			argumentTypes: 'variant*';
		defineFunction: #put_Value:
			argumentTypes: 'variant';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #put_Attributes:
			argumentTypes: 'sdword'
! !
!ADODBProperty class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

