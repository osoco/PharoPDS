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
			view @ RTDraggableView.
			view canvas addMenu: 'In' callback: [ RTZoomInMove on: view ].
			view canvas addMenu: 'Out' callback: [ RTZoomOutMove on: view ].
			view canvas
				addMenu: 'Center'
				callback: [ view canvas focusOnCenterScaled.
					view signalUpdate ].
			b := RTMondrian new.
			b view: view.
			bloom drawBitSetOn: b.
			canvas extent: (self extent x / 2) @ self extent y.
			canvas focusOnCenterScaled.
		 ];
		refresh.
	fpp
		roassalScript: [ :view :canvas | 
			| g |
			view @ RTDraggableView.
			view canvas addMenu: 'In' callback: [ RTZoomInMove on: view ].
			view canvas addMenu: 'Out' callback: [ RTZoomOutMove on: view ].
			view canvas
				addMenu: 'Center'
				callback: [ view canvas focusOnCenterScaled.
					view signalUpdate ].
			g := bloom fppCurve.
			g view: view.
			g build.
			canvas extent: (self extent x / 2) @ self extent y.
			 canvas focusOnCenterScaled.
			 ];
		refresh
]

{ #category : #api }
BloomFilterViewer >> extent [
	^ 800 @ 600
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
