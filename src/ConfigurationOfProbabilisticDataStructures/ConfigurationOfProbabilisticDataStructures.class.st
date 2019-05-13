Class {
	#name : #ConfigurationOfProbabilisticDataStructures,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfProbabilisticDataStructures
}

{ #category : #'development support' }
ConfigurationOfProbabilisticDataStructures class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfProbabilisticDataStructures class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
ConfigurationOfProbabilisticDataStructures class >> catalogContactInfo [
	^ 'PharoPDS is written and supported by Rafael Luque, Javier Luque and other developers at OSOCO.'
]

{ #category : #catalog }
ConfigurationOfProbabilisticDataStructures class >> catalogDescription [
	^ 'The purpose of PharoPDS is to provide some probabilistic data structures and algorithms implemented in Pharo.

''Probabilistic data structures'' is a common name for data structures based mostly on different hashing techniques. Unlike regular and deterministic data structures, they always provide approximated answers but with reliable ways to estimate possible errors.

More info in the GitHub repository: https://github.com/osoco/PharoPDS'
]

{ #category : #catalog }
ConfigurationOfProbabilisticDataStructures class >> catalogKeywords [
	^ #(probabilistic data_structures algorithms bloom)
]

{ #category : #private }
ConfigurationOfProbabilisticDataStructures class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfProbabilisticDataStructures class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfProbabilisticDataStructures class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfProbabilisticDataStructures class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfProbabilisticDataStructures class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfProbabilisticDataStructures class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfProbabilisticDataStructures class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfProbabilisticDataStructures class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfProbabilisticDataStructures >> baseline1x: spec [
	<version: '1.x-baseline'>
	spec
		for: #common
		do: [ spec
				blessing: #baseline;
				author: 'Rafael Luque, Javier Luque, and other OSOCO developers.';
				description: 'Probabilistic Data Structures for Pharo'.
			spec
				baseline: 'ProbabilisticDataStructures'
				with: [ spec repository: 'github://osoco/PharoPDS:master/src' ] ]
]

{ #category : #accessing }
ConfigurationOfProbabilisticDataStructures >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfProbabilisticDataStructures >> development: spec [
	<symbolicVersion: #development>
	spec for: #common version: '1.x-baseline'
]

{ #category : #accessing }
ConfigurationOfProbabilisticDataStructures >> project [

	^ project ifNil: [ 
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfProbabilisticDataStructures >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.0.0'.

]

{ #category : #versions }
ConfigurationOfProbabilisticDataStructures >> version100: spec [
	<version: '1.0.0'>
	spec
		for: #common
		do: [ spec
				blessing: #stable;
				author: 'Rafael Luque, Javier Luque, and other OSOCO developers';
				description: 'Probabilistic Data Structures for Pharo'.
			spec
				baseline: 'ProbabilisticDataStructures'
				with: [ spec repository: 'github://osoco/PharoPDS:v1.0.0/src' ] ]
]
