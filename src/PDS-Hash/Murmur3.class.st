Class {
	#name : #Murmur3,
	#superclass : #Object,
	#instVars : [
		'seed'
	],
	#category : #'PDS-Hash'
}

{ #category : #'instance creation' }
Murmur3 class >> withSeed: anInteger [ 
	^ self new 
	   seed: anInteger;   
	   yourself
]

{ #category : #hashing }
Murmur3 >> hash: aByteArray [
	| output words |
	output := seed.
	words := self thirtyTwoBitsRegisterFrom: aByteArray.
	output := words
		inject: output
		into: [ :calculatingHash :word | 
			| tempHash |
			tempHash bitXor: word.
			tempHash leftRotateBy: 13.
			tempHash * 5 + 16re6546b64 ].
	^ output 
]

{ #category : #setter }
Murmur3 >> seed: anInteger [ 
	seed := anInteger 
]

{ #category : #private }
Murmur3 >> thirtyTwoBitsRegisterFrom: aByteArray [
	| words |
	words := OrderedCollection new.
	aByteArray
		doWithIndex: [ :e :index | 
			index % 4 = 0
				ifTrue: [ words
						add:
							(ThirtyTwoBitRegister new 
								byte1: (aByteArray at: index)
								byte2: (aByteArray at: index - 1)
								byte3: (aByteArray at: index - 2)
								byte4: (aByteArray at: index - 3)) ] ].
	^ words
]
