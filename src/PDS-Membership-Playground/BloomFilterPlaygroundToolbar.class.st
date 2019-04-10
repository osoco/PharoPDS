Class {
	#name : #BloomFilterPlaygroundToolbar,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bloom',
		'create',
		'reset',
		'creationBlock'
	],
	#category : #'PDS-Membership-Playground'
}

{ #category : #specs }
BloomFilterPlaygroundToolbar class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #create; add: #reset ] height: self toolbarHeight;
		yourself
]

{ #category : #accessing }
BloomFilterPlaygroundToolbar >> create [
	^ create
]

{ #category : #initialization }
BloomFilterPlaygroundToolbar >> createBloomFilterWith: size andFpp: fpp [
	bloom := BloomFilter new: size fpp: fpp.
	self reset enabled: true.
	creationBlock ifNotNil: [ creationBlock value: bloom ]
]

{ #category : #initialization }
BloomFilterPlaygroundToolbar >> initializePresenter [
	create action: [ self openCreationForm ].
	reset action: [ self resetBloomFilter ]
]

{ #category : #initialization }
BloomFilterPlaygroundToolbar >> initializeWidgets [
	create := self newButton.
	reset := self newButton.
	create
		label: 'New Bloom Filter';
		icon: (self iconNamed: #add).
	reset
		label: 'Reset';
		icon: (self iconNamed: #refresh);
		enabled: false.
	self focusOrder
		add: create;
		add: reset
]

{ #category : #private }
BloomFilterPlaygroundToolbar >> openCreationForm [
| form dialog |
			form := BloomFilterCreationForm new.
			dialog := form openDialogWithSpec.
			form
				whenParametersValidationResultChangedDo: [ :areValid | dialog okButtonEnabled: areValid ].
			dialog title: 'BloomFilter Parameters'.
			dialog extent: 500 @ (5 * self class toolbarHeight).
			dialog okButtonEnabled: false.
			dialog
				okAction: [ self
						createBloomFilterWith: form targetElements text asInteger
						andFpp: form targetFpp text asNumber ] 
]

{ #category : #accessing }
BloomFilterPlaygroundToolbar >> reset [
	^ reset
]

{ #category : #initialization }
BloomFilterPlaygroundToolbar >> resetBloomFilter [
	self createBloomFilterWith: bloom targetElements  andFpp: bloom targetFpp 
]

{ #category : #'api - events' }
BloomFilterPlaygroundToolbar >> whenBloomCreatedDo: aBlock [
	creationBlock := aBlock
]
