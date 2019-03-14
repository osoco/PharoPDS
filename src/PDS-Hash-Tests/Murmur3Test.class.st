"
Unit tests for the Murmur3 hashing algorithm.
"
Class {
	#name : #Murmur3Test,
	#superclass : #TestCase,
	#category : #'PDS-Hash-Tests'
}

{ #category : #tests }
Murmur3Test >> testMurmur3For32Bits [
	| hasher output |
	hasher := Murmur3 withSeed: 1234.
	output := hasher hash: #(10 20 30 40 50).
	self assert: output hex equals: '8dc7e049'
]
