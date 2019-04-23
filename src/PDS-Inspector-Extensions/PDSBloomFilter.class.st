Class {
	#name : #PDSBloomFilter,
	#superclass : #Object,
	#instVars : [
		'hashes',
		'bitStorage',
		'targetFpp',
		'targetElements',
		'size'
	],
	#category : #'PDS-Inspector-Extensions-Membership'
}

{ #category : #'instance creation' }
PDSBloomFilter class >> new: expectedElements fpp: estimatedFalsePositiveProbability [
	^ self new
		targetElements: expectedElements;
		targetFpp: estimatedFalsePositiveProbability;
		bitStorage:
			(PDSBitArray
				new:
					((self
						optimumSizeFor: expectedElements
						andFpp: estimatedFalsePositiveProbability) roundUpTo: 1));
		hashes:
			((self
				optimumHashesFor: expectedElements
				andFpp: estimatedFalsePositiveProbability) roundUpTo: 1);
		yourself
]

{ #category : #'as yet unclassified' }
PDSBloomFilter class >> optimumHashesFor: expectedElements andFpp: estimatedFalsePositiveProbability [
	| m |
	m := self optimumSizeFor: expectedElements  andFpp: estimatedFalsePositiveProbability.
	^ (m * 2 ln) / expectedElements 
]

{ #category : #'as yet unclassified' }
PDSBloomFilter class >> optimumSizeFor: expectedElements andFpp: estimatedFalsePositiveProbability [ 
^ -1 * (expectedElements * estimatedFalsePositiveProbability ln)
		/ (2 ln raisedTo: 2)
]

{ #category : #api }
PDSBloomFilter >> add: anObject [
	| indexes anyBitChanged |
	indexes := self bitIndexes: anObject.
	anyBitChanged := false.
	indexes
		do:
			[ :anIndex | anyBitChanged := anyBitChanged or: (bitStorage setBitAt: anIndex) ].
	anyBitChanged ifTrue: [ size := size + 1 ]
]

{ #category : #private }
PDSBloomFilter >> bitIndexes: anObject [
	| hashValues indexes |
	hashValues := self hashValuesFor: anObject.
	indexes := hashValues collect: [ :hash | (hash \\ self storageSize) + 1 ].
	^ indexes
]

{ #category : #'accessing - private' }
PDSBloomFilter >> bitStorage: anObject [
	bitStorage := anObject
]

{ #category : #api }
PDSBloomFilter >> contains: anObject [
	| indexes |
	indexes := self bitIndexes: anObject .
	^ indexes allSatisfy: [ :anIndex | (bitStorage bitAt: anIndex) = 1 ]

]

{ #category : #'as yet unclassified' }
PDSBloomFilter >> drawBitSetOn: aMondrian [
	bitStorage drawBitSetOn: aMondrian
]

{ #category : #accessing }
PDSBloomFilter >> fpp [
	^ 1 - (self hashes * self size / self storageSize) negated exp
		raisedTo: self hashes
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
PDSBloomFilter >> gtInspectorFPPCurveIn: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite roassal2 
		title: 'FPP Curve';
		initializeView: [ self fppCurve ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
PDSBloomFilter >> gtInspectorStorageBitSetIn: composite [
	<gtInspectorPresentationOrder: 4>
	^ (bitStorage gtInspectorBitSetIn: composite)
		title: 'Storage BitSet'
]

{ #category : #'as yet unclassified' }
PDSBloomFilter >> gtInspectorStorageParametersIn: composite [
	<gtInspectorPresentationOrder: 3>
	^ (bitStorage
		gtInspectorParametersIn: composite)
		title: 'Storage Parameters'
]

{ #category : #'member lookup' }
PDSBloomFilter >> hashValuesFor: anObject [
	| hashValues murmurHashOriginal h1 h2 |
	
	murmurHashOriginal := (NCHMurmur3 withSeed: 0) hash: anObject.
	h1 := murmurHashOriginal & 16rFFFF.
	h2 := murmurHashOriginal >> 16.
	hashValues := (1 to: self hashes) collect: [ :element | h1 + (element * h2) ].
	^ hashValues
]

{ #category : #accessing }
PDSBloomFilter >> hashes [
	^ hashes
]

{ #category : #'accessing - private' }
PDSBloomFilter >> hashes: anObject [
	hashes := anObject
]

{ #category : #initialization }
PDSBloomFilter >> initialize [
	size := 0.
]

{ #category : #api }
PDSBloomFilter >> reset [
	^ self class new: targetElements fpp: targetFpp
]

{ #category : #accessing }
PDSBloomFilter >> size [
	^ size
]

{ #category : #accessing }
PDSBloomFilter >> storageSize [
	^ bitStorage size
]

{ #category : #accessing }
PDSBloomFilter >> targetElements [
	^ targetElements
]

{ #category : #'accessing - private' }
PDSBloomFilter >> targetElements: anObject [
	targetElements := anObject
]

{ #category : #accessing }
PDSBloomFilter >> targetFpp [
	^ targetFpp
]

{ #category : #'accessing - private' }
PDSBloomFilter >> targetFpp: anObject [
	targetFpp := anObject
]
