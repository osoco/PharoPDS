Class {
	#name : #PDSAlgorithmList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'description'
	],
	#category : #'PDS-Playground-Browser'
}

{ #category : #specs }
PDSAlgorithmList class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #description ] height: self labelHeight;
		add: #list;
		yourself
]

{ #category : #'as yet unclassified' }
PDSAlgorithmList >> availablePlaygrounds [

 ^ AlgorithmPlayground allSubclasses
]

{ #category : #accessing }
PDSAlgorithmList >> description [
	^ description
]

{ #category : #initialization }
PDSAlgorithmList >> initializeWidgets [
	description := self newLabel.
	list := (self instantiate: ListPresenter)
		displayBlock: [ :item | item algorithmName ];
		sortingBlock: [ :itemA :itemB | itemA algorithmName < itemB algorithmName ].
	description label: 'PDS Algorithms'.
	list items: self availablePlaygrounds.
	self focusOrder add: list
]

{ #category : #'accessing - private' }
PDSAlgorithmList >> items [
	list items: { 'Bloom Filter'.'Hiperloglog' }
]

{ #category : #accessing }
PDSAlgorithmList >> list [
	^ list
]

{ #category : #accessing }
PDSAlgorithmList >> title [
	^ 'PDS Algorithms'
]

{ #category : #api }
PDSAlgorithmList >> whenSelectedItemChanged: aBlock [
	list whenSelectedItemChanged: aBlock
]
