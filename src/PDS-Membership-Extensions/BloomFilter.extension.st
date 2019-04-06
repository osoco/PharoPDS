Extension { #name : #BloomFilter }

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtInspectorFPPCurveIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite roassal2 
		title: 'FPP Curve';
		initializeView: [ self fppCurve ]
]

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtInspectorParametersIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ composite fastTable
		title: 'Parameters';
		display: [ {('Target Elements (n)' -> self targetElements).
			('Target FPP' -> self targetFpp).
			('Number of hashes (k)' -> self hashes).
			('Current Elements' -> self size).
			('Current FPP' -> self fpp)} ];
		column: 'Name'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]
]

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtInspectorStorageBitSetIn: composite [
	<gtInspectorPresentationOrder: 4>
	^ (bitStorage gtInspectorBitSetIn: composite)
		title: 'Storage BitSet'
]

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtInspectorStorageParametersIn: composite [
	<gtInspectorPresentationOrder: 3>
	^ (bitStorage
		gtInspectorParametersIn: composite)
		title: 'Storage Parameters'
]

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtParametersViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parameters';
		priority: 10;
		items: [ {('Target Elements (n)' -> self targetElements).
			('Target FPP' -> self targetFpp).
			('Number of hashes (k)' -> self hashes).
			('Current Elements' -> self size).
			('Current FPP' -> self fpp)} ];
		column: 'Parameter'
			do: [ :column | 
			column
				item: [ :assoc | assoc key ];
				matchParent ];
		column: 'Value'
			do: [ :column | 
			column
				item: [ :assoc | assoc value ];
				matchParent ]
]

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtStorageBitSetViewFor: aView [
	<gtView>
	^ (bitStorage gtBitSetViewFor: aView) priority: 30; title: 'Storage BitSet'
]

{ #category : #'*PDS-Membership-Extensions' }
BloomFilter >> gtStorageParametersViewFor: aView [
	<gtView>
	^ (bitStorage gtParametersViewFor: aView) priority: 20; title: 'Storage Parameters'
]
