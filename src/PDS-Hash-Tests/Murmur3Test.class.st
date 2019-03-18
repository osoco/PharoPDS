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
	self assert: (output printStringBase: 16) equals: '2362F9DE'
]

{ #category : #tests }
Murmur3Test >> testMurmur3WithSeveral32BitBlocks [
	| hasher output |
	hasher := Murmur3 withSeed: 0.
	output := hasher hash: #(10 20 30 40 50 60 70 80).
	self assert: (output printStringBase: 16) equals: '38DA13B5'
]
