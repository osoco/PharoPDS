Class {
	#name : #PDSBitArray,
	#superclass : #Object,
	#instVars : [
		'storage',
		'size',
		'occupancy'
	],
	#category : #'PDS-Inspector-Extensions-Collections'
}

{ #category : #'instance creation' }
PDSBitArray class >> new: aNumberOfBits [
	^ self new
		storage: (ByteArray new: (aNumberOfBits / 8 roundUpTo: 1));
		size: aNumberOfBits;
		yourself
]

{ #category : #'member lookup' }
PDSBitArray >> bitAt: index [
	| byteIndex byteValue mask |
	byteIndex := (index / 8 )ceiling.
	byteValue := storage byteAt: byteIndex.
	mask := 2 raisedTo: byteIndex * 8 - index.
	(byteValue & mask) = 0
		ifTrue: [ ^ 0 ]
		ifFalse: [ ^ 1 ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'accessing - private' }
PDSBitArray >> incOccupancy [
	occupancy := occupancy + 1
]

{ #category : #'accessing - private' }
PDSBitArray >> initialize [
	occupancy := 0
]

{ #category : #accessing }
PDSBitArray >> occupancy [
	^ occupancy
]

{ #category : #accessing }
PDSBitArray >> occupancyInPercent [
	^ (self occupancy * 100 / self size) asFloat round: 2
]

{ #category : #'accessing - private' }
PDSBitArray >> setBitAt: index [
	| byteIndex byteValue bitChanged |
	byteIndex := (index / 8) ceiling.
	byteValue := storage byteAt: byteIndex.
	bitChanged := (byteValue bitAnd: (2 raisedTo: byteIndex * 8 - index)) == 0.
	bitChanged
		ifTrue: [ storage
				byteAt: byteIndex
				put: byteValue | (2 raisedTo: byteIndex * 8 - index).
			self incOccupancy ].
	^ bitChanged
]

{ #category : #'accessing - private' }
PDSBitArray >> size [
	^ size
]

{ #category : #'accessing - private' }
PDSBitArray >> size: aNumberOfBits [
size := aNumberOfBits 
]

{ #category : #accessing }
PDSBitArray >> storage [
	^ storage
]

{ #category : #'accessing - private' }
PDSBitArray >> storage: anObject [
	storage := anObject
]
