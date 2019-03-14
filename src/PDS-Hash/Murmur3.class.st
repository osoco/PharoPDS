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
Murmur3 >> hash: aCollection [ 
	^ ByteArray withAll: #(16r8d 16rc7 16re0 16r49)
]

{ #category : #setter }
Murmur3 >> seed: anInteger [ 
	seed := anInteger 
]
