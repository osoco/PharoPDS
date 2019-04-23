Class {
	#name : #BloomFilterActionForm,
	#superclass : #ComposablePresenter,
	#instVars : [
		'header',
		'description',
		'input',
		'button',
		'result',
		'actionBlock',
		'bloom'
	],
	#category : #'PDS-Playground-Membership'
}

{ #category : #specs }
BloomFilterActionForm class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #header;
		add: #description;
		newRow: [ :row | 
			row
				add: #input;
				add: #button width: self buttonWidth  ];
		add: #result
]

{ #category : #api }
BloomFilterActionForm >> bloom: anObject [
	bloom := anObject.
	 self resultLabel: ''
]

{ #category : #accessing }
BloomFilterActionForm >> button [
	^ button
]

{ #category : #api }
BloomFilterActionForm >> buttonLabel: aString [
	button label: aString
]

{ #category : #accessing }
BloomFilterActionForm >> description [
	^ description
]

{ #category : #api }
BloomFilterActionForm >> description: aString [
	description label: aString
]

{ #category : #api }
BloomFilterActionForm >> ghostText: aString [
	input ghostText: aString
]

{ #category : #accessing }
BloomFilterActionForm >> header [
	^ header
]

{ #category : #api }
BloomFilterActionForm >> header: aString [
	header label: aString.
]

{ #category : #initialization }
BloomFilterActionForm >> initializePresenter [
	button
		action: [
			self performAction ]
]

{ #category : #initialization }
BloomFilterActionForm >> initializeWidgets [
	header := self newLabel.
	description := self newLabel.
	input := self newTextInput autoAccept: true.
	button := self newButton.
	result := self newLabel.
	header
		label: 'Form Header';
		emphasis: #bold.
	description label: 'Form description.'.
	input ghostText: 'e.g. Value'.
	input wantsVisualFeedback: false.
	button label: 'Action'.
	result
		label: 'Form result.';
		color: Color blue.
	self focusOrder
		add: input;
		add: button
]

{ #category : #accessing }
BloomFilterActionForm >> input [
	^ input
]

{ #category : #actions }
BloomFilterActionForm >> performAction [
	| resultValue |
	resultValue := actionBlock value: bloom value: input text.
	input text: ''.
	result label: resultValue asString
]

{ #category : #accessing }
BloomFilterActionForm >> result [
	^ result
]

{ #category : #api }
BloomFilterActionForm >> resultLabel: aString [
	result label: aString
]

{ #category : #'api - events' }
BloomFilterActionForm >> whenActionChangedDo: aBlock [
	actionBlock := aBlock
]
