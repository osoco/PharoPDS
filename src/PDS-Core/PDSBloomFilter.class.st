"
!Bloom Filter

A Bloom filter is a space-efficient probabilistic data structure, conceived by """"Burton Howard Bloom"""" in 1970 (''Space/Time Tradeoffs in Hash Coding with Allowable Errors''), that represents a set of elements and allows you to test if an element is a membership.

!! Introduction

A regular ''hash-based search'' stores the full set of values from a collection in a hash table, whether in linked lists or using ''open addressing''. In both cases, as more elements are added to the hash table, the time to locate an element increases, degenerating the expected time performance from the initial constant ==O(1)== to the lineal ==O(N)==.

A """"Bloom Filter"""" provides an alternative structure that ensures """"constant performance"""" when adding elements or checking an element membership. This behaviour is independent of the number of items already added to the filter.

!! Basic understanding

The Bloom Filter can store a large set very efficiently by discarding the identity of the elements; i.e. it stores only a set of bits corresponding to some number of """"hash functions"""" that are applied to each added element by the algorithm.

Practically, the Bloom Filter is represented by a bit array and can be described by its length ==m== and number of different hash functions ==k==.

The structure supports only two operations:
  - Adding and element into the set, and
  - Testing whether an element is or is not a member of the set.

The Bloom Filter data structure is a bit array where at the beginning all bits are equal to zero, meaning the filter is empty.

For example, consider the following Bloom filter example created to represent a set of 10 elements with a """"false positive probability"""" ==FPP=0.1== (i.e. 10%).

This empty filter will be backed by a bit array of length ==m=48== (==storageSize==) and 4 hash functions to produce values in the range =={1, 2, ..., m}==. It has the following form:

${example:PDSBloomFilterExamples>>#emptyBloomFilter|previewShow=#gtStorageBitSetViewFor:|previewHeight=250}$


To insert an element ==x== into the filter, for every hash function ==h@@i@@==  we compute its value ==j=h@@i@@(x)== on the element ==x== and set the corresponding bit ==j== in the filter to one.

As an example, we are going to insert the names of cities into the previous filter. Let's start with """"Madrid"""":

${example:PDSBloomFilterExamples>>#withMadridBloomFilter|previewShow=#gtStorageBitSetViewFor:|previewHeight=250}$

In order to find the corresponding bits to be set for =='Madrid'==, the filter computes the corresponding 4 hash values. As you see above, the filter has set the bits 9, 18, 39 and 48.

It is possible that different elements can share bits, for instance, let's add another city, """"Barcelona"""", to the filter:

${example:PDSBloomFilterExamples>>#withMadridAndBarcelonaBloomFilter|previewShow=#gtStorageBitSetViewFor:|previewHeight=250}$

As you can see, after adding the String =='Barcelona'== to the previous Bloom filter only the bits 30, 36 and 42 have been set, meaning that the elements =='Madrid'== and =='Barcelona'== share one of their corresponding bits.

To test if a given element ==x== is in the filter, all ==k== hash functions are computed and check bits in the corresponding positions. If """"all"""" bits are set to one, then the element ==x== """"may exist"""" in the filter. Otherwise, the element ==x== is """"definitely not"""" in the filter.

The uncertainty about the element's existence originates from the possibility of situations when some bits are set by different elements added previously.

Consider the previous Bloom filter example with the elements =='Madrid'== and =='Barcelona'== added. To test if the element =='Barcelona'== is a member, the filter computes its 4 hash values and check that the corresponding bits in the filter are set to one, therefore the String =='Barcelona'== may exists in the filter and the ==contains: 'Barcelona'== returns ==true==:

${example:PDSBloomFilterExamples>>#withMadridAndBarcelonaCheckBarcelonaBloomFilter}$


Now if we check the element =='Berlin'==, the filter computes its hashes in order to find that the corresponding bits in the filter are the following:

${example:PDSBloomFilterExamples>>#withBerlinBloomFilter|previewShow=#gtStorageBitSetViewFor:|previewHeight=250}$

We see that the bits 27 and 33 aren't set, therefore the """"Berlin"""" element is definitely not in the filter, so the ==contains:== method returns ==false==:

${example:PDSBloomFilterExamples>>#withMadridAndBarcelonaCheckBerlinBloomFilter}$

A Blool filter can also result in a false positive result. For example, consider the element """"Roma"""", whose 4 hash values collision in the bit 36 that is set in the filter, so the result of the contains method is that the element may exist in the filter:

${example:PDSBloomFilterExamples>>#withMadridAndBarcelonaCheckRomaBloomFilter}$

As we know, we have not added that element and this is an example of a false positive. In this particular case, the bit 36 was set previously by the """"Barcelona"""" element.

!! Properties

!!! False positives

As we have shown, Bloom filters can lead to situations where some element is not a member, but the algorithm returns like it is. Such an event is called a """"false positive"""" and can occur because of hard hash collisions or coincidence in the stored bits. In the test operation there is no knowledge of whether the particular bit has been set by the same hash function as the one we compare with. 

Fortunately, a Bloom filter has a predictable false positive probability (==FPP==):

${icebergFile:path=osoco/pharo-probabilistic-data-structures/doc/pfp_formula.png|expanded=true|height=100|show=#gtFigureFor:}$

where ==n== is the number of values already added, ==k== the number of hashes and ==m== the length of the filter (i.e. the bit array size).

In the extreme case, when the filter is full every lookup will yield a (false) positive response. It means that the choice of ==m== depends on the estimated number of elements ==n== that are expected to be added, and ==m== should be quite large compared to ==n==.

In practice, the length of the filter ==m==, under given false positive probability ==Pfp== and the expected number of elements ==n==, can be determined by the formula:

${icebergFile:path=osoco/pharo-probabilistic-data-structures/doc/m_formula.png|expanded=true|height=100|show=#gtFigureFor:}$

For the given ratio of ==m/n==, meaning the number of allocated bits per element, the false positive probability can be tuned by choosing the number of hash functions ==k==. The optimal choice of ==k== is computed by minimizing the probability of false positives with the following formula:

${icebergFile:path=osoco/pharo-probabilistic-data-structures/doc/k_formula.png|expanded=true|height=100|show=#gtFigureFor:}$

Our ==PDSBloomFilter== implementation is built specifying the estimated number of elements to be added (==n==) and the false positive probability (==FPP==), then the data structure uses the previous formula to compute the optimal number of hashes and bit array length.

For instance, to handle 1 billion elements and keep the probability of false positive events at about 2% we need the following Bloom filter: 

${example:PDSBloomFilterExamples>>#oneBillionBloomFilter|previewShow=#gtParametersViewFor:|previewHeight=150}$

As you can see, the optimal number of hashes is 6 and the filter's length is ==8.14 x 10^^9^^== bits, that is approximately 1 GB of memory.

!!! False negatives

If the Bloom filter returns that a particular element isn't a member, then it's definitely not a member of the set.

!!! Deletion is not possible

To delete a particular element from the Bloom filter it would need to unset its corresponding ==k== bits in the bit array. Unfortunately, a single bit could correspond to multiple elements due to hash collisions and shared bits between elements.

!! Analysis

The previous formula for the false positive probability is a reasonably computation assuming the ==k== hash functions are uniformly random.

By other hand, the ==fpp== value specified when the ==PDSBloomFilter== is initialized should be interpreted as the desired fpp once the expected ==n== elements have been added to the structure.

For example, for a just created and still empty Bloom filter the data structure will have a ==fpp== equals to 0, as you can see in the graph below:

${example:PDSBloomFilterExamples>>#emptyBloomFilter|previewShow=#gtFPPCurveFor:|previewHeight=450}$

As you add elements to the filter the ==fpp== is increased and will be the target fpp when the filter reach the expected number of elements: 

${example:PDSBloomFilterExamples>>#fullBloomFilter|previewShow=#gtFPPCurveFor:|previewHeight=450}$

Nevertheless, you should know that the previou """"FPP curve"""" is a theoretical value and the """"actual FPP"""" observed will depend on the specific dataset you work with. In order to check empirically the goodness of our implementation we have run the following analysis:

    -# Randomly generate a list of email addresses which are inserted in the Bloom filter.
    -# Randomly generate a list of email addresses not inserted in the filter.
    -# Count the false positive events when searching for the missing addresses.

We ran the experiment for values from 10 to 1.5 times the expected number of elements of the filter (with steps of 10). For each number of elements the experiment is ran 10 times. The analysis shows a graph depicting the theoretical FPP curve of the filter, the actual FPP values measured in each experiment, the actual FPP curve (average of the actual FPP values) and the standard deviation.

For instance, the following graph shows the resulting analysis for a Bloom filter with 100 elements and FPP equals to 3%:

[[[
PDSBloomFilterAnalysis openFor: (PDSBloomFilter new: 100 fpp: 0.03)
]]]

!! Benchmarking

A Bloom filter only requires a fixed number of ==k== probes, so each insertion and search can be processed in ==O(k)== time, which is considered constant.

For instance, the following code will run a microbenchmark on the search operation for a Bloom filter previously populated with 10 elements and will show the number of operations executed per basicYear:  month:  day:  hour:  minute:  second:  nanoSecond:  offset: 

[[[
| bloom |
bloom := PDSBloomFilter new: 1000000 fpp: 0.03.
1 to: 10 do: [ :each | bloom add: ('element-', each asString) asByteArray  ].
[ bloom contains: 'no-member' asByteArray  ] bench.
]]]

As the performance is constant, the result should be similar in the folling case with the same Bloom filter with 1 million elements previously added: 

[[[
| bloom |
bloom := PDSBloomFilter new: 1000000 fpp: 0.03.
1 to: 1000000 do: [ :each | bloom add: ('element-', each asString) asByteArray  ].
[ bloom contains: 'no-member' asByteArray  ] bench.
]]]

A naive implementation based on a Collection data structure will show a linear ==O(n)== performance, or in the best case of an ordered collection, a logarithmic ==O(log n)== performance. In the following benchmarks you can check as the behaviour degrades whith the size of the collection (n):

[[[
| set |
set := OrderedCollection new: 1000000.
1 to: 10 do: [ :each | set add: ('element-', each asString)  ].
[ set includes: 'no element' ] bench
]]]

versus:

[[[
| set |
set := OrderedCollection new: 1000000.
1 to: 1000000 do: [ :each | set add: ('element-', each asString)  ].
[ set includes: 'no element' ] bench
]]]

!! Playground

PharoPDS provides a simple tool for the Bloom filter in order to allow you to explore and play with this data structure.

The """"PDSBloomFilterPlayground"" allows you to create Bloom filters to play with their operations and visualize them. You can event run benchmarking and profiling them from the UI.

Let's play with the playground:

[[[
PDSBloomFilterPlayground open
]]]

!! Context

'Donald Knuth' in his famous 'The Art of Computer Programming' writes the following about Bloom filters: 

""Imagine a search application with a large database in which no calculation needs to be done if the search was unsucessful. For example, we might want to check somebody's credit rating or passport number, and if no record for that person appears in the file we don't have to investigate further. Similarly in an application to computerized typesetting, we might have a simple algorithm that hyphenates most words correctly, but it fails on some 50,000 exception words; if we don't find the word in the exception file we are free to use the simple algorithm.""

Also 'Broder' and 'Mitzenmacher' stablished the following principle:

""Whenever a list or set is used, and space is at a premium, consider using a Bloom filter if the effect of false positives can be mitigated.""

!! Examples from the Real World^^tm^^

- Medium uses Bloom filters to avoid recommending articles a user has previously read.
- Google Chrome uses a Bloom filter to identify malicious URLs.
- Google BigTable, Apache HBase and Apache Cassandra use Bloom filters to reduce the disk lookups for non-existing rows or columns.
- The Squid Web proxy uses Bloom filters for cache digests.


"
Class {
	#name : #PDSBloomFilter,
	#superclass : #Object,
	#instVars : [
		'hashes',
		'bitStorage',
		'targetFpp',
		'targetElements',
		'size',
		'hashFunction'
	],
	#category : #'PDS-Core-Membership'
}

{ #category : #'default values' }
PDSBloomFilter class >> defaultHashFunction [
 ^ (NCHMurmur3 withSeed: 0)
]

{ #category : #'instance creation' }
PDSBloomFilter class >> new: expectedElements fpp: estimatedFalsePositiveProbability [
	^ self new: expectedElements fpp: estimatedFalsePositiveProbability hashFunction: self defaultHashFunction 
]

{ #category : #'instance creation' }
PDSBloomFilter class >> new: expectedElements fpp: estimatedFalsePositiveProbability hashFunction: aHashFunction [
	^ self new setTargetElements: expectedElements targetFpp: estimatedFalsePositiveProbability hashFunction: aHashFunction.
		
]

{ #category : #calculating }
PDSBloomFilter class >> optimumHashesFor: expectedElements andFpp: estimatedFalsePositiveProbability [
	| m |
	m := self optimumSizeFor: expectedElements  andFpp: estimatedFalsePositiveProbability.
	^ (m * 2 ln) / expectedElements 
]

{ #category : #calculating }
PDSBloomFilter class >> optimumSizeFor: expectedElements andFpp: estimatedFalsePositiveProbability [
	^ (expectedElements * estimatedFalsePositiveProbability ln) negated 
		/ (2 ln raisedTo: 2)
]

{ #category : #api }
PDSBloomFilter >> add: anObject [
	| indexes anyBitChanged |
	indexes := self bitIndexes: anObject.
	anyBitChanged := false.
	indexes
		do:
			[ :anIndex | anyBitChanged := anyBitChanged or: (bitStorage setBitAt: anIndex) ].
	anyBitChanged ifTrue: [ size := size + 1 ]
]

{ #category : #private }
PDSBloomFilter >> bitIndexes: anObject [
	| hashValues indexes |
	hashValues := self hashValuesFor: anObject.
	indexes := hashValues collect: [ :hash | (hash \\ self storageSize) + 1 ].
	^ indexes
]

{ #category : #api }
PDSBloomFilter >> contains: anObject [
	| indexes |
	indexes := self bitIndexes: anObject .
	^ indexes allSatisfy: [ :anIndex | (bitStorage bitAt: anIndex) = 1 ]

]

{ #category : #accessing }
PDSBloomFilter >> fpp [
	^ 1 - (self hashes * self size / self storageSize) negated exp
		raisedTo: self hashes
]

{ #category : #accessing }
PDSBloomFilter >> hashFunction [
	^ hashFunction
]

{ #category : #'member lookup' }
PDSBloomFilter >> hashValuesFor: anObject [
	| hashValues murmurHashOriginal h1 h2 |
	murmurHashOriginal := hashFunction hash: anObject.
	h1 := murmurHashOriginal & 16rFFFF.
	h2 := murmurHashOriginal >> 16.
	hashValues := (1 to: self hashes)
		collect: [ :element | h1 + (element * h2) ].
	^ hashValues
]

{ #category : #accessing }
PDSBloomFilter >> hashes [
	^ hashes
]

{ #category : #initialization }
PDSBloomFilter >> initialize [
	size := 0.
]

{ #category : #calculating }
PDSBloomFilter >> optimumHashes [
^(self class
		optimumHashesFor: targetElements 
		andFpp: targetFpp ) roundUpTo: 1
]

{ #category : #calculating }
PDSBloomFilter >> optimumSize [
^ (self class
		optimumSizeFor: targetElements 
		andFpp: targetFpp ) roundUpTo: 1
]

{ #category : #api }
PDSBloomFilter >> reset [
	^ self class new: targetElements fpp: targetFpp hashFunction: hashFunction
]

{ #category : #initialization }
PDSBloomFilter >> setTargetElements: estimatedElements targetFpp: estimatedFalsePositiveProbability hashFunction: aHashFunction [
	targetElements := estimatedElements.
	targetFpp := estimatedFalsePositiveProbability.
	hashFunction := aHashFunction.
	bitStorage := PDSBitArray new: self optimumSize.
	hashes := self optimumHashes
]

{ #category : #accessing }
PDSBloomFilter >> size [
	^ size
]

{ #category : #accessing }
PDSBloomFilter >> storageSize [
	^ bitStorage size
]

{ #category : #accessing }
PDSBloomFilter >> targetElements [
	^ targetElements
]

{ #category : #accessing }
PDSBloomFilter >> targetFpp [
	^ targetFpp
]
