Class {
	#name : #PDSBloomFilterPlaygroundContent,
	#superclass : #ComposablePresenter,
	#instVars : [
		'addAction',
		'testAction',
		'bloomInspector',
		'viewer'
	],
	#category : #'PDS-Playground-Membership'
}

{ #category : #specs }
PDSBloomFilterPlaygroundContent class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :column | 
					column
						add: #addAction;
						add: #testAction ];
				add: #bloomInspector ]
			height: 2 * (self labelHeight * 4 + self buttonHeight);
		newRow: [ :row | row add: #viewer ];
		yourself
]

{ #category : #accessing }
PDSBloomFilterPlaygroundContent >> addAction [
	^ addAction
]

{ #category : #api }
PDSBloomFilterPlaygroundContent >> bloom: aBloom [
	self addAction bloom: aBloom.
	self testAction bloom: aBloom.
	bloomInspector := GlamourPresentationPresenter new
		presentationClass: GTInspector
		startOn: aBloom.
	self viewer bloom: aBloom.
	self needRebuild: false.
	self buildWithSpecLayout: self class defaultSpec
]

{ #category : #accessing }
PDSBloomFilterPlaygroundContent >> bloomInspector [
	^ bloomInspector
]

{ #category : #initialization }
PDSBloomFilterPlaygroundContent >> extent [
^ 800 @ 600
]

{ #category : #initialization }
PDSBloomFilterPlaygroundContent >> initializePresenter [
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
				ifTrue: [ element asString , ' maybe contained with FPP = '
						, ((filter fpp * 100) round: 5) asString , '%' ]
				ifFalse: [ element asString , ' is not in the filter.' ] ]
]

{ #category : #initialization }
PDSBloomFilterPlaygroundContent >> initializeWidgets [
	addAction := self instantiate: PDSBloomFilterActionForm.
	testAction := self instantiate: PDSBloomFilterActionForm.
	bloomInspector := self newLabel.
	viewer := self instantiate: PDSBloomFilterViewer.
	addAction
		header: 'Add elements';
		description: 'Write the text you want to add to the filter.';
		ghostText: 'e.g. Madrid';
		buttonLabel: 'Add';
		resultLabel: ''.
	testAction
		header: 'Membership test';
		description: 'Check if a given text is a member of the filter.';
		ghostText: 'E.g. London';
		buttonLabel: 'Test';
		resultLabel: ''.
	self focusOrder
		add: addAction;
		add: testAction;
		add: bloomInspector;
		add: viewer
]

{ #category : #accessing }
PDSBloomFilterPlaygroundContent >> testAction [
	^ testAction
]

{ #category : #initialization }
PDSBloomFilterPlaygroundContent >> title [
^ 'BloomFilter Playground Content'
]

{ #category : #accessing }
PDSBloomFilterPlaygroundContent >> viewer [
	^ viewer
]
