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
Murmur3 >> hash128: aByteArray [
	| h1 h2 output sixteenBytesWords remainingWord |
	h1 := seed.
	h2 := seed.
	output := seed.
	sixteenBytesWords := self hundredTwentyEightBitsWordsFrom: aByteArray.
	sixteenBytesWords
		doWithIndex: [ :aHundredTwentyEightBitsWord :index | 
			self mixAndHashTwoWords: aHundredTwentyEightBitsWord withSeed: seed.
			h1 := 16rFFFFFFFFFFFFFFFF.
			h2 := 16rFFFFFFFFFFFFFFFF.
			^ h1 h2
			"
			self mixAndHashTwoWords: pairWords withSeed: calculatingHash .
			currentMixedWord := self mixWord: word.
			self mixHash: calculatingHash withWord: mixedWord" ]
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
Murmur3 >> hundredTwentyEightBitsWordsFrom: aByteArray [
	| words |
	words := OrderedCollection new.
	aByteArray
		doWithIndex: [ :e :index | 
			index % 16 = 0
				ifTrue: [ words add: (aByteArray asByteArray structAt: index - 15 length: 16) ] ].
	^ words
]

{ #category : #private }
Murmur3 >> mixAndHashTwoWords: aPairWords withSeed: aSeed [
	"for(int i = 0; i < nblocks; i++)
  {
    uint64_t k1 = getblock64(blocks,i*2+0);
    uint64_t k2 = getblock64(blocks,i*2+1);

    k1 *= c1; k1  = ROTL64(k1,31); k1 *= c2; h1 ^= k1;

    h1 = ROTL64(h1,27); h1 += h2; h1 = h1*5+0x52dce729;

    k2 *= c2; k2  = ROTL64(k2,33); k2 *= c1; h2 ^= k2;

    h2 = ROTL64(h2,31); h2 += h1; h2 = h2*5+0x38495ab5;
  }"

	| c1 c2 currentMixedWord nextMixedWord h1 h2 m n1 n2 |
	c1 := 16r87c37b91114253d5.
	c2 := 16r4cf5ad432745937f.
	m := 5.
	n1 := 16r52dce729.
	n2 := 16r38495ab5.
	h1 := aSeed.
	h2 := aSeed.
	currentMixedWord := ((self sixtyFourBitsWordsFrom: aPairWords) at: 1).
	nextMixedWord := ((self sixtyFourBitsWordsFrom: aPairWords) at: 2).
	currentMixedWord := BinaryOperations
		multiply: currentMixedWord asInteger
		by: c1.
	currentMixedWord := currentMixedWord <-<- 31.
	currentMixedWord := BinaryOperations
		multiply: currentMixedWord asInteger
		by: c2.
	h1 := h1 bitXor: currentMixedWord.
	h1 := h1 <-<- 27.
	h1 := h1 + h2.
	h1 := (BinaryOperations multiply: h1 asInteger by: m) + n1.
	nextMixedWord := BinaryOperations
		multiply: nextMixedWord asInteger
		by: c2.
	nextMixedWord := nextMixedWord <-<- 33.
	nextMixedWord := BinaryOperations
		multiply: nextMixedWord asInteger
		by: c1.
	h2 := h2 bitXor: nextMixedWord.
	h2 := h2 <-<- 31.
	h2 := h2 + h1.
	h2 := (BinaryOperations multiply: h2 asInteger by: m) + n2.
	^ h1 h2
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
Murmur3 >> sixtyFourBitsWordsFrom: aByteArray [
	| words |
	words := OrderedCollection new.
	aByteArray
		doWithIndex: [ :e :index | 
			index %  8 = 0
				ifTrue: [ words add: (aByteArray asByteArray structAt: index - 7 length: 8) ] ].
	^ words
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
