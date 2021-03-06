﻿"Filed out from Dolphin Smalltalk 7"!

LayoutManagerTest subclass: #ProportionalLayoutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProportionalLayoutTest guid: (GUID fromString: '{f4808f47-d710-405a-85b3-374be13718e9}')!
ProportionalLayoutTest comment: ''!
!ProportionalLayoutTest categoriesForClass!Unclassified! !
!ProportionalLayoutTest methodsFor!

layoutManagerClass
	^ProportionalLayout!

testSplitterVisibility
	| s1 s2 s3 s4 c1 c2 c3 c4 s5 |
	shell
		addSubView: (s1 := Splitter new);
		addSubView: (c1 := (ContainerView new)
							backcolor: Color red;
							yourself);
		addSubView: (s2 := Splitter new);
		addSubView: (s3 := Splitter new);
		addSubView: (c2 := (ContainerView new)
							backcolor: Color green;
							yourself);
		addSubView: (s4 := Splitter new).
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self assert: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self deny: s4 isWindowVisible.
	shell addSubView: (c3 := (ContainerView new)
						backcolor: Color magenta;
						yourself).
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self assert: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self assert: s4 isWindowVisible.
	c1 hide.
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self deny: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self assert: s4 isWindowVisible.
	c1 show.
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self assert: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self assert: s4 isWindowVisible.
	shell addSubView: (s5 := Splitter new).
	shell addSubView: (c4 := (ContainerView new)
						backcolor: Color blue;
						yourself).
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self assert: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self assert: s4 isWindowVisible.
	self assert: s5 isWindowVisible.
	c3 arrangement: 0.
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self assert: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self assert: s4 isWindowVisible.
	self deny: s5 isWindowVisible.
	c3 arrangement: 1.
	c2 arrangement: 0.
	shell validateLayout.
	self deny: s1 isWindowVisible.
	self assert: s2 isWindowVisible.
	self deny: s3 isWindowVisible.
	self deny: s4 isWindowVisible.
	self assert: s5 isWindowVisible.
! !
!ProportionalLayoutTest categoriesFor: #layoutManagerClass!private!unit tests! !
!ProportionalLayoutTest categoriesFor: #testSplitterVisibility!public!unit tests! !

