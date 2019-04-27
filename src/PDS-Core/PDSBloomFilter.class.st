Class {
	#name : #PDSBloomFilter,
	#superclass : #Object,
	#instVars : [
		'hashes',
		'bitStorage',
		'targetFpp',
		'targetElements',
		'size',
		'hashFunction'
	],
	#category : #'PDS-Core-Membership'
}

{ #category : #'default values' }
PDSBloomFilter class >> defaultHashFunction [
 ^ (NCHMurmur3 withSeed: 0)
]

{ #category : #'instance creation' }
PDSBloomFilter class >> new: expectedElements fpp: estimatedFalsePositiveProbability [
	^ self new: expectedElements fpp: estimatedFalsePositiveProbability hashFunction: self defaultHashFunction 
]

{ #category : #'instance creation' }
PDSBloomFilter class >> new: expectedElements fpp: estimatedFalsePositiveProbability hashFunction: aHashFunction [
	^ self new setTargetElements: expectedElements targetFpp: estimatedFalsePositiveProbability hashFunction: aHashFunction.
		
]

{ #category : #calculating }
PDSBloomFilter class >> optimumHashesFor: expectedElements andFpp: estimatedFalsePositiveProbability [
	| m |
	m := self optimumSizeFor: expectedElements  andFpp: estimatedFalsePositiveProbability.
	^ (m * 2 ln) / expectedElements 
]

{ #category : #calculating }
PDSBloomFilter class >> optimumSizeFor: expectedElements andFpp: estimatedFalsePositiveProbability [
	^ (expectedElements * estimatedFalsePositiveProbability ln) negated 
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

{ #category : #api }
PDSBloomFilter >> contains: anObject [
	| indexes |
	indexes := self bitIndexes: anObject .
	^ indexes allSatisfy: [ :anIndex | (bitStorage bitAt: anIndex) = 1 ]

]

{ #category : #accessing }
PDSBloomFilter >> fpp [
	^ 1 - (self hashes * self size / self storageSize) negated exp
		raisedTo: self hashes
]

{ #category : #accessing }
PDSBloomFilter >> hashFunction [
	^ hashFunction
]

{ #category : #'member lookup' }
PDSBloomFilter >> hashValuesFor: anObject [
	| hashValues murmurHashOriginal h1 h2 |
	murmurHashOriginal := hashFunction hash: anObject.
	h1 := murmurHashOriginal & 16rFFFF.
	h2 := murmurHashOriginal >> 16.
	hashValues := (1 to: self hashes)
		collect: [ :element | h1 + (element * h2) ].
	^ hashValues
]

{ #category : #accessing }
PDSBloomFilter >> hashes [
	^ hashes
]

{ #category : #initialization }
PDSBloomFilter >> initialize [
	size := 0.
]

{ #category : #calculating }
PDSBloomFilter >> optimumHashes [
^(self class
		optimumHashesFor: targetElements 
		andFpp: targetFpp ) roundUpTo: 1
]

{ #category : #calculating }
PDSBloomFilter >> optimumSize [
^ (self class
		optimumSizeFor: targetElements 
		andFpp: targetFpp ) roundUpTo: 1
]

{ #category : #api }
PDSBloomFilter >> reset [
	^ self class new: targetElements fpp: targetFpp hashFunction: hashFunction
]

{ #category : #initialization }
PDSBloomFilter >> setTargetElements: estimatedElements targetFpp: estimatedFalsePositiveProbability hashFunction: aHashFunction [
	targetElements := estimatedElements.
	targetFpp := estimatedFalsePositiveProbability.
	hashFunction := aHashFunction.
	bitStorage := PDSBitArray new: self optimumSize.
	hashes := self optimumHashes
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

{ #category : #accessing }
PDSBloomFilter >> targetFpp [
	^ targetFpp
]
