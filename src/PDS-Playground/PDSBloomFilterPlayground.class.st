Class {
	#name : #PDSBloomFilterPlayground,
	#superclass : #PDSAlgorithmPlayground,
	#instVars : [
		'toolbar',
		'content'
	],
	#category : #'PDS-Playground-Membership'
}

{ #category : #'as yet unclassified' }
PDSBloomFilterPlayground class >> algorithmName [
 ^ 'Bloom Filter'
]

{ #category : #specs }
PDSBloomFilterPlayground class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row  | row add:#toolbar] height: self toolbarHeight;
		add: #content;
		yourself
]

{ #category : #'instance creation' }
PDSBloomFilterPlayground class >> open [
	<script: 'self open'>
 self new openWithSpec
]

{ #category : #accessing }
PDSBloomFilterPlayground >> content [
	^ content
]

{ #category : #initialization }
PDSBloomFilterPlayground >> extent [
	^ 800 @ 800
]

{ #category : #initialization }
PDSBloomFilterPlayground >> initializePresenter [
	toolbar whenBloomCreatedDo: [ :bloom |
		content bloom: bloom
		 ]
]

{ #category : #initialization }
PDSBloomFilterPlayground >> initializeWidgets [
	toolbar := self instantiate: PDSBloomFilterPlaygroundToolbar.
	content := self instantiate: PDSBloomFilterPlaygroundContent.
	self focusOrder add: toolbar; add: content
]

{ #category : #accessing }
PDSBloomFilterPlayground >> name [
	^ 'Bloom Filter'
]

{ #category : #initialization }
PDSBloomFilterPlayground >> title [ 
^ 'BloomFilter Playground'
]

{ #category : #accessing }
PDSBloomFilterPlayground >> toolbar [
	^ toolbar
]
