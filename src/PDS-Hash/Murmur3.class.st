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
	value := BinaryOperations
		multiply: value
		by: 16r85ebca6b
		wordLength: 32.
	value := value bitXor: value >> 13.
	value := BinaryOperations multiply: value by: 16rc2b2ae35 wordLength: 32.
	value := value bitXor: value >> 16.
	^ value
]

{ #category : #'public - hashing' }
Murmur3 >> hash128: aByteArray [
	| h1 h2 pairOfHashes sixteenBytesWords |
	h1 := self seed.
	h2 := self seed.
	pairOfHashes := Array with: h1 with: h2.
	sixteenBytesWords := self wordsFrom: aByteArray ofLength: 16.
	sixteenBytesWords
		doWithIndex: [ :aHundredTwentyEightBitsWord :index | 
			"
			self mixAndHashTwoWords: pairWords withSeed: calculatingHash .
			currentMixedWord := self mixWord: word.
			self mixHash: calculatingHash withWord: mixedWord"
			pairOfHashes := self
				mixAndHashTwoWords: aHundredTwentyEightBitsWord
				withHashes: pairOfHashes ].
	h1 := pairOfHashes at: 1.
	h2 := pairOfHashes at: 2.
	h1 := h1 bitXor: aByteArray size.
	h2 := h2 bitXor: aByteArray size.
	h1 := h1 + h2& 16rFFFFFFFFFFFFFFFF.
	h2 := h2 + h1& 16rFFFFFFFFFFFFFFFF.
	h1 := self mix64BitsWord: h1.
	h2 := self mix64BitsWord: h2.
	h1 := h1 + h2& 16rFFFFFFFFFFFFFFFF.
	h2 := h2 + h1& 16rFFFFFFFFFFFFFFFF.
	pairOfHashes at: 1 put: h1.
	pairOfHashes at: 2 put: h2.
	^ pairOfHashes
]

{ #category : #'public - hashing' }
Murmur3 >> hash: aByteArray [
	| output words remainingWord bytesOfHash |
	bytesOfHash := 4.
	output := seed.
	words := self wordsFrom: aByteArray ofLength: bytesOfHash.
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
Murmur3 >> mix64BitsWord: aSixtyFourBitsWord [
	| mixedWord |
	mixedWord := aSixtyFourBitsWord.
	mixedWord := mixedWord bitXor: mixedWord >> 33.
	mixedWord := -1
		*
			(BinaryOperations
				multiply: mixedWord
				by: 16rFF51AFD7ED558CCD
				wordLength: 64).
	mixedWord := mixedWord bitXor: mixedWord >> 33.
	mixedWord := BinaryOperations
		multiply: mixedWord
		by: 16rc4ceb9fe1a85ec53
		wordLength: 64.
	mixedWord := mixedWord bitXor: mixedWord >> 33.
	^ mixedWord

	"k ^= k >> 33;
  k *= BIG_CONSTANT(0xff51afd7ed558ccd);
  k ^= k >> 33;
  k *= BIG_CONSTANT(0xc4ceb9fe1a85ec53);
  k ^= k >> 33;"
]

{ #category : #private }
Murmur3 >> mixAndHashTwoWords: aPairWords withHashes: aPairOfHashes [
	| c1 c2 currentMixedWord nextMixedWord h1 h2 m n1 n2 sixtyFourBitsWords |
	c1 := 16r87c37b91114253d5.
	c2 := 16r4cf5ad432745937f.
	m := 5.
	n1 := 16r52dce729.
	n2 := 16r38495ab5.
	sixtyFourBitsWords := self wordsFrom: aPairWords ofLength: 8.
	currentMixedWord := sixtyFourBitsWords at: 1.
	nextMixedWord := sixtyFourBitsWords at: 2.
	h1 := aPairOfHashes at: 1.
	h2 := aPairOfHashes at: 2.
	currentMixedWord := BinaryOperations
		multiply: currentMixedWord
		by: c1
		wordLength: 64.
	currentMixedWord := BinaryOperations
		leftRotate: currentMixedWord
		by: 31
		wordLength: 64.
	currentMixedWord := BinaryOperations
		multiply: currentMixedWord
		by: c2
		wordLength: 64.
	h1 := h1 bitXor: currentMixedWord.
	h1 := BinaryOperations leftRotate: h1 by: 27 wordLength: 64.
	h1 := h1 + h2 & 16rFFFFFFFFFFFFFFFF.
	h1 := (BinaryOperations multiply: h1 by: m wordLength: 64) + n1
		& 16rFFFFFFFFFFFFFFFF.
	nextMixedWord := BinaryOperations
		multiply: nextMixedWord
		by: c2
		wordLength: 64.
	nextMixedWord := BinaryOperations
		leftRotate: nextMixedWord
		by: 33
		wordLength: 64.
	nextMixedWord := BinaryOperations
		multiply: nextMixedWord
		by: c1
		wordLength: 64.
	h2 := h2 bitXor: nextMixedWord.
	h2 := BinaryOperations leftRotate: h2 by: 31 wordLength: 64.
	h2 := h2 + h1 & 16rFFFFFFFFFFFFFFFF.
	h2 := (BinaryOperations multiply: h2 by: m wordLength: 64) + n2
		& 16rFFFFFFFFFFFFFFFF.
	aPairOfHashes at: 1 put: h1.
	aPairOfHashes at: 2 put: h2.
	^ aPairOfHashes
	"for(int i = 0; i < nblocks; i++)
  {
    uint64_t k1 = getblock64(blocks,i*2+0);
    uint64_t k2 = getblock64(blocks,i*2+1);

    k1 *= c1; k1  = ROTL64(k1,31); k1 *= c2; h1 ^= k1;

    h1 = ROTL64(h1,27); h1 += h2; h1 = h1*5+0x52dce729;

    k2 *= c2; k2  = ROTL64(k2,33); k2 *= c1; h2 ^= k2;

    h2 = ROTL64(h2,31); h2 += h1; h2 = h2*5+0x38495ab5;
  }"
]

{ #category : #private }
Murmur3 >> mixHash: calculatingHash withWord: mixedWord [
	| tempHash |
	tempHash := calculatingHash bitXor: mixedWord asInteger.
	tempHash := BinaryOperations
		leftRotate: tempHash
		by: 13
		wordLength: 32.
	^ (BinaryOperations multiply: tempHash by: 5 wordLength: 32) + 16re6546b64
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
		by: c1
		wordLength: 32.
	mixedWord := BinaryOperations
		leftRotate: mixedWord
		by: 15
		wordLength: 32.
	^ BinaryOperations multiply: mixedWord asInteger by: c2 wordLength: 32
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
Murmur3 >> seed [
	^seed
]

{ #category : #'public - accessing' }
Murmur3 >> seed: anInteger [ 
	seed := anInteger 
]

{ #category : #private }
Murmur3 >> wordsFrom: aByteArray ofLength: bytes [
	| words newWord |
	words := OrderedCollection new.
	1 to: aByteArray size do: [ :index | 
		index % bytes = 0
			ifTrue: [ newWord := ByteArray new: bytes.
				1 to: bytes do: [ :i | newWord at: i put: (aByteArray at: index - i + 1) ].
				words add: newWord ] ].
	"	aByteArray
		doWithIndex: [ :e :index | 
			index % bytes = 0
				ifTrue: [ 1 to: index do: [ :i | 
						newWord at: i put: (aByteArray at: index - i + 1).
						words add: newWord ] ] ]."
	^ words
]
