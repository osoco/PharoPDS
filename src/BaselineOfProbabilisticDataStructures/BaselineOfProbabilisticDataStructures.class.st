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
		do: [ spec
				baseline: 'Roassal2'
				with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
			spec
				baseline: 'GToolkit'
				with: [ spec repository: 'github://feenkcom/gtoolkit/src' ].
			spec
				package: 'PDS-Hash';
				package: 'PDS-Hash-Tests' with: [ spec requires: 'PDS-Hash' ];
				package: 'PDS-Membership' with: [ spec requires: 'PDS-Hash' ];
				package: 'PDS-Membership-Tests'
					with: [ spec requires: 'PDS-Membership' ];
				package: 'PDS-Membership-Examples'
					with: [ spec requires: 'PDS-Membership' ];
				package: 'PDS-Grapher-Decorators'
					with: [ spec requires: 'Roassal2' ];
				package: 'PDS-Membership-Inspector-Extensions'
					with: [ spec
						requires: #('PDS-Membership' 'PDS-Grapher-Decorators' 'Roassal2') ];
				package: 'PDS-Membership-GToolkit-Extensions'
					with: [ spec
						requires: #('PDS-Membership' 'PDS-Membership-Inspector-Extensions' 'Roassal2' 'GToolkit') ];
				package: 'PDS-Membership-Analysis'
					with: [ spec requires: #('PDS-Membership' 'Roassal2') ];
				package: 'PDS-Membership-Playground'
					with: [ spec requires: 'PDS-Membership' ].
			spec group: 'Core' with: #('PDS-Membership').
			spec
				group: 'Tests'
				with: #('PDS-Membership-Tests' 'PDS-Hash-Tests').
			spec
				group: 'Playground'
				with:
					#('PDS-Membership' 'PDS-Membership-Inspector-Extensions' 'PDS-Membership-Analysis' 'PDS-Membership-Playground').
			spec
				group: 'All'
				with: #('Playground' 'PDS-Membership-GToolkit-Extensions').
			spec group: 'default' with: #('Playground' 'Tests') ]
]
