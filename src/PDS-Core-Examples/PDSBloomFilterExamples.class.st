Class {
	#name : #PDSBloomFilterExamples,
	#superclass : #Object,
	#category : #'PDS-Core-Examples-Membership'
}

{ #category : #accessing }
PDSBloomFilterExamples >> emptyBloomFilter [
	<gtExample>
	| bloom |
	bloom := PDSBloomFilter new: 10 fpp: 0.1.
	self assert: bloom size equals: 0.
	self assert: bloom hashes equals: 4.
	self assert: bloom storageSize equals: 48.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> fullBloomFilter [
	<gtExample>
	| bloom |
	bloom := self emptyBloomFilter.
	1 to: bloom targetElements
		do: [ :each | bloom add: each asString asByteArray ].
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> oneBillionBloomFilter [
	<gtExample>
	| bloom |
	bloom := PDSBloomFilter new: 1000000000 fpp: 0.02.
	self assert: bloom size equals: 0.
	self assert: bloom hashes equals: 6.
	self assert: bloom storageSize equals: 8142363337.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> withBerlinBloomFilter [
	<gtExample>
	| bloom |
	bloom := self emptyBloomFilter.
	bloom add: 'Berlin' asByteArray.
	self assert: bloom size equals: 1.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> withMadridAndBarcelonaBloomFilter [
	<gtExample>
	| bloom |
	bloom := self withMadridBloomFilter.
	bloom add: 'Barcelona' asByteArray.
	self assert: bloom size equals: 2.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> withMadridAndBarcelonaCheckBarcelonaBloomFilter [
	<gtExample>
	| bloom |
	bloom := self withMadridBloomFilter.
	bloom add: 'Barcelona' asByteArray.
	self assert: bloom size equals: 2.
	self assert: (bloom contains: 'Barcelona' asByteArray).
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> withMadridAndBarcelonaCheckBerlinBloomFilter [
	<gtExample>
	| bloom |
	bloom := self withMadridBloomFilter.
	bloom add: 'Barcelona' asByteArray.
	self assert: bloom size equals: 2.
	self assert: (bloom contains: 'Berlin' asByteArray) not.
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> withMadridAndBarcelonaCheckRomaBloomFilter [
	<gtExample>
	| bloom |
	bloom := self withMadridBloomFilter.
	bloom add: 'Barcelona' asByteArray.
	self assert: bloom size equals: 2.
	self assert: (bloom contains: 'Roma' asByteArray).
	^ bloom
]

{ #category : #accessing }
PDSBloomFilterExamples >> withMadridBloomFilter [
	<gtExample>
	| bloom |
	bloom := self emptyBloomFilter.
	bloom add: 'Madrid' asByteArray.
	self assert: bloom size equals: 1.
	^ bloom
]
