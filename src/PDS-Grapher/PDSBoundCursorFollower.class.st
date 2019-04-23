Class {
	#name : #PDSBoundCursorFollower,
	#superclass : #RTCursorFollower,
	#instVars : [
		'bindFunction'
	],
	#category : #'PDS-Grapher'
}

{ #category : #accessing }
PDSBoundCursorFollower >> bindFunction: anObject [
	bindFunction := anObject
]

{ #category : #drawing }
PDSBoundCursorFollower >> getLabelYValueFor: pp [
	^ (labelYTextConvertion rtValue: pp y) asString
]

{ #category : #drawing }
PDSBoundCursorFollower >> getPositionFromPixel: p [
	^ builder getPositionFromPixelPosition: p
]

{ #category : #accessing }
PDSBoundCursorFollower >> render [
	| p pp boundedPosition boundedPoint |
	builder view
		when: TRMouseMove
		do: [ :evt | 
			p := evt position.
			pp := self getPositionFromPixel: p.
			bindFunction isNil ifTrue: [ 
				boundedPoint := p.
				boundedPosition := pp.
				 ] ifFalse: [ 
			boundedPosition := pp x @ (bindFunction value: pp x).
			boundedPoint := builder getPixelPositionOf: boundedPosition.
			].
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
