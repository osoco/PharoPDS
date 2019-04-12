Extension { #name : #BloomFilter }

{ #category : #'*PDS-Membership-GToolkit-Extensions' }
BloomFilter >> gtFPPCurveFor: aView [
    <gtView>
    ^ aView explicit
        title: 'FPP Curve';
        priority: 20;
        stencil: [ BlElement new
                layout: BlLinearLayout vertical;
                constraintsDo: [ :c | 
                    c horizontal matchParent.
                    c vertical matchParent ];
                padding: (BlInsets all: 5);
                addChild:
                    (BrButton new
                        look: BrGlamorousButtonWithLabelLook;
                        label: 'Inspect in Morphic';
                        action: [ GTInspector inspect: self fppCurve ];
                        yourself);
                addChild: self fppCurve build view setUpCanvas buildMorph imageForm asElement;
                yourself ]

]

{ #category : #'*PDS-Membership-GToolkit-Extensions' }
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

{ #category : #'*PDS-Membership-GToolkit-Extensions' }
BloomFilter >> gtStorageBitSetViewFor: aView [
	<gtView>
	^ (bitStorage gtBitSetViewFor: aView) priority: 40; title: 'Storage BitSet'
]

{ #category : #'*PDS-Membership-GToolkit-Extensions' }
BloomFilter >> gtStorageParametersViewFor: aView [
	<gtView>
	^ (bitStorage gtParametersViewFor: aView) priority: 30; title: 'Storage Parameters'
]
