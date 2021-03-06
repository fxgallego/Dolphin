﻿"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRMASKBLT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cbBitsMask _OffsetOf_cbBitsSrc _OffsetOf_cbBmiMask _OffsetOf_cbBmiSrc _OffsetOf_crBkColorSrc _OffsetOf_cxDest _OffsetOf_cyDest _OffsetOf_dwRop _OffsetOf_iUsageMask _OffsetOf_iUsageSrc _OffsetOf_offBitsMask _OffsetOf_offBitsSrc _OffsetOf_offBmiMask _OffsetOf_offBmiSrc _OffsetOf_rclBounds _OffsetOf_xDest _OffsetOf_xformSrc _OffsetOf_xMask _OffsetOf_xSrc _OffsetOf_yDest _OffsetOf_yMask _OffsetOf_ySrc'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRMASKBLT guid: (GUID fromString: '{99001d44-ed7a-4cee-84b9-dbcf1f67898b}')!
EMRMASKBLT addClassConstant: '_OffsetOf_cbBitsMask' value: 16r7C!
EMRMASKBLT addClassConstant: '_OffsetOf_cbBitsSrc' value: 16r60!
EMRMASKBLT addClassConstant: '_OffsetOf_cbBmiMask' value: 16r74!
EMRMASKBLT addClassConstant: '_OffsetOf_cbBmiSrc' value: 16r58!
EMRMASKBLT addClassConstant: '_OffsetOf_crBkColorSrc' value: 16r4C!
EMRMASKBLT addClassConstant: '_OffsetOf_cxDest' value: 16r20!
EMRMASKBLT addClassConstant: '_OffsetOf_cyDest' value: 16r24!
EMRMASKBLT addClassConstant: '_OffsetOf_dwRop' value: 16r28!
EMRMASKBLT addClassConstant: '_OffsetOf_iUsageMask' value: 16r6C!
EMRMASKBLT addClassConstant: '_OffsetOf_iUsageSrc' value: 16r50!
EMRMASKBLT addClassConstant: '_OffsetOf_offBitsMask' value: 16r78!
EMRMASKBLT addClassConstant: '_OffsetOf_offBitsSrc' value: 16r5C!
EMRMASKBLT addClassConstant: '_OffsetOf_offBmiMask' value: 16r70!
EMRMASKBLT addClassConstant: '_OffsetOf_offBmiSrc' value: 16r54!
EMRMASKBLT addClassConstant: '_OffsetOf_rclBounds' value: 16r8!
EMRMASKBLT addClassConstant: '_OffsetOf_xDest' value: 16r18!
EMRMASKBLT addClassConstant: '_OffsetOf_xformSrc' value: 16r34!
EMRMASKBLT addClassConstant: '_OffsetOf_xMask' value: 16r64!
EMRMASKBLT addClassConstant: '_OffsetOf_xSrc' value: 16r2C!
EMRMASKBLT addClassConstant: '_OffsetOf_yDest' value: 16r1C!
EMRMASKBLT addClassConstant: '_OffsetOf_yMask' value: 16r68!
EMRMASKBLT addClassConstant: '_OffsetOf_ySrc' value: 16r30!
EMRMASKBLT comment: '<EMRMASKBLT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRMASKBLT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(99001D44-ED7A-4CEE-84B9-DBCF1F67898B)]
struct tagEMRMASKBLT {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	long xDest;
	long yDest;
	long cxDest;
	long cyDest;
	DWORD dwRop;
	long xSrc;
	long ySrc;
	[helpstring("Source DC transform")] XFORM xformSrc;
	[helpstring("Source DC BkColor in RGB")] COLORREF crBkColorSrc;
	[helpstring("Source bitmap info color table usage (DIB_RGB_COLORS)")] DWORD iUsageSrc;
	[helpstring("Offset to the source BITMAPINFO structure")] DWORD offBmiSrc;
	[helpstring("Size of the source BITMAPINFO structure")] DWORD cbBmiSrc;
	[helpstring("Offset to the source bitmap bits")] DWORD offBitsSrc;
	[helpstring("Size of the source bitmap bits")] DWORD cbBitsSrc;
	long xMask;
	long yMask;
	[helpstring("Mask bitmap info color table usage")] DWORD iUsageMask;
	[helpstring("Offset to the mask BITMAPINFO structure if any")] DWORD offBmiMask;
	[helpstring("Size of the mask BITMAPINFO structure if any")] DWORD cbBmiMask;
	[helpstring("Offset to the mask bitmap bits if any")] DWORD offBitsMask;
	[helpstring("Size of the mask bitmap bits if any")] DWORD cbBitsMask;
} EMRMASKBLT;
'!
!EMRMASKBLT categoriesForClass!Win32-Structs! !
!EMRMASKBLT methodsFor!

cbBitsMask
	"Answer the <Integer> value of the receiver's 'cbBitsMask' field."

	^bytes dwordAtOffset: _OffsetOf_cbBitsMask!

cbBitsMask: anInteger
	"Set the receiver's 'cbBitsMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBitsMask put: anInteger!

cbBitsSrc
	"Answer the <Integer> value of the receiver's 'cbBitsSrc' field."

	^bytes dwordAtOffset: _OffsetOf_cbBitsSrc!

cbBitsSrc: anInteger
	"Set the receiver's 'cbBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBitsSrc put: anInteger!

cbBmiMask
	"Answer the <Integer> value of the receiver's 'cbBmiMask' field."

	^bytes dwordAtOffset: _OffsetOf_cbBmiMask!

cbBmiMask: anInteger
	"Set the receiver's 'cbBmiMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBmiMask put: anInteger!

cbBmiSrc
	"Answer the <Integer> value of the receiver's 'cbBmiSrc' field."

	^bytes dwordAtOffset: _OffsetOf_cbBmiSrc!

cbBmiSrc: anInteger
	"Set the receiver's 'cbBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBmiSrc put: anInteger!

crBkColorSrc
	"Answer the <Integer> value of the receiver's 'crBkColorSrc' field."

	^bytes dwordAtOffset: _OffsetOf_crBkColorSrc!

crBkColorSrc: anInteger
	"Set the receiver's 'crBkColorSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_crBkColorSrc put: anInteger!

cxDest
	"Answer the <Integer> value of the receiver's 'cxDest' field."

	^bytes sdwordAtOffset: _OffsetOf_cxDest!

cxDest: anInteger
	"Set the receiver's 'cxDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxDest put: anInteger!

cyDest
	"Answer the <Integer> value of the receiver's 'cyDest' field."

	^bytes sdwordAtOffset: _OffsetOf_cyDest!

cyDest: anInteger
	"Set the receiver's 'cyDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyDest put: anInteger!

dwRop
	"Answer the <Integer> value of the receiver's 'dwRop' field."

	^bytes dwordAtOffset: _OffsetOf_dwRop!

dwRop: anInteger
	"Set the receiver's 'dwRop' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwRop put: anInteger!

iUsageMask
	"Answer the <Integer> value of the receiver's 'iUsageMask' field."

	^bytes dwordAtOffset: _OffsetOf_iUsageMask!

iUsageMask: anInteger
	"Set the receiver's 'iUsageMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iUsageMask put: anInteger!

iUsageSrc
	"Answer the <Integer> value of the receiver's 'iUsageSrc' field."

	^bytes dwordAtOffset: _OffsetOf_iUsageSrc!

iUsageSrc: anInteger
	"Set the receiver's 'iUsageSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iUsageSrc put: anInteger!

offBitsMask
	"Answer the <Integer> value of the receiver's 'offBitsMask' field."

	^bytes dwordAtOffset: _OffsetOf_offBitsMask!

offBitsMask: anInteger
	"Set the receiver's 'offBitsMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBitsMask put: anInteger!

offBitsSrc
	"Answer the <Integer> value of the receiver's 'offBitsSrc' field."

	^bytes dwordAtOffset: _OffsetOf_offBitsSrc!

offBitsSrc: anInteger
	"Set the receiver's 'offBitsSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBitsSrc put: anInteger!

offBmiMask
	"Answer the <Integer> value of the receiver's 'offBmiMask' field."

	^bytes dwordAtOffset: _OffsetOf_offBmiMask!

offBmiMask: anInteger
	"Set the receiver's 'offBmiMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmiMask put: anInteger!

offBmiSrc
	"Answer the <Integer> value of the receiver's 'offBmiSrc' field."

	^bytes dwordAtOffset: _OffsetOf_offBmiSrc!

offBmiSrc: anInteger
	"Set the receiver's 'offBmiSrc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmiSrc put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1!

xDest
	"Answer the <Integer> value of the receiver's 'xDest' field."

	^bytes sdwordAtOffset: _OffsetOf_xDest!

xDest: anInteger
	"Set the receiver's 'xDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xDest put: anInteger!

xformSrc
	"Answer the <XFORM> value of the receiver's 'xformSrc' field."

	^XFORM fromAddress: bytes yourAddress + _OffsetOf_xformSrc!

xformSrc: aXFORM
	"Set the receiver's 'xformSrc' field to the value of the argument, aXFORM"

	aXFORM
		replaceBytesOf: bytes
		from: ##(_OffsetOf_xformSrc + 1)
		to: ##(_OffsetOf_xformSrc + XFORM basicByteSize)
		startingAt: 1!

xMask
	"Answer the <Integer> value of the receiver's 'xMask' field."

	^bytes sdwordAtOffset: _OffsetOf_xMask!

xMask: anInteger
	"Set the receiver's 'xMask' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xMask put: anInteger!

xSrc
	"Answer the <Integer> value of the receiver's 'xSrc' field."

	^bytes sdwordAtOffset: _OffsetOf_xSrc!

xSrc: anInteger
	"Set the receiver's 'xSrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_xSrc put: anInteger!

yDest
	"Answer the <Integer> value of the receiver's 'yDest' field."

	^bytes sdwordAtOffset: _OffsetOf_yDest!

yDest: anInteger
	"Set the receiver's 'yDest' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yDest put: anInteger!

yMask
	"Answer the <Integer> value of the receiver's 'yMask' field."

	^bytes sdwordAtOffset: _OffsetOf_yMask!

yMask: anInteger
	"Set the receiver's 'yMask' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_yMask put: anInteger!

ySrc
	"Answer the <Integer> value of the receiver's 'ySrc' field."

	^bytes sdwordAtOffset: _OffsetOf_ySrc!

ySrc: anInteger
	"Set the receiver's 'ySrc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_ySrc put: anInteger! !
!EMRMASKBLT categoriesFor: #cbBitsMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBitsMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBitsSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBitsSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cbBmiSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #crBkColorSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #crBkColorSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cxDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cxDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cyDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #cyDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #dwRop!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #dwRop:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #iUsageSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBitsSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #offBmiSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xformSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xformSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xSrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #xSrc:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yDest!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yDest:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yMask!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #yMask:!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #ySrc!**compiled accessors**!public! !
!EMRMASKBLT categoriesFor: #ySrc:!**compiled accessors**!public! !

!EMRMASKBLT class methodsFor!

defineFields
	"Define the fields of the EMRMASKBLT structure.

	EMRMASKBLT  compileDefinition

		typedef [uuid(99001D44-ED7A-4CEE-84B9-DBCF1F67898B)]
		struct tagEMRMASKBLT {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			long xDest;
			long yDest;
			long cxDest;
			long cyDest;
			DWORD dwRop;
			long xSrc;
			long ySrc;
			[helpstring('Source DC transform')] XFORM xformSrc;
			[helpstring('Source DC BkColor in RGB')] COLORREF crBkColorSrc;
			[helpstring('Source bitmap info color table usage (DIB_RGB_COLORS)')] DWORD iUsageSrc;
			[helpstring('Offset to the source BITMAPINFO structure')] DWORD offBmiSrc;
			[helpstring('Size of the source BITMAPINFO structure')] DWORD cbBmiSrc;
			[helpstring('Offset to the source bitmap bits')] DWORD offBitsSrc;
			[helpstring('Size of the source bitmap bits')] DWORD cbBitsSrc;
			long xMask;
			long yMask;
			[helpstring('Mask bitmap info color table usage')] DWORD iUsageMask;
			[helpstring('Offset to the mask BITMAPINFO structure if any')] DWORD offBmiMask;
			[helpstring('Size of the mask BITMAPINFO structure if any')] DWORD cbBmiMask;
			[helpstring('Offset to the mask bitmap bits if any')] DWORD offBitsMask;
			[helpstring('Size of the mask bitmap bits if any')] DWORD cbBitsMask;
		} EMRMASKBLT;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #xDest
			type: SDWORDField new
			offset: 24;
		defineField: #yDest
			type: SDWORDField new
			offset: 28;
		defineField: #cxDest
			type: SDWORDField new
			offset: 32;
		defineField: #cyDest
			type: SDWORDField new
			offset: 36;
		defineField: #dwRop
			type: DWORDField new
			offset: 40;
		defineField: #xSrc
			type: SDWORDField new
			offset: 44;
		defineField: #ySrc
			type: SDWORDField new
			offset: 48;
		defineField: #xformSrc
			type: (StructureField type: XFORM)
			offset: 52;
		defineField: #crBkColorSrc
			type: DWORDField new
			offset: 76;
		defineField: #iUsageSrc
			type: DWORDField new
			offset: 80;
		defineField: #offBmiSrc
			type: DWORDField new
			offset: 84;
		defineField: #cbBmiSrc
			type: DWORDField new
			offset: 88;
		defineField: #offBitsSrc
			type: DWORDField new
			offset: 92;
		defineField: #cbBitsSrc
			type: DWORDField new
			offset: 96;
		defineField: #xMask
			type: SDWORDField new
			offset: 100;
		defineField: #yMask
			type: SDWORDField new
			offset: 104;
		defineField: #iUsageMask
			type: DWORDField new
			offset: 108;
		defineField: #offBmiMask
			type: DWORDField new
			offset: 112;
		defineField: #cbBmiMask
			type: DWORDField new
			offset: 116;
		defineField: #offBitsMask
			type: DWORDField new
			offset: 120;
		defineField: #cbBitsMask
			type: DWORDField new
			offset: 124.
	self byteSize: 128!

getFieldNames
	^#(#iType #nSize #rclBounds #xDest #yDest #cxDest #cyDest #dwRop #xSrc #ySrc #xformSrc #crBkColorSrc #iUsageSrc #offBmiSrc #cbBmiSrc #offBitsSrc #cbBitsSrc #xMask #yMask #iUsageMask #offBmiMask #cbBmiMask #offBitsMask #cbBitsMask)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_MASKBLT! !
!EMRMASKBLT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRMASKBLT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRMASKBLT class categoriesFor: #iTypes!constants!public! !

