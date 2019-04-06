Class {
	#name : #PDSBloomFilterExamples,
	#superclass : #Object,
	#category : #'PDS-Membership-Examples'
}

{ #category : #accessing }
PDSBloomFilterExamples >> emptyBloomFilter [
	<gtExample>
	| bloom |
	bloom := BloomFilter new: 10 fpp: 0.1.
	self assert: bloom size equals: 0.
	self assert: bloom hashes  equals: 4.
	self assert: bloom storageSize equals: 48.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> oneElementBloomFilter [
	<gtExample>
	| bloom |
	bloom := self emptyBloomFilter.
	bloom add: 'Hello World!' asByteArray.
	self assert: bloom size equals: 1.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> twoElementsBloomFilter [
	<gtExample>
	| bloom |
	bloom := self oneElementBloomFilter.
	bloom add: '42 is the answer' asByteArray.
	self assert: bloom size equals: 2.
	^ bloom
]
