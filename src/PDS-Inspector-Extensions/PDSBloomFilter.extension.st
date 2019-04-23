Extension { #name : #PDSBloomFilter }

{ #category : #'*PDS-Inspector-Extensions' }
PDSBloomFilter >> fppCurve [
	| fpp ds1 g p ds |
	g := RTGrapher new.
	fpp := [ :s | 
	1 - (self hashes * s / self storageSize) negated exp
		raisedTo: self hashes ].
	ds1 := RTData new.
	ds1 label: 'FPP curve'.
	ds1 noDot.
	ds1 points: (0.0 to: self targetElements * 1.5 by: 1).
	ds1 connectColor: Color blue.
	ds1 x: #yourself.
	ds1 y: fpp.
	g add: ds1.
	p := RTHorizontalLineDecorator new.
	p add: (fpp value: self targetElements).
	p shape line color: (Color blue alpha: 0.3).
	g addDecorator: p.
	p := RTVerticalLineDecorator new.
	p add: self targetElements.
	p shape line color: (Color blue alpha: 0.3).
	g addDecorator: p.
	ds := RTData new.
	ds label: 'Current FPP'.
	ds connectColor: (Color red alpha: 0.3).
	ds dotShape cross color: (Color red alpha: 0.3).
	ds points: {self size}.
	ds x: #yourself.
	ds y: fpp.
	g add: ds.
	g
		addDecorator:
			(PDSBoundCursorFollower new
				color: Color blue;
				bindFunction: fpp).
	g legend right.
	g axisX title: 'Elements Added'.
	g axisY title: 'False Positive Probability (FPP)'.
	^ g
]

{ #category : #'*PDS-Inspector-Extensions' }
PDSBloomFilter >> gtInspectorFPPCurveIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite roassal2 
		title: 'FPP Curve';
		initializeView: [ self fppCurve ]
]

{ #category : #'*PDS-Inspector-Extensions' }
PDSBloomFilter >> gtInspectorParametersIn: composite [
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

{ #category : #'*PDS-Inspector-Extensions' }
PDSBloomFilter >> gtInspectorStorageBitSetIn: composite [
	<gtInspectorPresentationOrder: 4>
	^ (bitStorage gtInspectorBitSetIn: composite)
		title: 'Storage BitSet'
]

{ #category : #'*PDS-Inspector-Extensions' }
PDSBloomFilter >> gtInspectorStorageParametersIn: composite [
	<gtInspectorPresentationOrder: 3>
	^ (bitStorage
		gtInspectorParametersIn: composite)
		title: 'Storage Parameters'
]
