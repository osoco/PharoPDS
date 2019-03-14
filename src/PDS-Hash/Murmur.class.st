Class {
	#name : #Murmur,
	#superclass : #Object,
	#category : #'PDS-Hash'
}

{ #category : #hashing }
Murmur class >> hash: anInteger [ 
	^ 3530670207
]

{ #category : #hashing }
Murmur class >> hash: aString seed: anInteger [ 
	^ 4122321252.
]
