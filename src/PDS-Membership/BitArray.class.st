Class {
	#name : #BitArray,
	#superclass : #Object,
	#instVars : [
		'storage',
		'size',
		'holdBits'
	],
	#category : #'PDS-Membership'
}

{ #category : #'instance creation' }
BitArray class >> new: aNumberOfBits [
	^ self new
		storage: (ByteArray new: (aNumberOfBits / 8 roundUpTo: 1));
		size: aNumberOfBits;
		yourself
]

{ #category : #'member lookup' }
BitArray >> bitAt: index [
	| byteIndex byteValue mask |
	byteIndex := index / 8 roundUpTo: 1.
	byteValue := storage byteAt: byteIndex.
	mask := 2 raisedTo: byteIndex * 8 - index.
	(byteValue & mask) = 0
		ifTrue: [ ^ 0 ]
		ifFalse: [ ^ 1 ]
]

{ #category : #'gt-inspector-extension' }
BitArray >> gtInspectorItemsIn2: composite [
	<gtInspectorPresentationOrder: 1>
	^ composite roassal2
		title: 'View2';
		initializeView: [ | v n aCollection shape elements |
			aCollection := OrderedCollection empty.
			1 to: self size do: [ :index | aCollection add: (self bitAt: index) ].
			v := RTView new.
			n := RTMultiLinearColor new.
			n
				colors:
					{Color gray.
					Color green}.
			shape := RTBox new color: n.
			elements := shape elementsOn: aCollection.
			elements @ RTPopup.
			v addAll: elements.
			RTGridLayout on: elements.
			v build ]
]

{ #category : #'gt-inspector-extension' }
BitArray >> gtInspectorItemsIn3: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite roassal2
		title: 'View3';
		initializeView: [ | v n aCollection shape1 shape2 elements |
			aCollection := OrderedCollection empty.
			1 to: self size do: [ :index | aCollection add: (self bitAt: index) ].
			v := RTView new.
			n := RTMultiLinearColor new.
			n
				colors:
					{Color gray.
					Color green}.
			shape1 := (RTBox new
				color: n;
				size: 20) + RTLabel.
			shape2 := (RTEllipse new
				color: n;
				size: 20) + RTLabel.
			elements := RTGroup new.
			1 to: self size do: [ :index | 
				| i |
				i := self bitAt: index.
				i = 0
					ifTrue: [ elements add: (shape1 elementOn: i) ]
					ifFalse: [ elements add: (shape2 elementOn: i) ] ].
			"shape elementsOn: aCollection."
			v addAll: elements.
			elements
				@ (RTPopup new text: [ :element | 'value:' , element asString ]).
			"			elements
				@
					(RTLabeled new
						center;
						color: Color black;
						fontSize: 30)."
			RTGridLayout on: elements.
			v build ]
]

{ #category : #'gt-inspector-extension' }
BitArray >> gtInspectorItemsIn4: composite [
	<gtInspectorPresentationOrder: 3>
	^ composite roassal2
		title: 'View4';
		initializeView: [ | v n aCollection shape1 shape2 elements |
			aCollection := OrderedCollection empty.
			1 to: self size do: [ :index | aCollection add: (self bitAt: index) ].
			v := RTView new.
			n := RTMultiLinearColor new.
			n
				colors:
					{Color gray.
					Color green}.
			shape1 := (RTBox new
				color: n;
				size: 20) + (RTLabel color: Color black).
			shape2 := (RTEllipse new
				color: n;
				size: 20) + RTLabel color: Color black.
			elements := RTGroup new.
			elements addAll: (shape1 elementsOn: aCollection).
			v addAll: elements.
			elements
				@ (RTPopup new text: [ :element | 'value:' , element asString ]).
			"			elements
				@
					(RTLabeled new
						center;
						color: Color black;
						fontSize: 30).
"
			RTGridLayout on: elements.
			v build ]
]

{ #category : #'gt-inspector-extension' }
BitArray >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite roassal2
		title: 'View';
		initializeView: [ | b aCollection |
			aCollection := OrderedCollection empty.
			1 to: self size do: [ :index | aCollection add: (self bitAt: index) ].
			b := RTMondrian new.
			b shape rectangle
				size: 20;
				if: [ :i | i = 1 ] color: Color red;
				if: [ :i | i = 0 ] color: Color blue.
			b nodes: aCollection.

			b layout grid.
			b build ]
]

{ #category : #'gt-inspector-extension' }
BitArray >> gtInspectorParametersIn: composite [
	<gtInspectorPresentationOrder: 5>
	^ composite fastTable
		title: 'Parameters';
		display: [ {('HoldBits' -> self holdBits).
			('Size' -> self size)} ];
		column: 'Name'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]
]

{ #category : #accessing }
BitArray >> holdBits [
	^ holdBits
]

{ #category : #'accessing - private' }
BitArray >> incHoldBits [
holdBits :=holdBits +1.
]

{ #category : #initialization }
BitArray >> initialize [
holdBits := 0.
]

{ #category : #'accessing - private' }
BitArray >> setBitAt: index [
	| byteIndex byteValue bitChanged |
	byteIndex := (index / 8) ceiling.
	byteValue := storage byteAt: byteIndex.
	bitChanged := (byteValue bitXor: (2 raisedTo: byteIndex * 8 - index))
		> 0.
	bitChanged
		ifTrue: [ storage
				byteAt: byteIndex
				put: byteValue | (2 raisedTo: byteIndex * 8 - index).
			self incHoldBits ].
	^ bitChanged
]

{ #category : #'accessing - private' }
BitArray >> size [
	^ size
]

{ #category : #'accessing - private' }
BitArray >> size: aNumberOfBits [
size := aNumberOfBits 
]

{ #category : #accessing }
BitArray >> storage [
	^ storage
]

{ #category : #'accessing - private' }
BitArray >> storage: anObject [
	storage := anObject
]
