"
Unit tests for the Murmur3 hashing algorithm.
"
Class {
	#name : #Murmur3Test,
	#superclass : #TestCase,
	#category : #'PDS-Hash-Tests'
}

{ #category : #tests }
Murmur3Test >> testMurmur3WithOne32BitBlock [
	| hasher output |
	hasher := Murmur3 withSeed: 0.
	output := hasher hash: #(0 0 0 0).
	self assert: (output printStringBase: 16) equals: 'DEF96223'
]

{ #category : #tests }
Murmur3Test >> testMurmur3WithSeveral32BitBlocks [
	| hasher output |
	hasher := Murmur3 withSeed: 0.
	output := hasher hash: #(10 20 30 40 50 51 52 53 54).
	self assert: output hex equals: '7ed80878'
]
