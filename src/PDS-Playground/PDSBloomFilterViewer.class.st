Class {
	#name : #PDSBloomFilterViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'bits',
		'fpp',
		'bloom'
	],
	#category : #'PDS-Playground-Membership'
}

{ #category : #specs }
PDSBloomFilterViewer class >> defaultSpec [
	^ SpecRowLayout composed
		add: #bits;
		addSplitter;
		add: #fpp;
		yourself
]

{ #category : #accessing }
PDSBloomFilterViewer >> bits [
	^ bits
]

{ #category : #api }
PDSBloomFilterViewer >> bloom: aBloomFilter [
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
PDSBloomFilterViewer >> extent [
	^ 800 @ 600
]

{ #category : #accessing }
PDSBloomFilterViewer >> fpp [
	^ fpp
]

{ #category : #initialization }
PDSBloomFilterViewer >> initializeWidgets [
	bits := self instantiate: PDSRoassalViewer.
	fpp := self instantiate: PDSRoassalViewer.
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
PDSBloomFilterViewer >> refresh [ 	
	bits refresh.
	fpp refresh.
]

{ #category : #api }
PDSBloomFilterViewer >> title [ 
^ 'Bloom Filter Viewer'
]
