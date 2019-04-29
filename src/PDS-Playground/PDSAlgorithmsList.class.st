Class {
	#name : #PDSAlgorithmsList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'description'
	],
	#category : #'PDS-Playground-Browser'
}

{ #category : #specs }
PDSAlgorithmsList class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #description ] height: self labelHeight;
		add: #list;
		yourself
]

{ #category : #'as yet unclassified' }
PDSAlgorithmsList >> availablePlaygrounds [

 ^ PDSAlgorithmPlayground allSubclasses
]

{ #category : #accessing }
PDSAlgorithmsList >> description [
	^ description
]

{ #category : #initialization }
PDSAlgorithmsList >> initializeWidgets [
	description := self newLabel.
	list := (self instantiate: ListPresenter)
		displayBlock: [ :item | item algorithmName ];
		sortingBlock: [ :itemA :itemB | itemA algorithmName < itemB algorithmName ].
	description label: 'PDS Algorithms'.
	list items: self availablePlaygrounds.
	self focusOrder add: list
]

{ #category : #'accessing - private' }
PDSAlgorithmsList >> items [
	list items: { 'Bloom Filter'.'Hiperloglog' }
]

{ #category : #accessing }
PDSAlgorithmsList >> list [
	^ list
]

{ #category : #accessing }
PDSAlgorithmsList >> title [
	^ 'PDS Algorithms'
]

{ #category : #api }
PDSAlgorithmsList >> whenSelectedItemChanged: aBlock [
	list whenSelectedItemChanged: aBlock
]
