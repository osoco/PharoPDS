Class {
	#name : #BaselineOfProbabilisticDataStructures,
	#superclass : #BaselineOf,
	#category : #BaselineOfProbabilisticDataStructures
}

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
