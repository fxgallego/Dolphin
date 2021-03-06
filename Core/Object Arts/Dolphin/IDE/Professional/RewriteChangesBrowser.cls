﻿"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #RewriteChangesBrowser
	instanceVariableNames: 'changesPresenter differencesPresenter compositeChange'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RewriteChangesBrowser guid: (GUID fromString: '{99c85442-1f6a-4912-a74b-7449ae28471b}')!
RewriteChangesBrowser comment: ''!
!RewriteChangesBrowser categoriesForClass!MVP-Presenters! !
!RewriteChangesBrowser methodsFor!

acceptAllChanges
	RefactoryChangeManager instance performChange: compositeChange.
	self exit!

acceptChanges
	self acceptChanges: self changes!

acceptChanges: aCollection 
	RefactoryChangeManager instance performChange: (compositeChange
				copy;
				changes: aCollection;
				yourself).
	self removeChanges: aCollection!

acceptClassChanges
	self change changeClass ifNotNil: 
			[:class | 
			self acceptChanges: (changesPresenter model select: [:each | each changeClass == class])]!

acceptPackageChanges
	self change package ifNotNil: 
			[:package | 
			self acceptChanges: (changesPresenter model select: [:each | each package == package])]!

browseIt
	"Open a new default browser on the current image definition of the method which will
	be modified by the selected change."

	| change |
	change := self change.
	Smalltalk developmentSystem 
		browseMethod: (change changeClass compiledMethodAt: change selector)!

change
	| changes |
	changes := self changes.
	^changes size = 1 ifTrue: [changes first]!

changes
	^changesPresenter selections!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	changesPresenter := self add: ListPresenter new name: 'changes'.
	differencesPresenter := self add: DifferencesPresenter new name: 'differences'.
	differencesPresenter
		beforeTitle: 'Current Method';
		afterTitle: 'After Change'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	changesPresenter
		when: #actionPerformed
			send: #browseIt
			to: self;
		when: #selectionChanged
			send: #onChangeSelected
			to: self.
	(self systemModel)
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self!

deferredSelectCaret
	[self selectCaret] postToMessageQueue!

methodChanged: aCompiledMethod 
	self change ifNotNil: 
			[:change | 
			(aCompiledMethod selector == change selector 
				and: [aCompiledMethod methodClass == change changeClass]) ifTrue: [self onChangeSelected]]!

model: aCompositeRefactoryChange 
	super model: self class defaultModel.
	compositeChange := aCompositeRefactoryChange.
	changesPresenter list: compositeChange changes.
	compositeChange changes: changesPresenter model!

onChangeSelected
	| change method class |
	change := self change.
	change ifNil: 
			[differencesPresenter clear.
			^self].
	class := change changeClass.
	method := class compiledMethodAt: change selector ifAbsent: [].
	differencesPresenter compare: (method ifNil: [''] ifNotNil: [:m | m getSource])
		with: change source!

onMethodAdded: aCompilationResult 
	self methodChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod 
	self methodChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult 
	self methodChanged: aCompilationResult method!

onViewAvailable
	super onViewAvailable.
	differencesPresenter
		textFont: MethodWorkspace actualFont;
		styler: SmalltalkMethodStyler new;
		textStyles: MethodWorkspace textStyles!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>."

	| selector |
	selector := aCommandQuery commandSymbol.
	(#(#browseIt #acceptClassChanges #acceptPackageChanges #removeClassChanges #removePackageChanges #inspectIt) 
		includes: selector) 
			ifTrue: 
				[aCommandQuery isEnabled: self change notNil.
				^true].
	(#(#acceptChanges #removeChanges) includes: selector) 
		ifTrue: 
			[| selected |
			selected := self changes size.
			aCommandQuery
				isEnabled: selected > 0;
				text: (aCommandQuery description expandMacrosWith: selected = 1).
			^true].
	^super queryCommand: aCommandQuery!

removeChanges
	self removeChanges: self changes!

removeChanges: aCollection 
	changesPresenter model removeAll: aCollection.

	"The browser is more useful if it automatically selects another item when some are deleted"
	self deferredSelectCaret!

removeChangesMatching: discriminatorBlock 
	self removeChanges: (changesPresenter model select: discriminatorBlock)!

removeClassChanges
	self change changeClass 
		ifNotNil: [:class | self removeChangesMatching: [:each | each changeClass == class]]!

removePackageChanges
	self change package 
		ifNotNil: [:package | self removeChangesMatching: [:each | each package == package]]!

selectCaret
	| caret |
	caret := changesPresenter view caretIndex.
	^caret isZero ifFalse: [changesPresenter view selectionsByIndex: (Array with: caret)]!

setInitialFocus
	changesPresenter view tabFirst!

updateCaption
	self caption: compositeChange displayString! !
!RewriteChangesBrowser categoriesFor: #acceptAllChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #acceptChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #acceptChanges:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #acceptClassChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #acceptPackageChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #browseIt!commands!public! !
!RewriteChangesBrowser categoriesFor: #change!accessing!private! !
!RewriteChangesBrowser categoriesFor: #changes!accessing!public! !
!RewriteChangesBrowser categoriesFor: #createComponents!initializing!public! !
!RewriteChangesBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!RewriteChangesBrowser categoriesFor: #deferredSelectCaret!helpers!private! !
!RewriteChangesBrowser categoriesFor: #methodChanged:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #model:!accessing!public! !
!RewriteChangesBrowser categoriesFor: #onChangeSelected!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onMethodAdded:!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onMethodRemoved:!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onMethodUpdated:!event handling!public! !
!RewriteChangesBrowser categoriesFor: #onViewAvailable!event handling!public! !
!RewriteChangesBrowser categoriesFor: #queryCommand:!commands!private! !
!RewriteChangesBrowser categoriesFor: #removeChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #removeChanges:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #removeChangesMatching:!helpers!private! !
!RewriteChangesBrowser categoriesFor: #removeClassChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #removePackageChanges!commands!public! !
!RewriteChangesBrowser categoriesFor: #selectCaret!helpers!private! !
!RewriteChangesBrowser categoriesFor: #setInitialFocus!operations!public! !
!RewriteChangesBrowser categoriesFor: #updateCaption!public!updating! !

!RewriteChangesBrowser class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^MethodBrowser icon!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 327686 ##(Smalltalk.Color) #default 8 1883845616 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 63 1 674 553 51 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(Smalltalk.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 63 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 850 ##(Smalltalk.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 615 1 674 437 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1600 nil nil nil 7 nil nil nil 1600 850 ##(Smalltalk.Toolbar) #resource_Find_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 155 51 674 109 51 1600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 25 0 0 0 131 0 0 0 50 0 0 0] 1072 1088 nil 27 8 'findTools' 170 192 1072 138 144 1072 nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 1 674 1169 101 528 946 #updateSizePosted 1072 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 5 1120 784 1360 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 2096 nil nil nil 519 nil nil nil 2096 nil 8 1883845616 170 192 1072 170 192 34 6 28379 1115206 1 ##(Smalltalk.ToolbarIconButton) 2096 1 1180998 4 ##(Smalltalk.CommandDescription) #removeChanges 8 'Remove Change(s)' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditClear.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 28379 28383 2226 2096 1 2258 #acceptAllChanges nil 1 1 2306 nil true 2352 8 'FileSaveAll.ico' 2400 28383 28381 2226 2096 1 2258 #acceptChanges 8 'Accept Change(s)' 1 1 2306 nil true 2352 8 'FileSave.ico' 2400 28381 34 4 2240 2496 2432 1049158 1 ##(Smalltalk.ToolbarSeparator) 2096 1 nil nil 1 nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 1 51 674 155 51 2096 946 #updateSizePosted 1072 2096 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 77 0 0 0 50 0 0 0] 8 #() 1088 nil 27 1600 1088 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2800 nil nil nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 2800 nil 8 1883634224 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2800 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 138 144 34 1 2992 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2800 nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 643 674 1169 41 2800 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1088 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3248 nil nil nil 7 nil nil nil 3248 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 3 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ReferenceView) 34 14 nil 3248 34 2 8 1140850688 131073 3408 nil nil nil 7 nil nil nil 3408 850 ##(Smalltalk.DifferencesPresenter) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 223 674 1169 321 3408 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 111 0 0 0 72 2 0 0 15 1 0 0] 1072 1088 nil 27 7 3378 410 ##(Smalltalk.Splitter) 34 12 nil 3248 34 2 8 1140850688 1 3648 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3648 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 3744 nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 213 674 1169 11 3648 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 0 0 0 72 2 0 0 111 0 0 0] 8 #() 1088 nil 27 1 3378 410 ##(Smalltalk.ListView) 34 45 nil 3248 34 2 8 1140920393 1 3952 590662 2 ##(Smalltalk.ListModel) 138 144 1072 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 720 nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 2258 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 4146 1 2258 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 4146 1 2258 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 4146 1 2258 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4146 1 2258 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 4146 1 2258 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 4146 1 2258 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4354 4097 4146 2097153 2258 #browseIt 8 '&Browse Method' 1 1 2306 nil true 2352 8 'ClassBrowserShell.ico' 2400 nil nil 8 '&Change' nil 134217729 nil nil nil nil nil nil nil 3952 nil 8 1883852064 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayString]' 8 #[30 105 17 158 106] #displayString 4672 7 257 nil ##(Smalltalk.ListView) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 674 65 65 nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Class' 301 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 4658 0 nil 4690 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each displayClassName]' 8 #[30 105 17 158 106] #displayClassName 4944 7 257 nil nil 3952 ##(Smalltalk.IconicListAbstract) 1 nil nil 4850 8 'Selector' 401 #left ##(Smalltalk.BasicListAbstract) 4898 #<= 8 #() 4658 0 nil 4690 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each selector]' 8 #[30 105 17 158 106] #selector 5088 7 257 nil nil 3952 ##(Smalltalk.IconicListAbstract) 1 nil nil 4850 8 'Package' 201 #left 4658 0 nil 4690 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each name]' 8 #[30 105 17 158 106] #name 5200 7 257 nil 4658 0 nil 4690 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5280 7 513 nil 4658 0 nil 4690 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each |
((each changeClass compiledMethodAt: each selector ifAbsent:[])
	ifNil: [each changeClass]
	ifNotNil: [:method | method]) owningPackage]' 8 #[33 105 17 158 17 159 34 192 100 223 3 73 158 110 70 161 106] #changeClass #selector #compiledMethodAt:ifAbsent: #owningPackage 5360 4658 0 nil 4690 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 34 2 8 '[]' nil 8 #[29 105 60 106] 5440 7 1 nil 7 65793 nil nil 3952 nil 1 nil nil 4850 8 'Change' 261 #left 4898 #yourself 8 #() 4898 #<= 5584 4898 #changeString 5584 nil 3952 nil 3 nil nil #report 1072 nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 1 1 674 1169 213 3952 946 #contextMenu: 34 1 4112 3952 946 #text: 34 1 8 'Class' 3952 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 106 0 0 0] 8 #() 1088 nil 35 5 true 170 192 34 2 3952 8 'changes' nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 101 674 1169 543 3248 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 3 3952 3648 3408 1088 nil 27 170 192 34 4 528 8 'toolbar' 2800 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 4098 nil true 34 3 4146 1 2258 #saveImage 8 'Sa&ve Image' 1 1 2306 nil true 2352 8 'Snapshot.ico' 2400 nil nil 4354 4097 4146 1 2258 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 28293 nil nil 4098 nil true 34 6 4146 1 2258 #copySelection 8 '&Copy' 9351 1 2306 nil true 2352 8 'EditCopy.ico' 2400 nil nil 4146 1 2258 #selectAll 8 'Select &All' 9347 1 nil nil nil 4354 4097 4146 1 2258 #find 8 '&Find...' 9357 1 2306 nil true 2352 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4146 1 2258 #findNext 8 'Find &Next' 1253 1 2306 nil true 2352 8 'FindNext.ico' 2400 nil nil 4146 1 2258 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 28305 nil nil 4098 nil true 34 10 4146 1 2258 #acceptChanges 8 '&Accept <1?Change:Changes>' 1 1 nil nil nil 4146 1 2258 #acceptClassChanges 8 'Accept &Class Changes' 1 1 nil nil nil 4146 1 2258 #acceptPackageChanges 8 'Accept &Package Changes' 1 1 nil nil nil 4146 1 2258 #acceptAllChanges 8 'Accept A&ll Changes' 1 1 nil nil nil 4354 4097 4146 1 2258 #removeChanges 8 '&Remove <1?Change:Changes>' 1 1 nil nil nil 4146 1 2258 #removeClassChanges 8 'R&emove Class Changes' 1 1 nil nil nil 4146 1 2258 #removePackageChanges 8 'Re&move Package Changes' 1 1 nil nil nil 4354 4097 4146 2097153 2258 #browseIt 8 '&Browse Method' 1 1 4592 nil nil 8 '&Change' nil 134217729 nil nil 28323 nil nil 4098 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 28325 nil nil 4098 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 28327 nil nil 4098 nil true 34 15 4146 1 2258 #helpContents 8 '&Contents' 1025 1 2306 nil true 2352 8 'Help.ico' 2400 nil nil 4146 1 2258 #help 8 'On this &Tool' 1249 1 nil nil nil 4146 1 2258 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4354 4097 4146 1 2258 #learnSmalltalk 8 'Learn Smalltalk' 1 1 6370 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 4354 4097 4146 1 2258 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4146 1 2258 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4146 1 2258 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4354 4097 4146 1 2258 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2306 nil true 2352 8 '!!APPLICATION' 2400 nil nil 4146 1 2258 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4146 1 2258 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4354 4097 4146 1 2258 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6370 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 28351 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 3 946 #createAt:extent: 34 2 674 7039 21 674 1201 801 416 946 #text: 34 1 8 'Rewrite Results Browser' 416 946 #updateMenuBar 1072 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 23 16 0 0 154 1 0 0] 34 3 528 3248 2800 1088 nil 27 )! !
!RewriteChangesBrowser class categoriesFor: #icon!constants!public! !
!RewriteChangesBrowser class categoriesFor: #publishedAspects!operations!public! !
!RewriteChangesBrowser class categoriesFor: #resource_Default_view!public!resources-views! !

