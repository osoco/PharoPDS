Class {
	#name : #BloomFilterTests,
	#superclass : #TestCase,
	#category : #'PDS-Membership-Tests'
}

{ #category : #tests }
BloomFilterTests >> bloomHashesForElements: expectedElements fpp: estimatedFalsePositiveProbability [
	| m |
	m := self bloomSizeForElements: expectedElements  fpp: estimatedFalsePositiveProbability.
	^ (m * 2 ln) / expectedElements 
]

{ #category : #tests }
BloomFilterTests >> bloomSizeForElements: expectedElements fpp: estimatedFalsePositiveProbability [
^ -1 * (expectedElements * estimatedFalsePositiveProbability ln ) / ((2 ln) raisedTo: 2)
]

{ #category : #tests }
BloomFilterTests >> testFilterCreation [
	| filter |
	filter := BloomFilter new: 100 fpp: 0.1.
	self assert: filter isNotNil
]

{ #category : #tests }
BloomFilterTests >> testFilterInitialized [
	| filter |
	filter := BloomFilter new: 100 fpp: 0.1.
	self
		assert: filter size
		equals: ((self bloomSizeForElements: 100 fpp: 0.1) roundUpTo: 1).
	self
		assert: filter hashes
		equals: ((self bloomHashesForElements: 100 fpp: 0.1) roundUpTo: 1)
]

{ #category : #tests }
BloomFilterTests >> testForAddedElement [
	| filter element |
	filter := BloomFilter  new: 10 fpp: 0.1.
	element := 42 asByteArray.
	filter add: element.
	self assert: (filter contains: element)
]

{ #category : #tests }
BloomFilterTests >> testForNonAddedElement [
| filter element |
filter := BloomFilter new: 10 fpp: 0.1.
element := 42 asByteArray.
self assert: (filter contains: element) not.
]
