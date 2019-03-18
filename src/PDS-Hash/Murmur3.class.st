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

{ #category : #private }
Murmur3 >> finalAvalanche: hash withLength: length [
	| value |
	value := hash bitXor: length.
	value := value bitXor: value >> 16.
	value := BinaryOperations  multiply: value by: 16r85ebca6b.
	value := value bitXor: value >> 13.
	value := BinaryOperations  multiply: value by: 16rc2b2ae35.
	value := value bitXor: value >> 16.
	^ value
]

{ #category : #'public - hashing' }
Murmur3 >> hash: aByteArray [
	| output words remainingWord |
	output := seed.
	words := self thirtyTwoBitsWordsFrom: aByteArray.
	output := words
		inject: output
		into: [ :calculatingHash :word | 
			| mixedWord |
			mixedWord := self mixWord: word.
			self mixHash: calculatingHash withWord: mixedWord ].
	remainingWord := self remainingWordFrom: aByteArray.
	output := output bitXor: (self mixWord: remainingWord) asInteger.
	output := self finalAvalanche: output withLength: aByteArray size.
	^ output
]

{ #category : #private }
Murmur3 >> mixHash: calculatingHash withWord: mixedWord [
	| tempHash |
	tempHash := calculatingHash bitXor: mixedWord asInteger.
	tempHash := tempHash <-<- 13.
	^ (BinaryOperations multiply: tempHash by: 5) + 16re6546b64
		& 16rffffffff
]

{ #category : #private }
Murmur3 >> mixWord: aThirtyTwoBitsWord [
	"  private static int mixK1(int k1) {
    k1 *= C1;
    k1 = Integer.rotateLeft(k1, 15);
    k1 *= C2;
    return k1;
}"

	| c1 c2 mixedWord |
	c1 := 16rcc9e2d51.
	c2 := 16r1b873593.
	mixedWord := BinaryOperations
		multiply: aThirtyTwoBitsWord asInteger
		by: c1.
	mixedWord := mixedWord <-<- 15.
	^ BinaryOperations multiply: mixedWord asInteger by: c2
]

{ #category : #private }
Murmur3 >> remainingWordFrom: aByteArray [
	"    
K1 = 0;
for (int shift = 0; i < len; i++, shift += 8) {
   k1 ^= toInt(input[off + i]) << shift;
}
"

	| numberOfRemainingBytes remainingWord offsetRemainingBytes remainingByteArray |
	numberOfRemainingBytes := aByteArray size % 4.
	offsetRemainingBytes := aByteArray size - numberOfRemainingBytes.
	remainingByteArray := ByteArray new: 4.
	numberOfRemainingBytes > 0 ifTrue: [ 
			0 to: numberOfRemainingBytes - 1 do: [ :index | 
		remainingByteArray
			byteAt: 4 - index
			put: (aByteArray at: offsetRemainingBytes + index + 1) ]. ].

	remainingWord := ThirtyTwoBitRegister new
		loadFrom: remainingByteArray
		at: 1.
	^ remainingWord
]

{ #category : #'public - accessing' }
Murmur3 >> seed: anInteger [ 
	seed := anInteger 
]

{ #category : #private }
Murmur3 >> thirtyTwoBitsWordsFrom: aByteArray [
	| words |
	words := OrderedCollection new.
	aByteArray
		doWithIndex: [ :e :index | 
			index % 4 = 0
				ifTrue: [ words
						add:
							(ByteArray
								with: (aByteArray at: index)
								with: (aByteArray at: index - 1)
								with: (aByteArray at: index - 2)
								with: (aByteArray at: index - 3)) ] ].
	^ words
]
