Extension { #name : #HiperLogLog }

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> arrowedAssociation: originElement to: destinationElement inView: v [
			|arrow line|
			arrow := RTArrowedLine new color: Color black.
			arrow attachPoint: RTVerticalAttachPoint new.
			line := arrow 
				edgeFrom: originElement 
				to: destinationElement .
			v add: line.
]

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
	| countersElement totalElements v hashValueElement objectElement hashFunctionElement |
	^ composite roassal2
		title: 'Pipeline';
		initializeView: [ v := RTView new.
			v @ RTDraggableView.
			objectElement := self makeObjectElementInView: v.
			hashFunctionElement := self makeHashFunctionElementInView: v.
			hashValueElement := self makeHashValueElementInView: v.
			countersElement := self makeCountersElementInView: v.
			hashFunctionElement translateBy: 0 @ 120.
			hashValueElement translateBy: 0 @ 240.
			countersElement translateBy: 0 @ 360.
			totalElements := RTGroup new.
			totalElements
				add: countersElement;
				add: hashValueElement;
				add: objectElement;
				add: hashFunctionElement.
			self
				arrowedAssociation: objectElement
				to: hashFunctionElement
				inView: v.
			self
				arrowedAssociation: hashFunctionElement
				to: hashValueElement
				inView: v.
			self
				arrowedAssociation: hashValueElement
				to: countersElement
				inView: v.
			v
				add:
					(RTLine new
						color: (Color blue alpha: 0.4);
						edgeFrom: (v elementFromModel: 'Bucket ' , tempCounterPosition asString)
							to: (v elementFromModel: tempCounterPosition)).
			v
				add:
					(RTLine new
						color: (Color blue alpha: 0.4);
						edgeFrom: (v elementFromModel: 'Bucket ' , tempCounterPosition asString)
							to: (v elementFromModel: tempRank)).
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
	bucketElement
		@
			(RTPopup
				text: [ :element | 
					aCountersPosition = tempCounterPosition
						ifTrue: [ value > tempRank
								ifTrue: [ element asString , ' dont change. Current Value > Temp Rank' ]
								ifFalse: [ element asString , ' change. Current Value <= Temp Rank' ] ]
						ifFalse: [ element asString ] ]).
	aView add: bucketElement.
	^ bucketElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeCountersElementInView: aView [

	| countersElement bucketsElements |
	countersElement := (RTBox + RTLabel borderColor: Color red trans)
		elementOn: 'Counters'.
	aView add: countersElement.
	bucketsElements := RTGroup new.
	multiSets to: 1 by: -1 do:
		[ :each | bucketsElements add: (self makeBucketElementsAt: each inView: aView) ].
	RTHorizontalLineLayout on: bucketsElements.
	RTNest new on: countersElement nest: bucketsElements.
	countersElement @ RTPopup @ RTDraggable.
	^ countersElement

]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeElementWithModel: aModel withWidth: aWidth inView: aView [
	| element |
	element := (RTBox new
		width: aWidth;
		height: 30) + RTLabel elementOn: aModel .
	aView add: element.
	element @ RTPopup @ RTDraggable.
	^ element
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

	^ bitElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashFunctionElementInView: aView [
	| hashFunctionElement |
	hashFunctionElement := self
		makeElementWithModel: 'Hash Function'
		withWidth: 120
		inView: aView.
	^ hashFunctionElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashIndexBitsElementsInView: aView [
	| indexBitsElement  |
	indexBitsElement := (RTBox + (RTLabel new text: 'Index Bits')
		borderColor: Color red trans)
		elementsOn: (Array with: tempCounterPosition).
	aView addAll: indexBitsElement.
	RTNest new
		for: indexBitsElement
		add: [ :group :model | 
			indexBits to: 1 by: -1 do:
				[ :i | group add: (self makeHashBitElementAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ].
	RTHorizontalLineLayout new on: indexBitsElement.

	indexBitsElement @ (RTPopup
				text: [ :element | 'Bucket= Value Index Bits+1=' , element asString ]).
	^ indexBitsElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashRestBitsElementsInView: aView [
	| restBitsElement |
	restBitsElement := (RTBox + (RTLabel new text: 'Rest Bits')
		borderColor: Color red trans) elementsOn: (Array with: tempRank).
	aView addAll: restBitsElement.
	RTNest new
		for: restBitsElement
		add: [ :group :model | 
			hashBits to: indexBits + 1 by: -1 do:
				[ :i | group add: (self makeHashBitElementAt: i inView: aView) @ RTPopup ].
			RTHorizontalLineLayout on: group ].
	RTHorizontalLineLayout new on: restBitsElement.
	restBitsElement
		@ "RTPopup ."
			(RTPopup text: [ :element | 'Rank of Rest Bits=' , element asString ]).
	^ restBitsElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeHashValueElementInView: aView [
	| hashValueElement restAndIndexElements |
	hashValueElement := RTBox + RTLabel elementOn: 'Last Hash Value'.
	aView add: hashValueElement.
	restAndIndexElements := RTGroup new.
	restAndIndexElements
		add: (self makeHashRestBitsElementsInView: aView) @ RTPopup;
		add: (self makeHashIndexBitsElementsInView: aView) @ RTPopup.
	RTHorizontalLineLayout new on: restAndIndexElements.
	RTNest new on: hashValueElement nest: restAndIndexElements.
	
	hashValueElement @ RTPopup @ RTDraggable.
	^ hashValueElement
]

{ #category : #'*PDS-Membership-Inspector-Extensions' }
HiperLogLog >> makeObjectElementInView: aView [
	| objectElement |
	objectElement := self makeElementWithModel: 'Object' withWidth: 60 inView: aView.
	^ objectElement
]
