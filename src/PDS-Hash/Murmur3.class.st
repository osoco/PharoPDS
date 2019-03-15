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
			tempHash bitXor: word asInteger.
			tempHash := ((ThirtyTwoBitRegister new load: tempHash)
				leftRotateBy: 13) asInteger.
			(tempHash * 5 + 16re6546b64) & 16rffffffff ].
	remainingWord := self remainingWordFrom: aByteArray.
	output := output bitXor: (self mixWord: remainingWord) asInteger.
	"finalization mix - final avalanche"
	output := output bitXor: aByteArray size.
	output := output bitXor: output // (2 raisedTo: 16).
	output := output * 16r85ebca6b & 16rffffffff.
	output := output bitXor: output // (2 raisedTo: 13).
	output := output * 16rc2b2ae35 & 16rffffffff.
	output := output bitXor: output // (2 raisedTo: 16).
	^ output
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
	mixedWord := ThirtyTwoBitRegister new
		load: (aThirtyTwoBitsWord asInteger * c1) & 16rffffffff.
	mixedWord leftRotateBy: 15.
	mixedWord load: (mixedWord asInteger * c2) & 16rffffffff.
	^ mixedWord
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
