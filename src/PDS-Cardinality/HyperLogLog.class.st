Class {
	#name : #HyperLogLog,
	#superclass : #Object,
	#instVars : [
		'targetStandarError',
		'counters',
		'hash',
		'multiSets',
		'indexBits',
		'restBits',
		'estimatedElements',
		'tempHash',
		'tempCounterPosition',
		'tempRank',
		'hashBits',
		'hcf'
	],
	#category : #'PDS-Cardinality'
}

{ #category : #'private - configuration' }
HyperLogLog class >> calculateIndexBits: anError [
	^ (1.04 / (anError  / 100) ** 2 log: 2) roundUpTo: 1
]

{ #category : #'private - configuration' }
HyperLogLog class >> calculateMultiSets: anError [
	^ (1.04 / (anError / 100)) ** 2
]

{ #category : #'as yet unclassified' }
HyperLogLog class >> defaultHash [
^Murmur3 withSeed: 0
	
]

{ #category : #'instance creation' }
HyperLogLog class >> newWithStandarError: aStandarError [
	"Create a empty HLL with Standar Error between 26% and 0,41%"

	^ self
		newWithStandarError: aStandarError
		andHash: self defaultHash
]

{ #category : #'instance creation' }
HyperLogLog class >> newWithStandarError: aStandarError andHash: aHash [

	"Create a empty HLL with Standar Error between 26% and 0,41%"

	| newHLL |
	newHLL := self new.
	newHLL setStandarError: aStandarError withHash:  aHash.
	^ newHLL
]

{ #category : #api }
HyperLogLog >> add: anObject [
	
	tempHash := hash hash: anObject.
	tempCounterPosition := (tempHash & (2 ** indexBits - 1)) + 1.
	tempRank := self rank: tempHash >> indexBits.
	tempRank > (counters at: tempCounterPosition)
		ifTrue: [ counters at: tempCounterPosition put: tempRank ].
	self estimatedElements
]

{ #category : #'private - computing' }
HyperLogLog >> biasCorrection [
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
HyperLogLog >> counters [
^counters copy .
]

{ #category : #accessing }
HyperLogLog >> estimatedElements [
	^ estimatedElements := hcf estimateElements.
]

{ #category : #'private - computing' }
HyperLogLog >> harmonicMean [
	| total |
	total := counters
		inject: 0
		into: [ :sum :each | sum + (2 ** (-1 * each)) ].
	^ multiSets / total
]

{ #category : #accessing }
HyperLogLog >> multiSets [
	^ multiSets
]

{ #category : #adding }
HyperLogLog >> rank: anInteger [
	1 to: restBits do: [ :i | 
		(anInteger bitAt: i) = 1
			ifTrue: [ ^ i ] ].
	^ restBits+1
]

{ #category : #initialization }
HyperLogLog >> setStandarError: aStandarError withHash: aHash [
	"Initialize the whole HLL variables from a Standar Error"

	targetStandarError := aStandarError.
	hash := aHash.
	hashBits := 32.
	indexBits := self class calculateIndexBits: aStandarError.
	restBits := hashBits - indexBits.
	multiSets := 2 ** indexBits.
	counters := Array new: multiSets withAll: 0.
	estimatedElements := 0.
	tempHash := 0.
	tempCounterPosition := 0.
	tempRank := 0.
	hcf := HLLCorrectionFunction with: self
]
