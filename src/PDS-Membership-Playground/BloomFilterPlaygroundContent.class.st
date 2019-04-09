Class {
	#name : #BloomFilterPlaygroundContent,
	#superclass : #ComposablePresenter,
	#instVars : [
		'addAction',
		'testAction',
		'viewer'
	],
	#category : #'PDS-Membership-Playground'
}

{ #category : #specs }
BloomFilterPlaygroundContent class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | 
			row
				add: #addAction;
				add: #testAction ]
			origin: 0 @ 0
			corner: 1 @ 0.4;
		newRow: [ :row | row add: #viewer ] origin: 0 @ 0.4 corner: 1 @ 1;
		yourself 
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> addAction [
	^ addAction
]

{ #category : #api }
BloomFilterPlaygroundContent >> bloom: aBloom [
	self addAction bloom: aBloom.
	self testAction bloom: aBloom.
	self viewer bloom: aBloom.
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> extent [
^ 800 @ 600
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> initializePresenter [
	addAction
		whenActionChangedDo: [ :filter :element | 
			filter add: element asByteArray.
			self viewer refresh.
			element asString , ' added to filter!' ].
	testAction
		whenActionChangedDo: [ :filter :element | 
			| isContained |
			isContained := filter contains: element asByteArray.
			isContained
				ifTrue: [ element asString , ' maybe contained with FPP = ' , filter fpp asString ]
				ifFalse: [ element asString , ' is not contained' ] ]
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> initializeWidgets [
	addAction := self instantiate: BloomFilterActionForm.
	testAction := self instantiate: BloomFilterActionForm.
	viewer := self instantiate: BloomFilterViewer.
	addAction
		header: 'Add elements to filter';
		description: 'bla bla';
		ghostText: 'Madrid';
		buttonLabel: 'Add';
		resultLabel: ''.
	testAction
		header: 'Membership test';
		description: 'bla bla';
		ghostText: 'Element to test membership. E.g. Barcelona';
		buttonLabel: 'Test';
		resultLabel: ''.
	self focusOrder
		add: addAction;
		add: testAction;
		add: viewer
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> testAction [
	^ testAction
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> title [
^ 'BloomFilter Playground Content'
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> viewer [
	^ viewer
]
