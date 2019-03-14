Class {
	#name : #MurmurTests,
	#superclass : #TestCase,
	#category : #'PDS-Hash-Tests'
}

{ #category : #tests }
MurmurTests >> testHashString [
	| hash |
	hash := Murmur hash: '0'.
	self assert: hash equals: 3530670207.
	

]

{ #category : #tests }
MurmurTests >> testHashStringWithDefaultSeed [
	| hashWithoutSeed hashWithDefaultSeed |
	hashWithoutSeed := Murmur hash: '0'.
	hashWithDefaultSeed := Murmur hash: '0' seed: '0'.
	self assert: hashWithDefaultSeed equals: hashWithoutSeed.
	

]

{ #category : #tests }
MurmurTests >> testHashStringWithSeed [
	| hash |
	hash := Murmur hash: '0' seed: 1234.
	self assert: hash equals: 4122321252.
	

]
