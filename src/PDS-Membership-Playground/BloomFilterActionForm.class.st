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
	#category : #'PDS-Membership-Playground'
}

{ #category : #specs }
BloomFilterActionForm class >> defaultSpec [
	^ SpecColumnLayout composed
	add: #header;
	add: #description;
	add: #input;
	add: #button;
	add: #result
]

{ #category : #api }
BloomFilterActionForm >> bloom: anObject [
	bloom := anObject
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
	button action: [ self performAction ]
]

{ #category : #initialization }
BloomFilterActionForm >> initializeWidgets [
	header := self newLabel.
	description := self newLabel.
	input := self newTextInput autoAccept: true.
	button := self newButton.
	result := self newLabel.
	header label: 'Form Header'.
	description label: 'Form description.'.
	input ghostText: 'e.g. Value'.
	button label: 'Action'.
	result label: 'Form result.'.
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
