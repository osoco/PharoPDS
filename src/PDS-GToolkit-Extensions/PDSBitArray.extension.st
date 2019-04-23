Extension { #name : #PDSBitArray }

{ #category : #'*PDS-GToolkit-Extensions' }
PDSBitArray >> gtBitSetViewFor: aView [
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

{ #category : #'*PDS-GToolkit-Extensions' }
PDSBitArray >> gtParametersViewFor: aView [
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
