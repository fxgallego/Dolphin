﻿"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_DATA_CHUNK
	instanceVariableNames: 'data'
	classVariableNames: '_OffsetOf_DataChunkType _OffsetOf_FromFileHandle_ByteRange _OffsetOf_FromFileHandle_FileHandle _OffsetOf_FromFragmentCache_FragmentNameLength _OffsetOf_FromFragmentCache_pFragmentName _OffsetOf_FromFragmentCacheEx_ByteRange _OffsetOf_FromFragmentCacheEx_pFragmentName _OffsetOf_FromMemory_BufferLength _OffsetOf_FromMemory_pBuffer'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_DATA_CHUNK guid: (GUID fromString: '{831e8135-6bb5-45e2-b278-10b1c489883a}')!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_DataChunkType' value: 16r0!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromFileHandle_ByteRange' value: 16r8!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromFileHandle_FileHandle' value: 16r18!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromFragmentCache_FragmentNameLength' value: 16r8!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromFragmentCache_pFragmentName' value: 16rC!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromFragmentCacheEx_ByteRange' value: 16r8!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromFragmentCacheEx_pFragmentName' value: 16r18!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromMemory_BufferLength' value: 16rC!
HTTP_DATA_CHUNK addClassConstant: '_OffsetOf_FromMemory_pBuffer' value: 16r8!
HTTP_DATA_CHUNK comment: '<HTTP_DATA_CHUNK> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_DATA_CHUNK'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This structure describes an individual data chunk."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(831e8135-6bb5-45e2-b278-10b1c489883a), helpstring("This structure describes an individual data chunk.")]
struct tagHTTP_DATA_CHUNK {
	[helpstring("The type of this data chunk.")] HTTP_DATA_CHUNK_TYPE DataChunkType;
	[helpstring("The data chunk structures, one per supported data chunk type.")] union {
		[helpstring("From-memory data chunk.")] struct {
			PVOID pBuffer;
			ULONG BufferLength;
		} FromMemory;
		[helpstring("From-file handle data chunk.")] struct {
			HTTP_BYTE_RANGE ByteRange;
			HANDLE FileHandle;
		} FromFileHandle;
		[helpstring("From-fragment cache data chunk.")] struct {
			[helpstring("Size in bytes of FragmentName not including terminating null")] USHORT FragmentNameLength;
			LPCWSTR pFragmentName;
		} FromFragmentCache;
		[helpstring("From-fragment cache data chunk that specifies a byte range.")] struct {
			HTTP_BYTE_RANGE ByteRange;
			[helpstring("Null-terminated string")] LPCWSTR pFragmentName;
		} FromFragmentCacheEx;
	};
} HTTP_DATA_CHUNK;
'!
!HTTP_DATA_CHUNK categoriesForClass!WinHttpServer-Structs! !
!HTTP_DATA_CHUNK methodsFor!

data: aByteObject
	data := aByteObject.
	self
		FromMemory_pBuffer: data yourAddress;
		FromMemory_BufferLength: data size;
		DataChunkType: HttpDataChunkFromMemory!

DataChunkType
	"Answer the <Integer> value of the receiver's 'DataChunkType' field."

	^bytes sdwordAtOffset: _OffsetOf_DataChunkType!

DataChunkType: anInteger
	"Set the receiver's 'DataChunkType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_DataChunkType put: anInteger!

FromFileHandle_ByteRange
	"Answer the <HTTP_BYTE_RANGE> value of the receiver's 'FromFileHandle_ByteRange' field."

	^HTTP_BYTE_RANGE fromAddress: bytes yourAddress + _OffsetOf_FromFileHandle_ByteRange!

FromFileHandle_ByteRange: aHTTP_BYTE_RANGE
	"Set the receiver's 'FromFileHandle_ByteRange' field to the value of the argument, aHTTP_BYTE_RANGE"

	aHTTP_BYTE_RANGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_FromFileHandle_ByteRange + 1)
		to: ##(_OffsetOf_FromFileHandle_ByteRange + HTTP_BYTE_RANGE basicByteSize)
		startingAt: 1!

FromFileHandle_FileHandle
	"Answer the <ExternalHandle> value of the receiver's 'FromFileHandle_FileHandle' field."

	^(bytes uintPtrAtOffset: _OffsetOf_FromFileHandle_FileHandle) asExternalHandle!

FromFileHandle_FileHandle: anExternalHandle
	"Set the receiver's 'FromFileHandle_FileHandle' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_FromFileHandle_FileHandle put: anExternalHandle!

FromFragmentCache_FragmentNameLength
	"Answer the <Integer> value of the receiver's 'FromFragmentCache_FragmentNameLength' field."

	^bytes wordAtOffset: _OffsetOf_FromFragmentCache_FragmentNameLength!

FromFragmentCache_FragmentNameLength: anInteger
	"Set the receiver's 'FromFragmentCache_FragmentNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_FromFragmentCache_FragmentNameLength put: anInteger!

FromFragmentCache_pFragmentName
	"Answer the <Utf16String> value of the receiver's 'FromFragmentCache_pFragmentName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_FromFragmentCache_pFragmentName)!

FromFragmentCache_pFragmentName: anUtf16String
	"Set the receiver's 'FromFragmentCache_pFragmentName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_FromFragmentCache_pFragmentName put: anUtf16String yourAddress!

FromFragmentCacheEx_ByteRange
	"Answer the <HTTP_BYTE_RANGE> value of the receiver's 'FromFragmentCacheEx_ByteRange' field."

	^HTTP_BYTE_RANGE fromAddress: bytes yourAddress + _OffsetOf_FromFragmentCacheEx_ByteRange!

FromFragmentCacheEx_ByteRange: aHTTP_BYTE_RANGE
	"Set the receiver's 'FromFragmentCacheEx_ByteRange' field to the value of the argument, aHTTP_BYTE_RANGE"

	aHTTP_BYTE_RANGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_FromFragmentCacheEx_ByteRange + 1)
		to: ##(_OffsetOf_FromFragmentCacheEx_ByteRange + HTTP_BYTE_RANGE basicByteSize)
		startingAt: 1!

FromFragmentCacheEx_pFragmentName
	"Answer the <Utf16String> value of the receiver's 'FromFragmentCacheEx_pFragmentName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_FromFragmentCacheEx_pFragmentName)!

FromFragmentCacheEx_pFragmentName: anUtf16String
	"Set the receiver's 'FromFragmentCacheEx_pFragmentName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_FromFragmentCacheEx_pFragmentName put: anUtf16String yourAddress!

FromMemory_BufferLength
	"Answer the <Integer> value of the receiver's 'FromMemory_BufferLength' field."

	^bytes dwordAtOffset: _OffsetOf_FromMemory_BufferLength!

FromMemory_BufferLength: anInteger
	"Set the receiver's 'FromMemory_BufferLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_FromMemory_BufferLength put: anInteger!

FromMemory_pBuffer
	"Answer the <ExternalAddress> value of the receiver's 'FromMemory_pBuffer' field."

	^(bytes uintPtrAtOffset: _OffsetOf_FromMemory_pBuffer) asExternalAddress!

FromMemory_pBuffer: anExternalAddress
	"Set the receiver's 'FromMemory_pBuffer' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_FromMemory_pBuffer put: anExternalAddress!

printableFields
	^Array
		with: (#(#FromMemory_pBuffer #FromFileHandle_FileHandle #FromFragmentCache_pFragmentName #FromFragmentCacheEx_pFragmentName)
				at: self DataChunkType + 1)! !
!HTTP_DATA_CHUNK categoriesFor: #data:!accessing!public! !
!HTTP_DATA_CHUNK categoriesFor: #DataChunkType!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #DataChunkType:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_ByteRange!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_ByteRange:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_FileHandle!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFileHandle_FileHandle:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_FragmentNameLength!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_FragmentNameLength:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_pFragmentName!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCache_pFragmentName:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_ByteRange!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_ByteRange:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_pFragmentName!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromFragmentCacheEx_pFragmentName:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_BufferLength!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_BufferLength:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_pBuffer!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #FromMemory_pBuffer:!**compiled accessors**!public! !
!HTTP_DATA_CHUNK categoriesFor: #printableFields!development!printing!private! !

!HTTP_DATA_CHUNK class methodsFor!

data: aByteObject
	^(self new)
		data: aByteObject;
		yourself!

defineFields
	"Define the fields of the HTTP_DATA_CHUNK structure.

	HTTP_DATA_CHUNK compileDefinition

		typedef [uuid(831e8135-6bb5-45e2-b278-10b1c489883a), helpstring('This structure describes an individual data chunk.')]
		struct tagHTTP_DATA_CHUNK {
			[helpstring('The type of this data chunk.')] HTTP_DATA_CHUNK_TYPE DataChunkType;
			[helpstring('The data chunk structures, one per supported data chunk type.')] union {
				[helpstring('From-memory data chunk.')] struct {
					PVOID pBuffer;
					ULONG BufferLength;
				} FromMemory;
				[helpstring('From-file handle data chunk.')] struct {
					HTTP_BYTE_RANGE ByteRange;
					HANDLE FileHandle;
				} FromFileHandle;
				[helpstring('From-fragment cache data chunk.')] struct {
					[helpstring('Size in bytes of FragmentName not including terminating null')] USHORT FragmentNameLength;
					LPCWSTR pFragmentName;
				} FromFragmentCache;
				[helpstring('From-fragment cache data chunk that specifies a byte range.')] struct {
					HTTP_BYTE_RANGE ByteRange;
					[helpstring('Null-terminated string')] LPCWSTR pFragmentName;
				} FromFragmentCacheEx;
			};
		} HTTP_DATA_CHUNK;
"

	self
		defineField: #DataChunkType type: SDWORDField new offset: 0;
		defineField: #FromMemory_pBuffer type: LPVOIDField new offset: 8;
		defineField: #FromMemory_BufferLength type: DWORDField new offset: 12;
		defineField: #FromFileHandle_ByteRange type: (StructureField type: HTTP_BYTE_RANGE) offset: 8;
		defineField: #FromFileHandle_FileHandle type: HANDLEField new offset: 24;
		defineField: #FromFragmentCache_FragmentNameLength type: WORDField new offset: 8;
		defineField: #FromFragmentCache_pFragmentName type: (PointerField type: Utf16String) offset: 12;
		defineField: #FromFragmentCacheEx_ByteRange type: (StructureField type: HTTP_BYTE_RANGE) offset: 8;
		defineField: #FromFragmentCacheEx_pFragmentName type: (PointerField type: Utf16String) offset: 24.
	self byteSize: 32!

getFieldNames
	^#(#DataChunkType #FromFileHandle_ByteRange #FromFragmentCache_FragmentNameLength #FromFragmentCacheEx_ByteRange #FromMemory_pBuffer #FromFragmentCache_pFragmentName #FromMemory_BufferLength #FromFileHandle_FileHandle #FromFragmentCacheEx_pFragmentName)! !
!HTTP_DATA_CHUNK class categoriesFor: #data:!instance creation!public! !
!HTTP_DATA_CHUNK class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_DATA_CHUNK class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

