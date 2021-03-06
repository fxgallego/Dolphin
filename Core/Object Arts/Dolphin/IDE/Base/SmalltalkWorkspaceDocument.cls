﻿"Filed out from Dolphin Smalltalk 7"!

AbstractDocumentShell subclass: #SmalltalkWorkspaceDocument
	instanceVariableNames: 'workspacePresenter searchPresenter'
	classVariableNames: 'CanUseIdeaSpace DefaultExtent DefaultView LanguageExtensions ReuseIfOpen VariableTips'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkWorkspaceDocument guid: (GUID fromString: '{87b4c6ba-026e-11d3-9fd7-00a0cc3e4a32}')!
SmalltalkWorkspaceDocument comment: '`SmalltalkWorkspaceDocument` is a `<documentPresenter>` that can be used for displaying Smalltalk ST and CLS files. It also allows for the evaluation of Smalltalk expressions and the execution of various other commands targeted at the `SmalltalkSystem` singleton instance.

Instance Variables:
	workspacePresenter	`SmalltalkWorkspace` holding the workspace text.

Class Variables:
	ReuseIfOpen	`<boolean>` indicating whether an open workspace should be re-used in preference to opening a new one.

'!
!SmalltalkWorkspaceDocument categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!SmalltalkWorkspaceDocument methodsFor!

aboutDolphin
	"Show the About box."

	self model aboutDolphin!

applyOptions
	self systemModel applyOptionsToTool: self!

browsePackages
	"Open a new package browser."
	
	self model browsePackages!

buildPopupForCommand: aSymbol 
	aSymbol == #newIdeaSpace ifTrue: [^SmalltalkToolShell buildIdeaSpacePopup].
	^nil!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

chooseDefaultFont
	"Launch a dialog to prompt for a change in the default font used by the system tools."
	
	self model chooseDefaultFont!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	workspacePresenter := self add: self class workspaceClass new name: 'workspace'.
	workspacePresenter areVariableTipsEnabled: self class variableTips.
	searchPresenter := self 
				add: SmalltalkSearchPresenter new
				name: 'search'
				helpId: 10510!

createSchematicWiring
	super createSchematicWiring.
	self 
		when: #dropFiles:
		send: #onDropFiles:over:
		to: self systemModel
		withArguments: (Array with: nil with: self)!

defaultHelpId
	^10729!

destroy
	"Attempt to forcibly close the receiver's view. If this is an IdeaSpace card then we ask the IdeaSpace to destroy it."

	self isIdeaSpaceCard ifTrue: [^self ideaSpace destroyCard: self].
	^super destroy!

displayOn: aStream
	aStream display: self shortCaption!

dropClassFile: aString 
	self dropScriptFile: aString!

dropPackageFile: aString 
	self dropScriptFile: aString!

dropScriptFile: aString 
	self dropTextFile: aString!

dropTextFile: aString 
	"Private - The file with the specified full pathname has been dropped over the receiver.
	Behave as notepad and load it into this workspace."

	self promptToSaveChanges ifFalse: [^self].
	self filename: aString.
	self fileLoad!

dropXmlFile: aString 
	self dropTextFile: aString!

educationCenter
	"Open the local Education Centre page"

	self model educationCenter!

exit
	"Attempt to close the receiver's view. If this is an IdeaSpace card then we ask the IdeaSpace to close it."

	self isIdeaSpaceCard ifTrue: [^self ideaSpace closeCard: self].
	^super exit!

fileFileIn
	"The user has selected the standard File/File In command. File in the 
	current contents of the receiver."

	self model fileFileIn!

fileLoad
	| caret |
	caret := self workspace view caretPosition.
	self hasFilename ifTrue: [self setLexer].
	super fileLoad.
	(self workspace view)
		caretPosition: caret;
		ensureCaretVisible!

fileNew
	"The user has selected the standard File/New command. Use this
	to create a new workspace"

	^self model newWorkspace!

fileOpen
	"Create a new workspace window on a file"

	self openWorkspace!

forgetSize
	"Forget the default size for new instances of this tool."

	self class defaultExtent: nil!

getDocumentData
	"Private - Answer the data for the receiver's document"

	^self workspace text!

guidedTour
	"Open the guided tour page"

	self model guidedTour!

hasContents
	^self hasFilename or: [self getDocumentData notEmpty]!

help
	"Brings up a help page for the receiver"

	self model openHelpTopicForTool: self!

ideaSpace
	^(self class environment lookup: #IdeaSpaceShell)
		ifNotNil: [:ideaSpaceShellClass | (self topShell isKindOf: ideaSpaceShellClass) ifTrue: [self topShell]]!

inspectSystemOptions
	"Open an <AccessorInspector> on the system options."

	| inspector |
	inspector := PublishedAspectInspector shellOn: self class.
	inspector topShell caption: self class name , ' Options'!

isIdeaSpaceCard
	^self ideaSpace notNil!

isModified
	"Answer whether the document in the receiver has been modified."

	^workspacePresenter isModified!

isModified: aBoolean
	"Set/reset the receiver's dirty flag."

	workspacePresenter isModified: aBoolean!

isText
	"Answer true if the receiver is a text document"

	^true!

language: aSymbol
	workspacePresenter view lexer: aSymbol!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	popup := self buildPopupForCommand: aToolbarButton command asSymbol.
	popup isNil ifTrue: [^nil].
	popup queryAllFromView: self view.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onViewOpened
	"Private - Received when the receiver's view has been connected. 
	Transfer any file contents across to the view"

	| modifiedModel toolbar |
	super onViewOpened.
	self view acceptDroppedFiles: true.
	(self view viewNamed: 'errors' ifNone: []) 
		ifNotNil: [:item | item model: self workspace errorModel].
	modifiedModel := self workspace modifiedModel.
	(self view viewNamed: 'modified' ifNone: []) ifNotNil: [:item | item model: modifiedModel].
	modifiedModel 
		when: #valueChanged
		send: #updateCaption
		to: self.
	"Enable toolbar pulldowns"
	toolbar := self view viewNamed: 'smalltalkTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: self.
	self applyOptions.
	self fileLoad!

openViewComposer
	"Open a new view composer"
	
	self model openViewComposer!

openWorkspace
	"Prompt for a workspace filename and open the contents inside the receiver if it is empty. Otherwise
	create a new SmalltalkWorkspaceDocument to hold the contents of the file."

	| openFilename |
	self hasContents ifTrue: [^self model openWorkspace].
	openFilename := self class getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	(#(#dragToolToIdeaSpace #addToNewIdeaSpace) includes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self isIdeaSpaceCard not.
			^true].
	^super queryCommand: aCommandQuery!

rememberThisSize
	"Record the size of the receiver as the default extent for its tool class."

	self class defaultExtent: self view extent!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream 
		nextPutAll: '[:aSmalltalkWorkspaceDocument | 
	aSmalltalkWorkspaceDocument workspace evaluationPools: '.
	self workspace evaluationPools literalStoreEvaluationOn: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aSmalltalkWorkspaceDocument.'.
	aWriteStream nextPutAll: ']'!

searchForClass: aClass 
	^aClass browse!

searchForMethod: aCompiledMethod 
	aCompiledMethod browse!

searchForObject: anObject 
	^anObject inspect!

searchForPackage: aPackage 
	^aPackage browse!

searchForSymbol: aSymbol 
	self 
		routeCommand: (CommandDescription command: (Message selector: #browseMethodsInEnvironments:
						argument: (self systemModel messagesMatching: (MethodSearch newSelector: aSymbol)
								in: BrowserEnvironment new)))!

searchSmalltalk
	| searchView |
	searchView := searchPresenter view.
	searchView hasFocus ifTrue: [^self].
	searchView
		setFocus;
		flash: SmalltalkToolShell searchFieldFlashes!

searchSmalltalkFor: anObject 
	anObject searchForInTool: self!

setDocumentData: text
	"Private - Set the data for the receiver's document to text (a String or RichText)."

	self workspace text: text!

setInitialFocus
	workspacePresenter view setFocus!

setLexer
	self language: (LanguageExtensions at: (File splitExtensionFrom: self filename) ifAbsent: [#text])

!

show
	"Shows the view of the receiver.
	Pick up the default extent if any."

	self class defaultExtent ifNotNil: [:ext | self view extent: ext].
	^super show!

smalltalkExit
	"Request system shutdown - may be cancelled by user."

	self model smalltalkExit!

systemModel
	^SmalltalkSystem current!

workspace
	"Answers the SmalltalkWorkspace held by the receiver."

	^workspacePresenter! !
!SmalltalkWorkspaceDocument categoriesFor: #aboutDolphin!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #applyOptions!public! !
!SmalltalkWorkspaceDocument categoriesFor: #browsePackages!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #buildPopupForCommand:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #canSaveState!private!saved state! !
!SmalltalkWorkspaceDocument categoriesFor: #chooseDefaultFont!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #createComponents!initializing!public! !
!SmalltalkWorkspaceDocument categoriesFor: #createSchematicWiring!initializing!public! !
!SmalltalkWorkspaceDocument categoriesFor: #defaultHelpId!public! !
!SmalltalkWorkspaceDocument categoriesFor: #destroy!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #displayOn:!displaying!public! !
!SmalltalkWorkspaceDocument categoriesFor: #dropClassFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropPackageFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropScriptFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropTextFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropXmlFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #educationCenter!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #exit!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileFileIn!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileLoad!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileNew!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileOpen!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #forgetSize!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #getDocumentData!accessing!private! !
!SmalltalkWorkspaceDocument categoriesFor: #guidedTour!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #hasContents!public! !
!SmalltalkWorkspaceDocument categoriesFor: #help!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #ideaSpace!public! !
!SmalltalkWorkspaceDocument categoriesFor: #inspectSystemOptions!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #isIdeaSpaceCard!public! !
!SmalltalkWorkspaceDocument categoriesFor: #isModified!public!testing! !
!SmalltalkWorkspaceDocument categoriesFor: #isModified:!modes!public! !
!SmalltalkWorkspaceDocument categoriesFor: #isText!public!testing! !
!SmalltalkWorkspaceDocument categoriesFor: #language:!public! !
!SmalltalkWorkspaceDocument categoriesFor: #onDropDown:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #onViewOpened!event handling!private! !
!SmalltalkWorkspaceDocument categoriesFor: #openViewComposer!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #openWorkspace!public! !
!SmalltalkWorkspaceDocument categoriesFor: #queryCommand:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #rememberThisSize!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #saveStateOn:!private!saved state! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForClass:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForMethod:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForObject:!public! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForPackage:!public! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForSymbol:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #searchSmalltalk!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #searchSmalltalkFor:!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #setDocumentData:!accessing!private! !
!SmalltalkWorkspaceDocument categoriesFor: #setInitialFocus!operations!public! !
!SmalltalkWorkspaceDocument categoriesFor: #setLexer!helpers!private! !
!SmalltalkWorkspaceDocument categoriesFor: #show!operations!public! !
!SmalltalkWorkspaceDocument categoriesFor: #smalltalkExit!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #systemModel!accessing!private! !
!SmalltalkWorkspaceDocument categoriesFor: #workspace!accessing!public! !

!SmalltalkWorkspaceDocument class methodsFor!

activeIdeaSpace
	| ideaSpaceShellClass |
	ideaSpaceShellClass := Smalltalk at: #IdeaSpaceShell ifAbsent: [^nil].
	^(View active topShell isKindOf: ideaSpaceShellClass) ifTrue: [View active topShell]!

canUseIdeaSpace
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	CanUseIdeaSpace isNil ifTrue: [ CanUseIdeaSpace := false ].
	^CanUseIdeaSpace!

canUseIdeaSpace: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	CanUseIdeaSpace := aBoolean
!

defaultAdditionalAccelerators
	"Private - Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	^#(#(#inspectIt 'Shift+Ctrl+I'))!

defaultBackcolor
	"Answer the default background colour to use for instances of the receiver."

	^self workspaceClass defaultBackcolor!

defaultBackcolor: aColorOrNil 
	"Set the default background colour to use for instances of the receiver."

	self workspaceClass defaultBackcolor: aColorOrNil!

defaultCaretColor
	"Answer the default caret colour to use for instances of the receiver"

	^self workspaceClass defaultCaretColor !

defaultCaretColor: aColorOrNil 
	"Set the default caret colour to use for instances of the receiver"

	self workspaceClass defaultCaretColor: aColorOrNil!

defaultExtent
	"Answer a <Point> which is the user's chosen default extent for new instances
	of the receiver, or nil if left up to Windows."

	^DefaultExtent!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument.
	If the argument is nil, then let Windows decide."

	DefaultExtent := aPoint!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'st'!

defaultFont
	"Answer the default font to use for instances of the receiver"

	^self workspaceClass defaultFont!

defaultFont: aFontOrNil 
	"Set the default font to use for instances of the receiver"

	self workspaceClass defaultFont: aFontOrNil!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Smalltalk developmentSystem!

defaultTabWidth
	"Answer the width of tabs (equivalent number of spaces) in instances of the receiver."

	^self workspaceClass defaultTabWidth!

defaultTabWidth: anInteger 
	"Answer the width of tabs (equivalent number of spaces) in instances of the receiver."

	self workspaceClass defaultTabWidth: anInteger!

defaultView
	"Answer the resource name of the default view for the receiver.
	This is configurable for tool shells so that the developer can easily replace the
	standard Dolphin views if he or she wishes."

	DefaultView isNil ifTrue: [DefaultView := super defaultView].
	^DefaultView!

defaultView: aString
	"Set the default view name."

	DefaultView := aString!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Workspace'!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	| domain |
	domain := self defaultModel.
	^(OrderedCollection new)
		add: domain smalltalkFilesType;
		add: domain classFilesType;
		add: domain packageFilesType;
		add: domain ideaSpaceFilesType;
		add: #('Text Files (*.txt)' '*.txt');
		add: FileDialog allFilesType;
		asArray!

icon
	"Answers an Icon that can be used to represent this class"

	^SmalltalkWorkspace icon!

initialize
	"Private - Initialize the receiver. Register with SmalltalkSystem.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self wordWrap: true.
	self canUseIdeaSpace: true.
	self defaultExtent: 640 @ 480.
	self variableTips: true.
	LanguageExtensions := (LookupTable new)
				at: 'txt' put: #text;
				at: 'xml' put: #xml;
				yourself.
	#('st' 'cls' 'pac' 'pax' 'chg' 'sml' 'ist') do: [:each | LanguageExtensions at: each put: #container].
	LanguageExtensions isImmutable: true!

isRichTextFile: aString 
	^aString notNil and: [(File splitExtensionFrom: aString) asLowercase = 'rtf']!

openIcon
	"Answers an Icon that can be used to represent the opening of an instance from a file"

	^Icon fromId: 'FileOpen.ico'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| answer |
	answer := super publishedAspects.
	#(#reuseIfOpen #canUseIdeaSpace #wordWrap #variableTips) 
		do: [:each | answer add: (Aspect boolean: each)].
	#(#defaultBackcolor #defaultCaretColor) 
		do: [:each | answer add: (Aspect color: each)].
	answer
		add: (Aspect font: #defaultFont);
		add: (Aspect choice: #defaultView from: self resourceNames);
		add: (Aspect name: #defaultExtent);
		add: self workspaceClass textStylesAspect;
		add: (Aspect integer: #defaultTabWidth);
		yourself.
	^answer!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1906519520 170 192 34 6 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 615 1 882 437 51 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 1 882 1219 51 528 834 #updateSizePosted 976 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 97 2 0 0 25 0 0 0] 34 4 1024 1264 672 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1409289036 131137 1760 nil nil nil 519 nil nil nil 1760 608 8 1906519520 170 192 976 170 192 34 2 22425 1115206 1 ##(Smalltalk.ToolbarIconButton) 1760 1 1180998 4 ##(Smalltalk.CommandDescription) #fileSave 8 'Save' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileSave.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 22425 34 2 1904 1049158 1 ##(Smalltalk.ToolbarSeparator) 1760 1 nil nil 1 nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 1051 1 882 63 51 1760 834 #updateSizePosted 976 1760 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 44 2 0 0 25 0 0 0] 8 #() 992 nil 27 992 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2320 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 882 193 193 nil 2320 nil 8 1906309712 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2320 nil 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) nil 8 'errors' 2530 1 37 2320 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2656 7 257 nil nil 8 'modified' 34 2 2624 2544 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2320 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 859 882 1219 45 2320 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 1 0 0 97 2 0 0 195 1 0 0] 8 #() 992 nil 27 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853708 131073 3008 nil nil nil 519 nil nil nil 3008 608 8 1906519520 170 192 34 6 410 ##(Smalltalk.ReferenceView) 34 14 nil 3008 34 2 8 1140850688 131073 3120 nil nil nil 7 nil nil nil 3120 738 ##(Smalltalk.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 241 882 47 109 3120 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 23 0 0 0 174 0 0 0] 976 992 nil 27 8 'find tools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 3008 34 2 8 1140850688 131073 3360 nil nil nil 7 nil nil nil 3360 738 ##(Smalltalk.Toolbar) #resource_Workspace_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 47 241 3360 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 0 0 0 120 0 0 0] 976 992 nil 27 8 'workspace tools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 3008 34 2 8 1140850688 131073 3600 nil nil nil 7 nil nil nil 3600 738 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 349 882 47 241 3600 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 174 0 0 0 23 0 0 0 38 1 0 0] 976 992 nil 27 8 'edit tools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 1554 1 1 1 770 138 144 34 2 834 #createAt:extent: 34 2 882 1173 51 882 47 809 3008 834 #updateSizePosted 976 3008 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 2 0 0 25 0 0 0 97 2 0 0 173 1 0 0] 34 3 3360 3120 3600 992 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 393217 4080 nil nil nil 7 nil nil nil 4080 498 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4080 34 2 8 1140916224 131073 4160 nil nil nil 23 nil nil nil 4160 738 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1169 805 4160 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 146 1 0 0] 976 992 nil 27 170 192 34 2 4160 8 'workspace' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1173 809 4080 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 74 2 0 0 173 1 0 0] 34 1 4160 992 nil 27 170 192 34 6 2320 8 'statusbar' 3008 8 'toolbar2' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1922 #fileNew 8 '&New' 9373 1 1970 nil true 2016 8 'DocumentShell.ico' 2064 nil nil 4770 1 1922 #fileOpen 8 '&Open...' 9375 1 1970 nil true 2016 8 'OpenWorkspace.ico' 2064 nil nil 4770 1 1922 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4770 1 1922 #fileSave 8 '&Save' 9383 1 1970 nil true 2016 8 'FileSave.ico' 2064 nil nil 4770 1 1922 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 4770 1 1922 #fileRevert 8 '&Revert' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F501 nil nil 594 #commonGreen nil nil 1 nil nil nil nil 4994 4097 4770 1 1922 #saveImage 8 'Sa&ve Image' 1 1 1970 nil true 2016 8 'Snapshot.ico' 2064 nil nil 4770 1 1922 #smalltalkExit 8 'E&xit Dolphin' 1 1 1970 nil true 2016 8 'PowerSwitch.ico' 2064 nil nil 4994 4097 4770 1 1922 #exit 8 '&Close' 17639 1 5202 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 22513 nil nil 4722 nil true 34 12 4770 1 1922 #undo 8 '&Undo' 9397 1 1970 nil true 2016 8 'EditUndo.ico' 2064 nil nil 4770 1 1922 #redo 8 'R&edo' 9395 1 1970 nil true 2016 8 'EditRedo.ico' 2064 nil nil 4994 4097 4770 1 1922 #cutSelection 8 'Cu&t' 9393 1 1970 nil true 2016 8 'EditCut.ico' 2064 nil nil 4770 1 1922 #copySelection 8 '&Copy' 9351 1 1970 nil true 2016 8 'EditCopy.ico' 2064 nil nil 4770 1 1922 #pasteClipboard 8 '&Paste' 9389 1 1970 nil true 2016 8 'EditPaste.ico' 2064 nil nil 4770 1 1922 #clearSelection 8 '&Delete' 1 1 1970 nil true 2016 8 'EditClear.ico' 2064 nil nil 4770 1 1922 #selectAll 8 'Select &All' 9347 1 nil nil nil 4994 4097 4770 1 1922 #editFind 8 '&Find...' 9357 1 1970 nil true 2016 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4770 1 1922 #findNext 8 'Find &Next' 1253 1 1970 nil true 2016 8 'FindNext.ico' 2064 nil nil 4770 1 1922 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 22535 nil nil 4722 nil true 34 17 4770 1 1922 #browseIt 8 '&Browse It' 9349 1 1970 nil true 2016 8 'ClassBrowserShell.ico' 2064 nil nil 4770 1 1922 #displayIt 8 '&Display It' 9353 1 1970 nil true 2016 8 'DisplayIt.ico' 2064 nil nil 4770 1 1922 #printIt 8 '&Print It' 9377 1 1970 nil true 2016 8 'PrintIt.ico' 2064 nil nil 4770 1 1922 #evaluateIt 8 '&Evaluate It' 9355 1 1970 nil true 2016 8 'EvaluateIt.ico' 2064 nil nil 4770 1 1922 #inspectIt 8 '&Inspect It' 9363 1 1970 nil true 2016 8 'InspectIt.ico' 2064 nil nil 4770 1 1922 #debugIt 8 'Deb&ug It' 1269 1 1970 nil true 2016 8 'Debugger.ico' 2064 nil nil 4770 1 1922 #fileItIn 8 '&File it In' 1 1 nil nil nil 4994 4097 4770 1 1922 #chooseEvaluationPools 8 'Pool&s...' 1 1 1970 nil true 2016 8 'Dictionary.ico' 2064 nil nil 4770 1 1922 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4994 4097 4770 1 1922 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 4770 1 1922 #browseReferences 8 '&References...' 5367 1 nil nil nil 4994 4097 4770 1 1922 #clear 8 'C&lear' 1 1 1970 nil true 2016 8 'ClearDocument.ico' 2064 nil nil 4994 4097 4722 nil true 34 9 4770 1 1922 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4770 1 1922 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4770 1 1922 #toggleLineEndings 8 'Line &Endings' 1 1 5202 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4770 1 1922 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4770 1 1922 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4770 1 1922 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4770 1 1922 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4994 4097 4722 nil true 34 3 4770 1 1922 2562 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4770 1 1922 2562 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 4770 1 1922 2562 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 22581 nil nil 8 '&Options' nil 134217729 1970 nil true 2016 8 'Preferences.ico' 2064 nil 22583 nil nil 8 '&Workspace' nil 134217729 nil nil 22585 nil nil 4722 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 22587 nil nil 4722 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 22589 nil nil 4722 nil true 34 15 4770 1 1922 #helpContents 8 '&Contents' 1025 1 1970 nil true 2016 8 'Help.ico' 2064 nil nil 4770 1 1922 #help 8 'On this &Tool' 1249 1 nil nil nil 4770 1 1922 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4994 4097 4770 1 1922 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5202 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4994 4097 4770 1 1922 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4770 1 1922 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4770 1 1922 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4994 4097 4770 1 1922 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1970 nil true 2016 8 '!!APPLICATION' 2064 nil nil 4770 1 1922 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4770 1 1922 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4994 4097 4770 1 1922 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5202 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 22613 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 3839 21 882 1251 1021 416 834 #updateMenuBar 976 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 240 9 0 0 8 2 0 0] 34 4 528 3008 4080 2320 992 nil 27 )!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	ReuseIfOpen isNil ifTrue: [ ReuseIfOpen := false ].
	^ReuseIfOpen!

reuseIfOpen: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	ReuseIfOpen := aBoolean
!

show
	"Shows an instance of the receiver. If reuseIfOpen has been set to true then an 
	existing instance of the receiver will be shown and answered rather than
	a new instance."

	(self canUseIdeaSpace and: [SmalltalkToolShell activeIdeaSpace notNil]) 
		ifTrue: [^SmalltalkToolShell show: self inIdeaSpace: SmalltalkToolShell activeIdeaSpace].
	self reuseIfOpen 
		ifTrue: [(SmalltalkToolShell showExistingInstanceOf: self) ifNotNil: [:tool | ^tool]].
	^super show!

textStyles
	^self workspaceClass textStyles!

textStyles: aCollectionOfScintillaTextStyles 
	"Set the text styles used to colour text in the receiver's instances. These must have the
	names used in the styler, which by default is a <SmalltalkStyler>."

	self workspaceClass textStyles: aCollectionOfScintillaTextStyles!

toolsFolderHelpId
	^10592!

toolsFolderIcon
	"Answer an instance of SmalltalkSystemIcon suitable for representing the
	receiver in the system folder."

	^SmalltalkSystemIcon 
		show: self
		description: self displayString
		helpId: self toolsFolderHelpId!

variableTips
	^VariableTips!

variableTips: aBoolean 
	"Set whether tooltips will be displayed to show the value of workspace variables that the user hovers the mouse over.
	Note that this works even when the workspace is in the background, and uses a relatively high frequency timer to 
	detect the dwell. It has a certain CPU overhead, and so is disabled by default."

	VariableTips := aBoolean!

wordWrap
	"Answer true if instances of the receiver use word wrapping by default."

	^self workspaceClass wordWrap!

wordWrap: aBoolean 
	"Sets the word wrapping state for instances of the receiver to aBoolean."

	self workspaceClass wordWrap: aBoolean!

workspaceClass
	^Smalltalk developmentSystem workspaceClass! !
!SmalltalkWorkspaceDocument class categoriesFor: #activeIdeaSpace!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #canUseIdeaSpace!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #canUseIdeaSpace:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultBackcolor!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultBackcolor:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultCaretColor!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultCaretColor:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultExtent!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultExtent:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultFileExtension!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultFont!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultFont:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultModel!models!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultTabWidth!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultTabWidth:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultView!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultView:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #displayOn:!displaying!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #fileTypes!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #icon!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #initialize!initializing!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #isRichTextFile:!helpers!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #openIcon!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #publishedAspects!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #resource_Default_view!public!resources-views! !
!SmalltalkWorkspaceDocument class categoriesFor: #reuseIfOpen!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #reuseIfOpen:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #show!instance creation!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #textStyles!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #textStyles:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #toolsFolderHelpId!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #toolsFolderIcon!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #variableTips!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #variableTips:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #wordWrap!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #wordWrap:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #workspaceClass!accessing!options!public! !

SmalltalkWorkspaceDocument class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

