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
	hasher := Murmur3 withSeed: 1234.
	output := hasher hash: #(100 101 102 103).
	self assert: (output printStringBase: 16) equals: '886f11a1'
]

{ #category : #tests }
Murmur3Test >> testMurmur3WithSeveral32BitBlocks [
	| hasher output |
	hasher := Murmur3 withSeed: 0.
	output := hasher hash: #(10 20 30 40 50 51 52 53 54).
	self assert: output hex equals: '7ed80878'
]
