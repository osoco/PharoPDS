Extension { #name : #BitArray }

{ #category : #'*PDS-Membership-Extensions' }
BitArray >> gtBitSetViewFor: aView [
	<gtView>
	^ aView explicit
		title: 'BitSet';
		priority: 20;
		stencil: [ | view nodes |
			view := GtMondrian new.
			nodes := (1 to: self size)
				collect: [ :bitIndex | (self bitAt: bitIndex) = 1 ].
			view nodes
				shape: [ :anInteger | 
					| color |
					color := (nodes at: anInteger)
						ifTrue: [ Color blue trans ]
						ifFalse: [ Color green trans ].
					BlElement new
						geometry: BlRectangle new;
						background: (BlBackground paint: color);
						border: (BlBorder paint: Color black width: 1);
						size: 20 asPoint ];
				with: (1 to: self size).
			view layout grid.
			view ]
]

{ #category : #'*PDS-Membership-Extensions' }
BitArray >> gtInspectorBitSetIn: composite [
	<gtInspectorPresentationOrder: 2>
	| nodes |
	^ composite roassal2
		title: 'BitSet';
		initializeView: [ | b |
			nodes := (1 to: self size)
				collect: [ :bitIndex | (self bitAt: bitIndex) = 1 ].
			b := RTMondrian new.
			b shape rectangle
				size: 20;
				if: [ :el | el ] color: Color blue trans;
				if: [ :el | el not ] color: Color green trans.
			b nodes: nodes.
			b layout grid.
			b build ];
		yourself
]

{ #category : #'*PDS-Membership-Extensions' }
BitArray >> gtInspectorParametersIn: composite [
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

{ #category : #'*PDS-Membership-Extensions' }
BitArray >> gtParametersViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Parameters';
		priority: 10;
		items: [ {('Total bits' -> self size).
			('Occupancy' -> self occupancy).
			('Occupancy in percentage (%)' -> self occupancyInPercent)} ];
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
