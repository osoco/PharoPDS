"
!PharoPDS

The purpose of PharoPDS is to provide some """"probabilistic data structures and algorithms"""" implemented in Pharo.

''Probabilistic data structures'' is a common name for data structures based mostly on different hashing techniques. Unlike regular and deterministic data structures, they always provide approximated answers but with reliable ways to estimate possible errors.

The potential losses and errors are fully compensated for by extremely low memory requirements, constant query time, and scaling. All these factors make these structures relevant in ''Big Data'' applications.

!!Data Structures

Currently, PharoPDS provides  probabilistic data structures for the following categories of problems:

!!! Membership

A ''membership problem'' for a dataset is a task to decide whether some elements belongs to the dataset or not.

The data structures provided to solve the membership problem are the following:

 - """"Bloom Filter"""": Learn more about it in ${class:PDSBloomFilter}$

!!! Cardinality

This is still a work in progress.

 - """"HyperLogLog""""

!!Algorithms Browser

In order to ease the understanding of the inner workings and trade-offs,  we provide specific Playground tools for each data structure that allows the developer to explore it and get deeper insights.

You can browse the available algorithm playgrounds throgh the """"PharoPDS Algorithms Browser"""". Try it now:

[[[ 
PDSAlgorithmsBrowser open 
]]]

!!License

PharoPDS software is free and open source under an """"MIT license"""".

!!Project dependencies

Hashing plays a central role in probabilistic data structures. Indeed, the choice of the appropiate hash functions is crucial to avoid bias and to reach a good performance. In particular, the structures require """"non-cryptographic hash functions"""" that are provided by the dependency module ==NonCryptographicHashes==. Learn more at ${class:BaselineOfNonCryptographicHashes}$.

Other dependencies like ==Roassal== or ==GToolkit== are optional for production use. Nevertheless, we recommend that you install them in the development image to get some useful tools like Inspector custom extensions, the algorithm browser or interactive tutorials.

The picture below depicts the project modules and their dependencies. The map is navigable. Click on each component to learn more about it.

${example:BaselineOfProbabilisticDataStructures class>>#itself|previewShow=#gtMapFor:||noCode=|previewHeight=400}$



"
Class {
	#name : #BaselineOfProbabilisticDataStructures,
	#superclass : #BaselineOf,
	#category : #BaselineOfProbabilisticDataStructures
}

{ #category : #accessing }
BaselineOfProbabilisticDataStructures class >> itself [
	<gtExample>
	^ self
]

{ #category : #baselines }
BaselineOfProbabilisticDataStructures >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self specProjects: spec.
			self specPackages: spec.
			self specGroups: spec 
		]
]

{ #category : #'as yet unclassified' }
BaselineOfProbabilisticDataStructures >> specGroups: spec [
	spec group: 'Core' with: #('PDS-Core').
	spec group: 'Tests' with: #('PDS-Core-Tests').
	spec group: 'Examples' with: #('PDS-Core-Examples').
	spec
		group: 'Playground'
		with: #('PDS-Playground' 'PDS-Inspector-Extensions').
	spec
		group: 'All'
		with:
			#('Playground' 'Tests' 'Examples' 'PDS-GToolkit-Extensions').
	spec group: 'default' with: #('Playground' 'Tests' 'Examples')
]

{ #category : #'as yet unclassified' }
BaselineOfProbabilisticDataStructures >> specPackages: spec [
	spec
		package: 'PDS-Core'
			with: [ spec requires: 'NonCryptographicHashes' ];
		package: 'PDS-Core-Tests' with: [ spec requires: 'PDS-Core' ];
		package: 'PDS-Core-Examples' with: [ spec requires: 'PDS-Core' ];
		package: 'PDS-Grapher' with: [ spec requires: 'Roassal2' ];
		package: 'PDS-Inspector-Extensions'
			with: [ spec requires: #('PDS-Core' 'PDS-Grapher' 'Roassal2') ];
		package: 'PDS-GToolkit-Extensions'
			with: [ spec
				requires: #('PDS-Core' 'PDS-Inspector-Extensions' 'Roassal2' 'GToolkit') ];
		package: 'PDS-Playground' with: [ spec requires: 'PDS-Core' ]
]

{ #category : #'as yet unclassified' }
BaselineOfProbabilisticDataStructures >> specProjects: spec [
spec
				baseline: 'Roassal2'
				with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
			spec
				baseline: 'GToolkit'
				with: [ spec repository: 'github://feenkcom/gtoolkit/src' ].
			spec
				baseline: 'NonCryptographicHashes'
				with:
					[ spec repository: 'github://osoco/pharo-non-cryptographic-hashes/src' ].
]
