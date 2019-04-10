Class {
	#name : #BloomFilterViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bits',
		'fpp',
		'bloom'
	],
	#category : #'PDS-Membership-Playground'
}

{ #category : #specs }
BloomFilterViewer class >> defaultSpec [
	^ SpecRowLayout composed
		add: #bits;
		addSplitter;
		add: #fpp;
		yourself
]

{ #category : #accessing }
BloomFilterViewer >> bits [
	^ bits
]

{ #category : #api }
BloomFilterViewer >> bloom: aBloomFilter [
	bloom := aBloomFilter.
	bits
		roassalScript: [ :view :canvas | 
			| b |
			b := RTMondrian new.
			b view: view.
			bloom drawBitSetOn: b.
			canvas camera focusOnCenterScaled: 300 ];
		refresh.
	fpp
		roassalScript: [ :view :canvas | 
			| g |
			g := bloom fppCurve.
			g view: view.
			g build.
			canvas camera focusOnCenterScaled: 300 ];
		refresh
]

{ #category : #api }
BloomFilterViewer >> extent [ 
^ 800@600
]

{ #category : #accessing }
BloomFilterViewer >> fpp [
	^ fpp
]

{ #category : #initialization }
BloomFilterViewer >> initializeWidgets [
	bits := self instantiate: RoassalViewer.
	fpp := self instantiate: RoassalViewer.
	bits
		labelText: 'Bloom Filter BitSet'. fpp
		labelText: 'False-Positive Probability Curve'.
	bits roassalScript: [ :view :canvas |  ].
	fpp roassalScript: [ :view :canvas |  ].
	self focusOrder
		add: bits;
		add: fpp
]

{ #category : #api }
BloomFilterViewer >> refresh [ 	
	bits refresh.
	fpp refresh.
]

{ #category : #api }
BloomFilterViewer >> title [ 
^ 'Bloom Filter Viewer'
]
