Class {
	#name : #BloomFilter,
	#superclass : #Object,
	#instVars : [
		'expectedElements',
		'fpp',
		'hashes',
		'bitStorage'
	],
	#category : #'PDS-Membership'
}

{ #category : #'instance creation' }
BloomFilter class >> new: expectedElements fpp: estimatedFalsePositiveProbability [
	^ self new
		expectedElements: expectedElements;
		fpp: estimatedFalsePositiveProbability;
		bitStorage:
			(BitArray
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
BloomFilter class >> optimumHashesFor: expectedElements andFpp: estimatedFalsePositiveProbability [
	| m |
	m := self optimumSizeFor: expectedElements  andFpp: estimatedFalsePositiveProbability.
	^ (m * 2 ln) / expectedElements 
]

{ #category : #'as yet unclassified' }
BloomFilter class >> optimumSizeFor: expectedElements andFpp: estimatedFalsePositiveProbability [ 
^ -1 * (expectedElements * estimatedFalsePositiveProbability ln)
		/ (2 ln raisedTo: 2)
]

{ #category : #adding }
BloomFilter >> add: anObject [
	| hash index |
	hash := self hash: anObject.
	index := hash \\ self size.
	bitStorage setBitAt: index
]

{ #category : #'accessing - private' }
BloomFilter >> bitStorage: anObject [
	bitStorage := anObject
]

{ #category : #'member lookup' }
BloomFilter >> contains: anObject [
	| hash index |
	hash := self hash: anObject.
	index := hash \\ self size.
	^ (bitStorage bitAt: index) = 1
]

{ #category : #accessing }
BloomFilter >> expectedElements [
	^ expectedElements
]

{ #category : #'accessing - private' }
BloomFilter >> expectedElements: anObject [
	expectedElements := anObject
]

{ #category : #accessing }
BloomFilter >> fpp [
	^ fpp
]

{ #category : #'accessing - private' }
BloomFilter >> fpp: anObject [
	fpp := anObject
]

{ #category : #'member lookup' }
BloomFilter >> hash: anObject [
^ (Murmur3 withSeed: 0) hash: anObject.
]

{ #category : #accessing }
BloomFilter >> hashes [
	^ hashes
]

{ #category : #'accessing - private' }
BloomFilter >> hashes: anObject [
	hashes := anObject
]

{ #category : #accessing }
BloomFilter >> size [
	^ bitStorage size
]
