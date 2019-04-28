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
	| countersElement totalElements v hashValueElements edge |
	^ composite roassal2
		title: 'Pipeline';
		initializeView: [ v := RTView new.
			countersElement := self makeCountersElementsInView: v.
			hashValueElements := self makeHashValueElementsInView: v.
			totalElements := RTGroup new.
			totalElements
				add: countersElement;
				add: hashValueElements.
			edge := RTLine edgeFrom: hashValueElements to: countersElement.
			v add: edge.
			totalElements
				@
					(RTShowEdge new
						connectToAll: [ :element | Array with: tempCounterPosition ];
						shape: (RTLine new color: (Color blue alpha: 0.4))).
			RTTreeLayout on: totalElements.
			v ]
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> hashBitAt: aBitPosition [
	^ tempHash >> (aBitPosition  - 1) & 16r01 .
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeBucketElementsAt: aCountersPosition inView: aView [
	| value colorValue bucketElement |
	value := counters at: aCountersPosition.
	colorValue := value = 0
		ifTrue: [ Color green trans ]
		ifFalse: [ Color blue trans ].
	bucketElement := (RTBox new
		size: 30;
		color: colorValue)
		+
			(RTLabel
				color: Color black;
				text: value) elementOn: 'Bucket ' , aCountersPosition asString.
"COMENTAR PARA QUE FUNCIONE SI HACEMOS CON FOR:NEST:"
	aView add: bucketElement .
	^ bucketElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeCountersElementsInView: aView [
	" FUNCIONA LA VISUALIZACION COMO GRUPO PERO LUEGO NO EDGE
	| countersElement |
	countersElement := (RTBox + RTLabel new borderColor: Color red trans)
		elementsOn: #('Counters').
	aView addAll: countersElement.
	RTNest new
		for: countersElement
		add: [ :group :model | 
			multiSets to: 1 by: -1 do:
				[ :i | group add: (self makeBucketElementsAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ].
	RTHorizontalLineLayout new on: countersElement.
	countersElement @ RTPopup.
	^ countersElement "

	| countersElement bucketsElements |
	countersElement := (RTBox + RTLabel borderColor: Color red trans)
		elementOn: 'Counters'.
	aView add: countersElement.
	bucketsElements := RTGroup new.
	multiSets to: 1 by: -1 do:
		[ :each | bucketsElements add: (self makeBucketElementsAt: each inView: aView) ].
		RTHorizontalLineLayout on: bucketsElements .
	RTNest new on: countersElement nest: bucketsElements.

	countersElement @ RTPopup.
	^ countersElement

	"	RTNest new
		for: countersElement
		add: [ :group :model | 
			indexBits to: 1 by: -1 do:
				[ :i | group add: (self makeBucketsElementAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ].
	 End of statement list encountered ->RTHorizontalLineLayout new on: indexBitsElement.
	indexBitsElement @ RTPopup.
	^ indexBitsElement"
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
	indexBitsElement := (RTBox + (RTLabel new text: 'Index Bits')
		borderColor: Color red trans) elementsOn: (Array with: tempCounterPosition).
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
