Class {
	#name : #PDSBloomFilterCreationForm,
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
PDSBloomFilterCreationForm class >> defaultSpec [
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
PDSBloomFilterCreationForm >> initializePresenter [
	targetElements whenTextChanged: self validationBlock.
	targetFpp whenTextChanged: self validationBlock

	
]

{ #category : #initialization }
PDSBloomFilterCreationForm >> initializeWidgets [
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
PDSBloomFilterCreationForm >> labelFpp [
	^ labelFpp
]

{ #category : #accessing }
PDSBloomFilterCreationForm >> labelTargetElements [
	^ labelTargetElements
]

{ #category : #private }
PDSBloomFilterCreationForm >> maxTargetElements [
^ 200
]

{ #category : #private }
PDSBloomFilterCreationForm >> maxTargetFpp [
	^ 0.99
]

{ #category : #private }
PDSBloomFilterCreationForm >> minTargetFpp [
	^ 0.01
]

{ #category : #accessing }
PDSBloomFilterCreationForm >> targetElements [
	^ targetElements
]

{ #category : #accessing }
PDSBloomFilterCreationForm >> targetFpp [
	^ targetFpp
]

{ #category : #private }
PDSBloomFilterCreationForm >> validateParameters [
	^ [ self validateTargetElements and: self validateTargetFpp ]
		on: Error
		do: [ false ]
]

{ #category : #private }
PDSBloomFilterCreationForm >> validateTargetElements [
	| targetElementsValue |
	targetElementsValue := targetElements text asInteger.
	^ targetElementsValue isNotNil and: targetElementsValue <= self maxTargetElements
]

{ #category : #private }
PDSBloomFilterCreationForm >> validateTargetFpp [
	| targetFppValue |
	targetFppValue := targetFpp text asNumber.
	^ targetFppValue isNotNil
		and: (targetFppValue between: 0.01 and: 1.0)
]

{ #category : #private }
PDSBloomFilterCreationForm >> validationBlock [
	^ [ | newAreValidParameters |
	newAreValidParameters := self validateParameters.
	areValidParameters ~= newAreValidParameters
		ifTrue: [ areValidParameters := newAreValidParameters.
			validationChangedBlock
				ifNotNil: [ validationChangedBlock value: areValidParameters ] ] ]
]

{ #category : #'api - events' }
PDSBloomFilterCreationForm >> whenParametersValidationResultChangedDo: aBlock [
	"Set a block to perform when the parameters validation result changed.
	The block receives one argument with the new validation value as Boolean."
	validationChangedBlock := aBlock
]
