Class {
	#name : #BloomFilterPlayground,
	#superclass : #AlgorithmPlayground,
	#instVars : [
		'toolbar',
		'content'
	],
	#category : #'PDS-Membership-Playground'
}

{ #category : #'as yet unclassified' }
BloomFilterPlayground class >> algorithmName [
 ^ 'Bloom Filter'
]

{ #category : #specs }
BloomFilterPlayground class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row  | row add:#toolbar] height: self toolbarHeight;
		add: #content;
		yourself
]

{ #category : #'instance creation' }
BloomFilterPlayground class >> open [
	<script: 'self open'>
 self new openWithSpec
]

{ #category : #accessing }
BloomFilterPlayground >> content [
	^ content
]

{ #category : #initialization }
BloomFilterPlayground >> extent [
	^ 800 @ 800
]

{ #category : #initialization }
BloomFilterPlayground >> initializePresenter [
	toolbar whenBloomCreatedDo: [ :bloom |
		content bloom: bloom
		 ]
]

{ #category : #initialization }
BloomFilterPlayground >> initializeWidgets [
	toolbar := self instantiate: BloomFilterPlaygroundToolbar.
	content := self instantiate: BloomFilterPlaygroundContent.
	self focusOrder add: toolbar; add: content
]

{ #category : #accessing }
BloomFilterPlayground >> name [
	^ 'Bloom Filter'
]

{ #category : #initialization }
BloomFilterPlayground >> title [ 
^ 'BloomFilter Playground'
]

{ #category : #accessing }
BloomFilterPlayground >> toolbar [
	^ toolbar
]
