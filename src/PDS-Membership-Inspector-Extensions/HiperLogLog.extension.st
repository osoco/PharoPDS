Extension { #name : #HiperLogLog }

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> gtInspectorParametersIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite fastTable
		title: 'Parameters';
		display: [ {('Target Standar Error (%)' -> targetStandarError).
			('Estimated Elements (n)' -> estimatedElements).
			('Number of MultiSets (2^p)' -> multiSets).
			('Index Bits (p)' -> indexBits).
			('Rest Bits (32-p)' -> restBits)} ];
		column: 'Name'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> gtInspectorPipelineIn: composite [
	<gtInspectorPresentationOrder: 1>
	| c e v h |
	^ composite roassal2
		title: 'Pipeline';
		initializeView: [ v := RTView new.
			c := self makeCountersElementsInView: v.
			h := self makeHashValueElementsInView: v.
			e := c.
			e add: h.
			RTEdgeBuilder new
				view: v;
				elements: e;
				connectFrom: [ 'Last Hash Value' ].
			e
				@
					(RTShowEdge new
						connectToAll: [ :element | Array with: 'Index Bits' ];
						shape: (RTLine new color: (Color blue alpha: 0.4))).
			RTTreeLayout on: e.
			v ]
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> hashBitAt: aBitPosition [
	^ tempHash >> (aBitPosition  - 1) & 16r01 .
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeCountersElementsInView: aView [
	| c |
	c := RTGroup new.
	1 to: counters size do: [ :i | 
		| value colorValue |
		value := counters at: i.
		colorValue := value = 0
			ifTrue: [ Color green trans ]
			ifFalse: [ Color blue trans ].
		c
			add:
				(((RTEllipse new
					size: 30;
					color: colorValue)
					+
						(RTLabel
							color: Color black;
							text: value) elementOn: 'Bucket ' , i asString) view: aView) ].
						c@RTPopup .
	aView addAll: c.
	^ c
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashBitElementAt: aBitPosition inView: aView [
	| value colorValue bitElement |
	value := self hashBitAt: aBitPosition.
	colorValue := value = 0
		ifTrue: [ Color green trans ]
		ifFalse: [ Color blue trans ].
	bitElement := (RTBox new
		size: 30;
		color: colorValue)
		+
			(RTLabel
				color: Color black;
				text: value) elementOn: 'Bit ' , aBitPosition asString.
"	aView add: bitElement".
	^ bitElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashIndexBitsElementsInView: aView [
	| indexBitsElement |
	indexBitsElement := (RTBox + RTLabel new borderColor: Color red trans)
		elementsOn: #('Index Bits').
	aView addAll: indexBitsElement.
	RTNest new
		for: indexBitsElement
		add: [ :group :model | 
			indexBits to: 1 by: -1 do:
				[ :i | group add: (self makeHashBitElementAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ].
	RTHorizontalLineLayout new on: indexBitsElement.
	indexBitsElement @ RTPopup.
	^ indexBitsElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashRestBitsElementsInView: aView [
	| restBitsElement |
	restBitsElement := (RTBox  + RTLabel new
		borderColor: Color red trans)
		elementsOn: #('Rest Bits').
	aView addAll: restBitsElement.
	RTNest new
		for: restBitsElement
		add: [ :group :model | 
			hashBits to: indexBits + 1 by: -1 do:
				[ :i | group add: (self makeHashBitElementAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ].
	RTHorizontalLineLayout new on: restBitsElement.
	restBitsElement @ RTPopup.
	^ restBitsElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashValueElementsInView: aView [
	| hashValueElement restAndIndexElements |
	hashValueElement := (RTBox+RTLabel)  elementOn: 'Last Hash Value'.
	aView add: hashValueElement.
	restAndIndexElements := RTGroup new.
	restAndIndexElements
		add: (self makeHashRestBitsElementsInView: aView) @ RTPopup;
		add: (self makeHashIndexBitsElementsInView: aView) @ RTPopup.
	RTHorizontalLineLayout new on: restAndIndexElements.
	RTNest new on: hashValueElement nest: restAndIndexElements.
	"		hashValueElement := RTBox elementsOn: #('Last Hash Value').
	aView addAll: hashValueElement.
		RTNest new
		for: hashValueElement
		add: [ :group :model | 
			group add: (self makeHashIndexBitsElementsInView: aView) @ RTPopup.
			group add: (self makeHashRestBitsElementsInView: aView) @ RTPopup.
			RTHorizontalLineLayout on: group ]."

	"	indexBitsElement := RTBox elementsOn: #('Index Bits').
	aView addAll: indexBitsElement.
	RTNest new
		for: indexBitsElement
		add: [ :group :model | 
			indexBits to: 1 by: -1 do:
				[ :i | group add: (self makeHashBitElementAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ]."
	"	RTHorizontalLineLayout new on: hashValueElement."
	hashValueElement @ RTPopup.
	^ hashValueElement
]
