Class {
	#name : #HiperLogLog,
	#superclass : #Object,
	#instVars : [
		'targetStandarError',
		'counters',
		'mmh',
		'multiSets',
		'indexBits',
		'restBits',
		'estimatedElements'
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
		counters: (Array new: newHLL multiSets withAll: 0);
	   estimatedElements: 0.
	"		multiSets: (self calculateMultiSets: aStandarError);"
	^ newHLL
]

{ #category : #api }
HiperLogLog >> add: anObject [
	| tempHash tempCounterPosition tempRank |
	tempHash := mmh hash: anObject.
	tempCounterPosition := (tempHash & (2 ** indexBits - 1)) + 1.
	tempRank := self rank: tempHash >> indexBits.
	tempRank > (counters at: tempCounterPosition)
		ifTrue: [ counters at: tempCounterPosition put: tempRank ]
]

{ #category : #'private - computing' }
HiperLogLog >> biasCorrection [
	indexBits >= 7
		ifTrue: [ ^ 0.7213 * (2 ** indexBits) / (2 ** indexBits + 1.079) ].
	indexBits = 6
		ifTrue: [ ^ 0.709 ].
	indexBits = 5
		ifTrue: [ ^ 0.697 ].
	indexBits = 4
		ifTrue: [ ^ 0.673 ]
]

{ #category : #'accessing - private' }
HiperLogLog >> counters: anArray [
counters:= anArray .
]

{ #category : #accessing }
HiperLogLog >> estimatedElements [
	| tempElements |
	tempElements := self biasCorrection * multiSets * self harmonicMean.
	tempElements <= (5 * multiSets / 2)
		ifTrue: [ | temp |
			
			temp := counters
				inject: 0
				into: [ :sum :each | 
					each = 0
						ifTrue: [ sum + 1 ] ].
			temp = 0
				ifFalse: [ estimatedElements := multiSets * (multiSets / temp) log ] ]
		ifFalse: [ tempElements > (2 ** 32 / 30)
				ifTrue: [ estimatedElements := -1
						* (2 ** 32 * (1 - (tempElements / (2 * 32)) log)) ] ].
	^ estimatedElements
]

{ #category : #accessing }
HiperLogLog >> estimatedElements: anObject [
	estimatedElements := anObject
]

{ #category : #'private - computing' }
HiperLogLog >> harmonicMean [
	| total |
	total := 0.
	 counters
		inject: total
		into: [ :sum :each | sum + (2 ** (-1 * each)) ].
	^ multiSets * total
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
