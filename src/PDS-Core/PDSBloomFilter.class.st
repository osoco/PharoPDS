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
	#category : #'PDS-Core-Membership'
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

{ #category : #accessing }
PDSBloomFilter >> fpp [
	^ 1 - (self hashes * self size / self storageSize) negated exp
		raisedTo: self hashes
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
