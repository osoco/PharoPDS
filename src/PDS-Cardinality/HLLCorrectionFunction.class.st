Class {
	#name : #HLLCorrectionFunction,
	#superclass : #Object,
	#instVars : [
		'hll'
	],
	#category : #'PDS-Cardinality'
}

{ #category : #'instance creation' }
HLLCorrectionFunction class >> with: aHLL [
	|hcf|
	hcf :=HLLCorrectionFunction new.
	hcf hll: aHLL.
	^hcf
]

{ #category : #'as yet unclassified' }
HLLCorrectionFunction >> computeZ [
^ hll counters
				inject: 0
				into: [ :sum :each | 
					each = 0
						ifTrue: [ sum + 1 ]
						ifFalse: [ sum ] ].
]

{ #category : #'as yet unclassified' }
HLLCorrectionFunction >> estimateElements [
	| tempElements estimatedElements |
	tempElements := hll biasCorrection * hll multiSets * hll harmonicMean.
	estimatedElements := tempElements.
	tempElements <= (5 * hll multiSets / 2)
		ifTrue: [ | tempZ |
			tempZ := self computeZ.
			tempZ = 0
				ifFalse: [ estimatedElements := hll multiSets * (hll multiSets / tempZ) ln ] ]
		ifFalse: [ tempElements > (2 ** 32 / 30)
				ifTrue: [ estimatedElements := -1
						* (2 ** 32 * (1 - (tempElements / (2 * 32)) log)) ] ].
	^ estimatedElements := estimatedElements roundUpTo: 1
]

{ #category : #accessing }
HLLCorrectionFunction >> hll: anObject [
	hll := anObject
]
