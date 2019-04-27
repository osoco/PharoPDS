Class {
	#name : #PDSAlgorithmsBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'algorithms',
		'view',
		'state'
	],
	#category : #'PDS-Playground-Browser'
}

{ #category : #specs }
PDSAlgorithmsBrowser class >> defaultSpec [
	^ SpecRowLayout composed
		newColumn: [ :c | c add: #algorithms ] width: 224;
		addSplitter;
		newColumn: [ :c | c add: #view ];
		yourself
]

{ #category : #'instance creation' }
PDSAlgorithmsBrowser class >> open [ 
<script: 'self open'>

self new openWithSpec 
]

{ #category : #accessing }
PDSAlgorithmsBrowser >> algorithms [
	^ algorithms
]

{ #category : #'initialize-release' }
PDSAlgorithmsBrowser >> defaultView [
| cm |
cm := self newLabel.
cm label: 'Select something from the list please.'.
^cm
]

{ #category : #api }
PDSAlgorithmsBrowser >> extent [
	^ 1024 @ 800
]

{ #category : #initialization }
PDSAlgorithmsBrowser >> initializePresenter [
	algorithms
		whenSelectedItemChanged: [ :aPlayground | 
			view := self instantiate: aPlayground.
			self needRebuild: false.
			self buildWithSpec ]
]

{ #category : #initialization }
PDSAlgorithmsBrowser >> initializeWidgets [
	algorithms := self instantiate: PDSAlgorithmsList.
	"state := $h."
	view := self defaultView
]

{ #category : #accessing }
PDSAlgorithmsBrowser >> state [
	^ state
]

{ #category : #initialization }
PDSAlgorithmsBrowser >> title [ 
^'PDS Algorithms Viewer'
]

{ #category : #accessing }
PDSAlgorithmsBrowser >> view [
	^ view
]

{ #category : #'as yet unclassified' }
PDSAlgorithmsBrowser >> widgetFor: aData [
	| cm |
	aData  = 'Bloom Filter'
		ifTrue: [ cm := self instantiate: BloomFilterPlayground.
			^ cm ]
		ifFalse: [ ^ self defaultView ]
]
