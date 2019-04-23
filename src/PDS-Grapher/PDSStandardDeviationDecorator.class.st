Class {
	#name : #PDSStandardDeviationDecorator,
	#superclass : #RTAbstractGrapherDecorator,
	#instVars : [
		'color',
		'points'
	],
	#category : #'PDS-Grapher'
}

{ #category : #accessing }
PDSStandardDeviationDecorator >> color [
	^ color
]

{ #category : #accessing }
PDSStandardDeviationDecorator >> color: aColor [
	color := aColor.
]

{ #category : #initialization }
PDSStandardDeviationDecorator >> initialize [
	super initialize.
	self color: (Color gray alpha: 0.5).
]

{ #category : #accessing }
PDSStandardDeviationDecorator >> points [
	^ points
]

{ #category : #accessing }
PDSStandardDeviationDecorator >> points: pts [
	points := pts
]

{ #category : #drawing }
PDSStandardDeviationDecorator >> render [
	| dev svg k str index pointsByAbscissa |
	pointsByAbscissa := points groupedBy: #x.
	dev := (pointsByAbscissa
		collect: [ :data | (data collect: #y) average + (data collect: #y) stdev ]) values.
	svg := TRSVGPath new.
	svg color: color.
	k := builder getPixelPositionOf: pointsByAbscissa keys first @ dev first.
	str := 'M' , k x asString , ' ' , k y asString.
	(2 to: dev size)
		do: [ :i | 
			| x y |
			x := pointsByAbscissa keys at: i.
			y := dev at: i.
			k := builder getPixelPositionOf: x @ y.
			str := str , 'L' , k x asString , ' ' , k y asString ].
	dev := dev := (pointsByAbscissa
		collect: [ :data | (data collect: #y) average - (data collect: #y) stdev ]) values.
	(1 to: dev size)
		do: [ :i | 
			| x y |
			index := dev size - i + 1.
			x := pointsByAbscissa keys at: index.
			y := dev at: index.
			k := builder getPixelPositionOf: x @ y.
			str := str , 'L' , k x asString , ' ' , k y asString ].
	str := str , 'Z'.
	svg path: str.
	builder view canvas addShape: svg
]
