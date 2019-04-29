Class {
	#name : #PDSBloomFilterActionForm,
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
PDSBloomFilterActionForm class >> defaultSpec [
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
PDSBloomFilterActionForm >> bloom: anObject [
	bloom := anObject.
	 self resultLabel: ''
]

{ #category : #accessing }
PDSBloomFilterActionForm >> button [
	^ button
]

{ #category : #api }
PDSBloomFilterActionForm >> buttonLabel: aString [
	button label: aString
]

{ #category : #accessing }
PDSBloomFilterActionForm >> description [
	^ description
]

{ #category : #api }
PDSBloomFilterActionForm >> description: aString [
	description label: aString
]

{ #category : #api }
PDSBloomFilterActionForm >> ghostText: aString [
	input ghostText: aString
]

{ #category : #accessing }
PDSBloomFilterActionForm >> header [
	^ header
]

{ #category : #api }
PDSBloomFilterActionForm >> header: aString [
	header label: aString.
]

{ #category : #initialization }
PDSBloomFilterActionForm >> initializePresenter [
	button
		action: [
			self performAction ]
]

{ #category : #initialization }
PDSBloomFilterActionForm >> initializeWidgets [
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
PDSBloomFilterActionForm >> input [
	^ input
]

{ #category : #actions }
PDSBloomFilterActionForm >> performAction [
	| resultValue |
	resultValue := actionBlock value: bloom value: input text.
	input text: ''.
	result label: resultValue asString
]

{ #category : #accessing }
PDSBloomFilterActionForm >> result [
	^ result
]

{ #category : #api }
PDSBloomFilterActionForm >> resultLabel: aString [
	result label: aString
]

{ #category : #'api - events' }
PDSBloomFilterActionForm >> whenActionChangedDo: aBlock [
	actionBlock := aBlock
]
