Class {
	#name : #PDSFunctionBoundCursorFollower,
	#superclass : #RTAbstractGrapherDecorator,
	#instVars : [
		'lineH',
		'canvas',
		'lineV',
		'labelH',
		'labelV',
		'labelXTextConvertion',
		'labelYTextConvertion',
		'color',
		'bindFunction'
	],
	#category : #'PDS-Grapher'
}

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> bindFunction: anObject [
	bindFunction := anObject
]

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> color [
	^ color
]

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> color: aColor [
	color := aColor
]

{ #category : #createLinesAndLabels }
PDSFunctionBoundCursorFollower >> createLinesAndLabelsIfNecessary [
	lineH
		ifNil: [ lineH := TRLineShape new.
			lineH color: color.
			canvas := builder view canvas.
			canvas addShape: lineH.
			lineV := TRLineShape new.
			lineV color: color.
			canvas addShape: lineV.
			labelH := TRLabelShape new.
			labelH color: color.
			canvas addShape: labelH.
			labelV := TRLabelShape new.
			labelV color: color.
			canvas addShape: labelV ]
]

{ #category : #configuration }
PDSFunctionBoundCursorFollower >> defaultColor [
	^ Color gray
]

{ #category : #drawing }
PDSFunctionBoundCursorFollower >> getLabelXValueFor: pp [
	^ (labelXTextConvertion rtValue: pp x) asString
]

{ #category : #drawing }
PDSFunctionBoundCursorFollower >> getLabelYValueFor: pp [
	^ (labelYTextConvertion rtValue: pp y) asString
]

{ #category : #drawing }
PDSFunctionBoundCursorFollower >> getPositionFromPixel: p [
	^ builder
		getPositionFromPixelPosition: p
]

{ #category : #initialization }
PDSFunctionBoundCursorFollower >> initialize [
	super initialize.
	labelXTextConvertion := [ :v | v round: 2 ].
	labelYTextConvertion := [ :v | v round: 2 ].
	color := self defaultColor
]

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> labelXTextConvertion [
	^ labelXTextConvertion
]

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> labelXTextConvertion: aOneArgBlock [
	labelXTextConvertion := aOneArgBlock
]

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> labelYTextConvertion [
	^ labelYTextConvertion
]

{ #category : #accessing }
PDSFunctionBoundCursorFollower >> labelYTextConvertion: aOneArgBlock [
	labelYTextConvertion := aOneArgBlock
]

{ #category : #createLinesAndLabels }
PDSFunctionBoundCursorFollower >> removeLinesAndLabelsIfNecessary [
	lineH notNil
		ifTrue: [ 
			lineH remove.
			lineV remove.
			labelH remove.
			labelV remove.
			self updateCanvas.
			lineH := nil.
			lineV := nil.
			labelH := nil.
			labelV := nil ]
]

{ #category : #drawing }
PDSFunctionBoundCursorFollower >> render [
	| p pp boundedPosition boundedPoint |
	builder view
		when: TRMouseMove
		do: [ :evt | 
			p := evt position.
			pp := self getPositionFromPixel: p.
			boundedPosition := pp x @ (bindFunction value: pp x).
			boundedPoint := builder getPixelPositionOf: boundedPosition.
			(self isPointOverTheBuilder: boundedPoint)
				ifTrue: [ self createLinesAndLabelsIfNecessary.
					lineH
						from: 0 @ boundedPoint y
						to: builder extent x @ boundedPoint y.
					lineV
						from: boundedPoint x @ 0
						to: boundedPoint x @ builder extent y negated.
					labelV text: (self getLabelXValueFor: boundedPosition).
					labelV translateTo: boundedPoint x @ builder extent y negated.
					labelH text: (self getLabelYValueFor: boundedPosition).
					labelH translateTo: builder extent x @ boundedPoint y.
					self updateCanvas ]
				ifFalse: [ self removeLinesAndLabelsIfNecessary ] ]
]

{ #category : #createLinesAndLabels }
PDSFunctionBoundCursorFollower >> updateCanvas [
	canvas signalUpdate
]
