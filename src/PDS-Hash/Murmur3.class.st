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
	| output words mixedWords remainingWord |
	output := seed.
	words := self thirtyTwoBitsWordsFrom: aByteArray.
	mixedWords := words collect: [ :eachWord | self mixWord: eachWord ].
	output := mixedWords
		inject: output
		into: [ :calculatingHash :word | 
			| tempHash |
			tempHash := calculatingHash.
			tempHash := tempHash bitXor: word asInteger.
			tempHash := self leftRotate: tempHash by: 13.
			(self multiply: tempHash by: 5) + 16re6546b64 & 16rffffffff ].
	remainingWord := self remainingWordFrom: aByteArray.
	output := output bitXor: (self mixWord: remainingWord) asInteger.
	"finalization mix - final avalanche"
	output := output bitXor: aByteArray size.
	output := output bitXor: output // (2 raisedTo: 16).
	output := self multiply: output  by: 16r85ebca6b.
	output := output bitXor: output // (2 raisedTo: 13).
	output := self multiply: output by: 16rc2b2ae35.
	output := output bitXor: output // (2 raisedTo: 16).
	^ output
]

{ #category : #private }
Murmur3 >> leftRotate: aWord by: shift [
	| maskOfShiftBits |
	maskOfShiftBits := (2 raisedTo: 32 - shift) - 1.
	^ ((aWord & maskOfShiftBits) << shift) | (aWord >> (32 - shift))
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
	mixedWord := self multiply: aThirtyTwoBitsWord asInteger by: c1.
	mixedWord := self leftRotate: mixedWord by: 13.
	mixedWord := self multiply: mixedWord asInteger by: c2.
	^ ThirtyTwoBitRegister new load: mixedWord
]

{ #category : #private }
Murmur3 >> multiply: aWord by: anotherWord [
	^ ((aWord & 16rFFFF) * anotherWord
		+ (((aWord >> 16) * anotherWord & 16rFFFF) << 16)) & 16rFFFFFFFF
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

{ #category : #setter }
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
							(ThirtyTwoBitRegister new
								byte1: (aByteArray at: index)
								byte2: (aByteArray at: index - 1)
								byte3: (aByteArray at: index - 2)
								byte4: (aByteArray at: index - 3)) ] ].
	^ words
]
