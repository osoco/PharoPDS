Class {
	#name : #BitArray,
	#superclass : #Object,
	#instVars : [
		'storage',
		'size'
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
	byteIndex := index / 8 roundUpTo: 1.
	byteValue := storage byteAt: byteIndex.
	mask := 2 raisedTo: byteIndex * 8 - index.
	(byteValue & mask) = 0
		ifTrue: [ ^ 0 ]
		ifFalse: [ ^ 1 ]
]

{ #category : #'accessing - private' }
BitArray >> setBitAt: index [ 
	| byteIndex byteValue |
	byteIndex := index / 8 roundUpTo: 1.
	byteValue := storage byteAt: byteIndex.
	storage
		byteAt: byteIndex
		put: (byteValue | 2 raisedTo: byteIndex * 8 - index)
]

{ #category : #'accessing - private' }
BitArray >> size [
	^ size
]

{ #category : #'accessing - private' }
BitArray >> size: aNumberOfBits [
size := aNumberOfBits 
]

{ #category : #'accessing - private' }
BitArray >> storage: anObject [
	storage := anObject
]
