Class {
	#name : #HiperLogLog,
	#superclass : #Object,
	#instVars : [
		'targetStandarError',
		'counters',
		'mmh',
		'multiSets',
		'indexBits',
		'restBits'
	],
	#category : #'PDS-Cardinality'
}

{ #category : #'private - configuration' }
HiperLogLog class >> calculateIndexBits: anError [
	^ (1.04 / (anError  / 100) ** 2 log: 2) roundUpTo: 1
]

{ #category : #'private - configuration' }
HiperLogLog class >> calculateMultiSets: anError [
	^ (1.04 / (anError / 100)) ** 2
]

{ #category : #'instance creation' }
HiperLogLog class >> newWithStandarError: aStandarError [
	"Create a empty HLL with Standar Error between 26% and 0,41%"

	| newHLL |
	newHLL := HiperLogLog new.
	newHLL
		targetStandarError: aStandarError;
		mmh: (Murmur3 withSeed: 0);
		indexBits: (self calculateIndexBits: aStandarError);
		restBits: 32 - newHLL indexBits;
		multiSets: 2 ** newHLL indexBits;
		counters: (Array new: newHLL multiSets withAll: 0).
	"		multiSets: (self calculateMultiSets: aStandarError);"
	^ newHLL
]

{ #category : #adding }
HiperLogLog >> add: anObject [
	| tempHash tempCounterPosition tempRank |
	tempHash := mmh hash: anObject.
	tempCounterPosition := (tempHash & (2 ** indexBits - 1)) + 1.
	tempRank := self rank: tempHash >> indexBits.
	tempRank > (counters at: tempCounterPosition)
		ifTrue: [ counters at: tempCounterPosition put: tempRank ]
]

{ #category : #'accessing - private' }
HiperLogLog >> counters: anArray [
counters:= anArray .
]

{ #category : #accessing }
HiperLogLog >> indexBits [
	^ indexBits
]

{ #category : #accessing }
HiperLogLog >> indexBits: anObject [
	indexBits := anObject
]

{ #category : #'accessing - private' }
HiperLogLog >> mmh: aMurmurhash [
mmh := aMurmurhash .
]

{ #category : #accessing }
HiperLogLog >> multiSets [
	^ multiSets
]

{ #category : #accessing }
HiperLogLog >> multiSets: anObject [
	multiSets := anObject
]

{ #category : #adding }
HiperLogLog >> rank: anInteger [


	1 to: restBits do: [ :i | 
		(anInteger bitAt: i) = 1
			ifTrue: [ ^ i - 1 ] ]
]

{ #category : #accessing }
HiperLogLog >> restBits [
	^ restBits
]

{ #category : #accessing }
HiperLogLog >> restBits: anObject [
	restBits := anObject
]

{ #category : #accessing }
HiperLogLog >> targetStandarError: anObject [
	targetStandarError := anObject
]
