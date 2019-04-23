Class {
	#name : #PDSAlgorithmBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'algorithms',
		'view',
		'state'
	],
	#category : #'PDS-Playground-Browser'
}

{ #category : #specs }
PDSAlgorithmBrowser class >> defaultSpec [
	^ SpecRowLayout composed
		newColumn: [ :c | c add: #algorithms ] width: 224;
		addSplitter;
		newColumn: [ :c | c add: #view ];
		yourself
]

{ #category : #'instance creation' }
PDSAlgorithmBrowser class >> open [ 
<script: 'self open'>

self new openWithSpec 
]

{ #category : #accessing }
PDSAlgorithmBrowser >> algorithms [
	^ algorithms
]

{ #category : #'initialize-release' }
PDSAlgorithmBrowser >> defaultView [
| cm |
cm := self newLabel.
cm label: 'Select something from the list please.'.
^cm
]

{ #category : #api }
PDSAlgorithmBrowser >> extent [
	^ 1024 @ 800
]

{ #category : #initialization }
PDSAlgorithmBrowser >> initializePresenter [
	algorithms
		whenSelectedItemChanged: [ :aPlayground | 
			view := self instantiate: aPlayground.
			self needRebuild: false.
			self buildWithSpec ]
]

{ #category : #initialization }
PDSAlgorithmBrowser >> initializeWidgets [
	algorithms := self instantiate: PDSAlgorithmList.
	"state := $h."
	view := self defaultView
]

{ #category : #accessing }
PDSAlgorithmBrowser >> state [
	^ state
]

{ #category : #initialization }
PDSAlgorithmBrowser >> title [ 
^'PDS Algorithms Viewer'
]

{ #category : #accessing }
PDSAlgorithmBrowser >> view [
	^ view
]

{ #category : #'as yet unclassified' }
PDSAlgorithmBrowser >> widgetFor: aData [
	| cm |
	aData  = 'Bloom Filter'
		ifTrue: [ cm := self instantiate: BloomFilterPlayground.
			^ cm ]
		ifFalse: [ ^ self defaultView ]
]
