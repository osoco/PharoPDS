Class {
	#name : #BloomFilterCreationForm,
	#superclass : #ComposablePresenter,
	#instVars : [
		'labelTargetElements',
		'targetElements',
		'labelFpp',
		'targetFpp',
		'areValidParameters',
		'validationChangedBlock'
	],
	#category : #'PDS-Playground-Membership'
}

{ #category : #specs }
BloomFilterCreationForm class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #labelTargetElements;
				add: #targetElements ]
			height: self inputTextHeight;
		newRow: [ :row | 
			row
				add: #labelFpp;
				add: #targetFpp ] height: self inputTextHeight ;
		yourself
]

{ #category : #initialization }
BloomFilterCreationForm >> initializePresenter [
	targetElements whenTextChanged: self validationBlock.
	targetFpp whenTextChanged: self validationBlock

	
]

{ #category : #initialization }
BloomFilterCreationForm >> initializeWidgets [
	areValidParameters := false.
	labelTargetElements := self newLabel.
	targetElements := self newTextInput autoAccept: true.
	labelFpp := self newLabel.
	targetFpp := self newTextInput autoAccept: true.
	labelTargetElements
		label: 'Target elements (<= ' , self maxTargetElements asString , '):'.
	targetElements ghostText: 'e.g. 100'.
	labelFpp
		label:
			'Target FPP (' , self minTargetFpp asString , ' - '
				, self maxTargetFpp asString , '):'.
	targetFpp ghostText: 'e.g. 0.02'.
	self focusOrder
		add: targetElements;
		add: targetFpp
]

{ #category : #accessing }
BloomFilterCreationForm >> labelFpp [
	^ labelFpp
]

{ #category : #accessing }
BloomFilterCreationForm >> labelTargetElements [
	^ labelTargetElements
]

{ #category : #private }
BloomFilterCreationForm >> maxTargetElements [
^ 200
]

{ #category : #private }
BloomFilterCreationForm >> maxTargetFpp [
	^ 0.99
]

{ #category : #private }
BloomFilterCreationForm >> minTargetFpp [
	^ 0.01
]

{ #category : #accessing }
BloomFilterCreationForm >> targetElements [
	^ targetElements
]

{ #category : #accessing }
BloomFilterCreationForm >> targetFpp [
	^ targetFpp
]

{ #category : #private }
BloomFilterCreationForm >> validateParameters [
	^ [ self validateTargetElements and: self validateTargetFpp ]
		on: Error
		do: [ false ]
]

{ #category : #private }
BloomFilterCreationForm >> validateTargetElements [
	| targetElementsValue |
	targetElementsValue := targetElements text asInteger.
	^ targetElementsValue isNotNil and: targetElementsValue <= self maxTargetElements
]

{ #category : #private }
BloomFilterCreationForm >> validateTargetFpp [
	| targetFppValue |
	targetFppValue := targetFpp text asNumber.
	^ targetFppValue isNotNil
		and: (targetFppValue between: 0.01 and: 1.0)
]

{ #category : #private }
BloomFilterCreationForm >> validationBlock [
	^ [ | newAreValidParameters |
	newAreValidParameters := self validateParameters.
	areValidParameters ~= newAreValidParameters
		ifTrue: [ areValidParameters := newAreValidParameters.
			validationChangedBlock
				ifNotNil: [ validationChangedBlock value: areValidParameters ] ] ]
]

{ #category : #'api - events' }
BloomFilterCreationForm >> whenParametersValidationResultChangedDo: aBlock [
	"Set a block to perform when the parameters validation result changed.
	The block receives one argument with the new validation value as Boolean."
	validationChangedBlock := aBlock
]
