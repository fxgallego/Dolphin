﻿"Filed out from Dolphin Smalltalk 7"!

SmalltalkWorkspace subclass: #ValueWorkspace
	instanceVariableNames: 'textModel'
	classVariableNames: 'ValueIsSelfCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueWorkspace guid: (GUID fromString: '{87b4c6c9-026e-11d3-9fd7-00a0cc3e4a32}')!
ValueWorkspace comment: 'ValueWorkspace is a <valuePresenter> for displaying the contents of a <valueModel> using a <ScintillaView>. ValueWorkspace allows Smalltalk expressions to be entered and, when Accepted,  the result of the evaluation is stored back to the model. ValueWorkspace is used as a fundamental part of the PublishedAspectInspector.

Note that this is a somewhat unusual MVP triad; the ValueWorkspace model is not connected directly to the view. Instead, the view is redirected (via #viewModel) to another model that holds the textual rendition of the actual model.

Instance Variables:
	textModel		<ValueHolder> holding the textual rendition of the model''s value.

'!
!ValueWorkspace categoriesForClass!MVP-Presenters! !
!ValueWorkspace methodsFor!

accept
	"Accept changes to the receiver by evaluating it, and setting the result into the associated
	model. If there is no selection, then the entire contents of the workspace are accepted."

	| evaluation |
	self displayValue isEmpty 
		ifTrue: 
			["If we have no contents justr leave well alone"
			^true].
	self view hasSelection 
		ifFalse: 
			["We assume that the whole text is to be evaluated. In this case, if the
			 text has not been changed we can ignore the accept and answer true. This
			 will allow the user to just hit enter on some store strings that don't
			 compile."
			self view isModified ifFalse: [^true].
			self view selectAll].
	evaluation := 
			[self evaluateItIfFail: 
					[self showCompileErrorBubble: errorModel value.
					^false]] 
					on: Error
					do: 
						[:x | 
						self showEvaluationErrorBubble: x.
						^false].
	self value: evaluation.
	^true!

beSingleLineMode
	"Set the receiver into single line mode"

	(self view)
		wantReturn: false;
		wordWrap: false; 
		canHScroll: false;
		selectAll!

displayValue
	| value |
	value := self value.
	^[value printString] on: Error
		do: 
			[:ex | 
			self unableToDisplayVariableErrorFormatString 
				expandMacrosWith: 'self'
				with: value class
				with: ex description]!

errorBubbleTimeout
	^2 seconds!

errorLocation
	"Answers the screen coordnates of where the error can be found. Typically this is the base of the caret location in our associated view"

	^self view caretScreenCoordinates + (0 @ self view actualFont pixelSize)!

evaluationContext
	"Answers the evaluation context for this workspace which is in fact the model's value"

	| ctx |
	ctx := super evaluationContext.
	^ctx == ValueIsSelfCookie ifTrue: [self value] ifFalse: [ctx]!

initialize
	"Private - Initialize the receiver's instance variables."

	super initialize.
	textModel := String new asValue.
	self evaluationContext: ValueIsSelfCookie!

isSingleLineMode
	"Answer true if the receiver will only manage a single line of text"

	^self view wantReturn not!

model: aValueModel 
	"Set the model of the receiver to be a value model on anObject."

	super model: aValueModel.
	aValueModel 
		when: #valueChanged
		send: #onValueChanged
		to: self.
	self onValueChanged!

onValueChanged
	"Private - The receiver's model has changed. Transfer the text representation of the new value to the
	textModel"

	textModel value: self displayValue!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the <CommandQuery>
	argument."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #accept 
		ifTrue: 
			[aCommandQuery isEnabled: self model canSet.
			^true].
	^super queryCommand: aCommandQuery!

showCompileErrorBubble: anError 
	self showErrorBubble: anError displayString caption: 'Syntax error'!

showErrorBubble: message caption: caption 
	(MessageBubble new)
		font: (Font name: 'Arial' pointSize: 10);
		timeout: self errorBubbleTimeout;
		isCentered: true;
		position: self errorLocation;
		caption: caption;
		errorMsg: message!

showEvaluationErrorBubble: anError 
	self showErrorBubble: anError displayString caption: 'Evaluation error'!

unableToDisplayVariableErrorFormatString
	"Private - Answer the format string used to construct the error message text to be displayed
	in place of a variable value when a variable is selected that cannot be printed."

	^'an invalid <2p> [<3s>]<n><n>Evaluate the following expression to debug:<n><t>self printString'!

value
	"Answer the model value of the receiver. Any view changes may first need to be flushed"

	self view notNil ifTrue: [self view updateModel].
	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject"

	self model value: anObject.
!

viewModel
	"Private - Answer the model that is to be connected to the view. It is actually
	connected to the receiver's textModel - not the receiver's value model"

	^textModel! !
!ValueWorkspace categoriesFor: #accept!commands!public! !
!ValueWorkspace categoriesFor: #beSingleLineMode!public! !
!ValueWorkspace categoriesFor: #displayValue!accessing!private! !
!ValueWorkspace categoriesFor: #errorBubbleTimeout!constants!private! !
!ValueWorkspace categoriesFor: #errorLocation!private! !
!ValueWorkspace categoriesFor: #evaluationContext!accessing!public! !
!ValueWorkspace categoriesFor: #initialize!initializing!private! !
!ValueWorkspace categoriesFor: #isSingleLineMode!public! !
!ValueWorkspace categoriesFor: #model:!accessing!public! !
!ValueWorkspace categoriesFor: #onValueChanged!event handling!private! !
!ValueWorkspace categoriesFor: #queryCommand:!commands!private! !
!ValueWorkspace categoriesFor: #showCompileErrorBubble:!private! !
!ValueWorkspace categoriesFor: #showErrorBubble:caption:!private! !
!ValueWorkspace categoriesFor: #showEvaluationErrorBubble:!private! !
!ValueWorkspace categoriesFor: #unableToDisplayVariableErrorFormatString!constants!private! !
!ValueWorkspace categoriesFor: #value!accessing!public! !
!ValueWorkspace categoriesFor: #value:!accessing!public! !
!ValueWorkspace categoriesFor: #viewModel!accessing!private! !

ValueWorkspace methodProtocol: #valuePresenter attributes: #(#readOnly) selectors: #(#value #value:)!

!ValueWorkspace class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	ValueIsSelfCookie := (Object new)
				isImmutable: true;
				yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1411453252 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 13 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 578 nil true 34 10 626 1 658 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 706 4097 626 1 658 #cutSelection 8 'Cu&t' 1 1 818 nil true 864 8 'EditCut.ico' 912 nil nil 626 1 658 #copySelection 8 '&Copy' 1 1 818 nil true 864 8 'EditCopy.ico' 912 nil nil 626 1 658 #pasteClipboard 8 '&Paste' 1 1 818 nil true 864 8 'EditPaste.ico' 912 nil nil 626 1 658 #clearSelection 8 'De&lete' 1 1 818 nil true 864 8 'EditClear.ico' 912 nil nil 706 4097 626 1 658 #reformatSource 8 'Re&format' 1 1 nil nil nil 706 4097 626 1 658 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 578 nil true 34 10 626 1 658 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 626 1 658 #cloneNew 8 '&Clone' 1 1 818 nil true 864 8 'SmalltalkWorkspace.ico' 912 nil nil 706 4097 626 1 658 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 626 1 658 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 626 1 658 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 626 1 658 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 626 1 658 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 626 1 658 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 626 1 658 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 706 4097 626 1 658 #browseIt 8 'Bro&wse It' 1 1 818 nil true 864 8 'ClassBrowserShell.ico' 912 nil nil 626 1 658 #displayIt 8 '&Display It' 1 1 818 nil true 864 8 'DisplayIt.ico' 912 nil nil 626 1 658 #printIt 8 '&Print It' 1 1 818 nil true 864 8 'PrintIt.ico' 912 nil nil 626 1 658 #evaluateIt 8 'E&valuate It' 1 1 818 nil true 864 8 'EvaluateIt.ico' 912 nil nil 626 1 658 #inspectIt 8 '&Inspect It' 1 1 818 nil true 864 8 'InspectIt.ico' 912 nil nil 626 1 658 #debugIt 8 'Deb&ug It' 1 1 818 nil true 864 8 'Debugger.ico' 912 nil nil 706 4097 578 nil true 34 2 626 2097153 658 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 626 1 658 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 1533163101 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2754 77 327686 ##(Smalltalk.Color) #gray 2802 #white 1 nil nil nil nil #callTip nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 2896 nil 170 176 2896 nil nil nil nil nil 2802 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 2720 nil nil nil nil 130003 nil 170 192 2896 nil nil 170 192 34 6 #Warning 2754 1027 2802 #darkGoldenrod 2802 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 2754 1029 nil 2802 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 2754 1031 2802 #firebrick 2802 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 12 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 3442 221 41 416 3394 #contextMenu: 34 1 592 416 3394 #textLimit: 8 #(1073741823) 416 3394 #hoverTime: 8 #(500) 416 3394 #caretPeriod: 8 #(530) 416 3394 #wordWrap: 8 #(true) 416 3394 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil 5 nil 3698 3 416 1 nil nil 67108863 5 nil 3698 5 416 1 nil nil nil 5 nil 416 3394 #tabWidth: 8 #(4) 416 3394 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 416 3394 #maxCompletionListHeight: 8 #(9) 416 3394 #edgeColumn: 8 #(1) 416 3394 #hasAdditionalSelectionTyping: 8 #(true) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 45 14 0 0 30 0 0 0] 8 #() 3442 193 193 nil 29 )! !
!ValueWorkspace class categoriesFor: #defaultModel!models!public! !
!ValueWorkspace class categoriesFor: #initialize!initializing!private! !
!ValueWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !

