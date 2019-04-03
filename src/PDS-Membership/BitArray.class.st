Class {
	#name : #BitArray,
	#superclass : #Object,
	#instVars : [
		'storage',
		'size',
		'occupancy'
	],
	#category : #'PDS-Membership'
}

{ #category : #'instance creation' }
BitArray class >> new: aNumberOfBits [
	^ self new
		storage: (ByteArray new: (aNumberOfBits / 8 roundUpTo: 1));
		size: aNumberOfBits;
		yourself
]

{ #category : #'member lookup' }
BitArray >> bitAt: index [
	| byteIndex byteValue mask |
	byteIndex := (index / 8 )ceiling.
	byteValue := storage byteAt: byteIndex.
	mask := 2 raisedTo: byteIndex * 8 - index.
	(byteValue & mask) = 0
		ifTrue: [ ^ 0 ]
		ifFalse: [ ^ 1 ]
]

{ #category : #'accessing - private' }
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

{ #category : #'accessing - private' }
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

{ #category : #'accessing - private' }
BitArray >> incOccupancy [
	occupancy := occupancy + 1
]

{ #category : #'accessing - private' }
BitArray >> initialize [
	occupancy := 0
]

{ #category : #accessing }
BitArray >> occupancy [
	^ occupancy
]

{ #category : #accessing }
BitArray >> occupancyInPercent [
	^ (self occupancy * 100 / self size) asFloat round: 2
]

{ #category : #'accessing - private' }
BitArray >> setBitAt: index [
	| byteIndex byteValue bitChanged |
	byteIndex := (index / 8) ceiling.
	byteValue := storage byteAt: byteIndex.
	bitChanged := (byteValue bitXor: (2 raisedTo: byteIndex * 8 - index))
		> 0.
	bitChanged
		ifTrue: [ storage
				byteAt: byteIndex
				put: byteValue | (2 raisedTo: byteIndex * 8 - index).
			self incOccupancy  ].
	^ bitChanged
]

{ #category : #'accessing - private' }
BitArray >> size [
	^ size
]

{ #category : #'accessing - private' }
BitArray >> size: aNumberOfBits [
size := aNumberOfBits 
]

{ #category : #accessing }
BitArray >> storage [
	^ storage
]

{ #category : #'accessing - private' }
BitArray >> storage: anObject [
	storage := anObject
]
