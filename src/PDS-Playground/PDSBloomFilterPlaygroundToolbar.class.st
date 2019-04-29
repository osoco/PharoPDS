Class {
	#name : #PDSBloomFilterPlaygroundToolbar,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bloom',
		'create',
		'reset',
		'creationBlock',
		'analysis',
		'profile',
		'benchmarking'
	],
	#category : #'PDS-Playground-Membership'
}

{ #category : #specs }
PDSBloomFilterPlaygroundToolbar class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #create;
				add: #analysis;
				add: #profile;
				add: #benchmarking;
				add: #reset ]
			height: self toolbarHeight;
		yourself
]

{ #category : #accessing }
PDSBloomFilterPlaygroundToolbar >> analysis [
	^ analysis
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> analyzeFilter [
	PDSBloomFilterAnalysis openFor: bloom.
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> benchmarkFilter [
	| addOperationsPerSec testOperationsPerSec |
	addOperationsPerSec := [ bloom add: bloom targetElements atRandom asByteArray ] bench.
	testOperationsPerSec := [ bloom contains: bloom targetElements atRandom asByteArray ]
		bench.
	UIManager default
		inform:
			('Add operations: {1}' , Character cr asString
				, 'Test operations: {2}'
				format:
					{addOperationsPerSec.
					testOperationsPerSec}).
	self onBloomFilterUpdated
]

{ #category : #accessing }
PDSBloomFilterPlaygroundToolbar >> benchmarking [
	^ benchmarking
]

{ #category : #accessing }
PDSBloomFilterPlaygroundToolbar >> create [
	^ create
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> createBloomFilterWith: size andFpp: fpp [
	self onBloomFilterCreated: (PDSBloomFilter new: size fpp: fpp).
	
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> initializePresenter [
	create action: [ self openCreationForm ].
	reset action: [ self resetBloomFilter ].
	profile action: [ self profileFilter ].
	analysis action: [ self analyzeFilter ].
	benchmarking action: [ self benchmarkFilter ]
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> initializeWidgets [
	create := self newButton.
	analysis := self newButton.
	profile := self newButton.
	benchmarking := self newButton.
	reset := self newButton.
	create
		label: 'New Bloom Filter';
		icon: (self iconNamed: #add).
	analysis
		label: 'Analysis';
		icon: (self iconNamed: #smallProfileIcon);
		enabled: false.
	profile
		label: 'Profiling';
		icon: (self iconNamed: #glamorousSpawn);
		enabled: false.
	benchmarking
		label: 'Benchmarking';
		icon: (self iconNamed: #history);
		enabled: false.
	reset
		label: 'Reset';
		icon: (self iconNamed: #refresh);
		enabled: false.
	self focusOrder
		add: create;
		add: analysis;
		add: profile;
		add: benchmarking;
		add: reset
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> onBloomFilterCreated: aBloomFilter [
	bloom := aBloomFilter.
	self reset enabled: true.
	self analysis enabled: true.
	self profile enabled: true.
	self benchmarking enabled: true.
	creationBlock ifNotNil: [ creationBlock value: bloom ]
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> onBloomFilterUpdated [
	creationBlock ifNotNil: [ creationBlock value: bloom ]
]

{ #category : #private }
PDSBloomFilterPlaygroundToolbar >> openCreationForm [
| form dialog |
			form := PDSBloomFilterCreationForm new.
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
PDSBloomFilterPlaygroundToolbar >> profile [
	^ profile
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> profileFilter [
	TimeProfiler new
		openOnBlock: [ 1000
				timesRepeat:
					[ 1 to: bloom targetElements do: [ :count | bloom add: ('element ' , count asString) asByteArray ] ] ].
	self onBloomFilterUpdated
]

{ #category : #accessing }
PDSBloomFilterPlaygroundToolbar >> reset [
	^ reset
]

{ #category : #initialization }
PDSBloomFilterPlaygroundToolbar >> resetBloomFilter [
	self onBloomFilterCreated: (bloom reset)
]

{ #category : #'api - events' }
PDSBloomFilterPlaygroundToolbar >> whenBloomCreatedDo: aBlock [
	creationBlock := aBlock
]
