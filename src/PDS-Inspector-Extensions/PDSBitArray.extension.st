Extension { #name : #PDSBitArray }

{ #category : #'*PDS-Inspector-Extensions' }
PDSBitArray >> drawBitSetOn: aMondrian [
	| nodes |
	nodes := (1 to: self size)
		collect: [ :bitIndex | (self bitAt: bitIndex) = 1 ].
	aMondrian shape rectangle
		size: 20;
		if: [ :el | el ] color: Color blue trans;
		if: [ :el | el not ] color: Color green trans.
	aMondrian nodes: nodes.
	aMondrian layout grid.
	aMondrian build
]

{ #category : #'*PDS-Inspector-Extensions' }
PDSBitArray >> gtInspectorBitSetIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite roassal2
		title: 'BitSet';
		initializeView: [ | b |
			b := RTMondrian new.
			self drawBitSetOn: b.
			b ];
		yourself
]

{ #category : #'*PDS-Inspector-Extensions' }
PDSBitArray >> gtInspectorParametersIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ composite fastTable
		title: 'Parameters';
		display: [ {('Total bits' -> self size).
			('Occupancy' -> self occupancy).
			('Occupancy in percentage (%)' -> self occupancyInPercent)} ];
		column: 'Name'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]
]
