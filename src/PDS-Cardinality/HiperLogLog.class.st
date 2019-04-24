Class {
	#name : #HiperLogLog,
	#superclass : #Object,
	#instVars : [
		'targetStandarError',
		'counters',
		'hash',
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

{ #category : #'as yet unclassified' }
HiperLogLog class >> defaultHash [
^Murmur3 withSeed: 0
	
]

{ #category : #'instance creation' }
HiperLogLog class >> newWithStandarError: aStandarError [
	"Create a empty HLL with Standar Error between 26% and 0,41%"

	^ self
		newWithStandarError: aStandarError
		andHash: self defaultHash
]

{ #category : #'instance creation' }
HiperLogLog class >> newWithStandarError: aStandarError andHash: aHash [

	"Create a empty HLL with Standar Error between 26% and 0,41%"

	| newHLL |
	newHLL := self new.
	newHLL setStandarError: aStandarError withHash:  aHash.
	^ newHLL
]

{ #category : #api }
HiperLogLog >> add: anObject [
	| tempHash tempCounterPosition tempRank |
	tempHash := hash hash: anObject.
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

{ #category : #accessing }
HiperLogLog >> estimatedElements [
	| tempElements |
	tempElements := self biasCorrection * multiSets * self harmonicMean.
	estimatedElements := tempElements.
	tempElements <= (5 * multiSets / 2)
		ifTrue: [ | temp |
			temp := counters
				inject: 0
				into: [ :sum :each | 
					each = 0
						ifTrue: [ sum + 1 ]
						ifFalse: [ sum ] ].
			temp = 0
				ifFalse: [ estimatedElements := multiSets * (multiSets / temp) ln ] ]
		ifFalse: [ tempElements > (2 ** 32 / 30)
				ifTrue: [ estimatedElements := -1
						* (2 ** 32 * (1 - (tempElements / (2 * 32)) log)) ] ].
	^ estimatedElements := estimatedElements roundUpTo: 1
]

{ #category : #'private - computing' }
HiperLogLog >> harmonicMean [
	| total |
	total := counters
		inject: 0
		into: [ :sum :each | sum + (2 ** (-1 * each)) ].
	^ multiSets / total
]

{ #category : #adding }
HiperLogLog >> rank: anInteger [
	1 to: restBits do: [ :i | 
		(anInteger bitAt: i) = 1
			ifTrue: [ ^ i ] ].
	^ restBits+1
]

{ #category : #initialization }
HiperLogLog >> setStandarError: aStandarError withHash: aHash [
	"Initialize the whole HLL variables from a Standar Error"

	targetStandarError := aStandarError.
	hash := aHash.
	indexBits := self class calculateIndexBits: aStandarError.
	restBits := 32 - indexBits.
	multiSets := 2 ** indexBits.
	counters := Array new: multiSets withAll: 0.
	estimatedElements := 0
]
