Class {
	#name : #RoassalViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'label',
		'visualization',
		'roassalScript',
		'labelText'
	],
	#category : #'PDS-Membership-Playground'
}

{ #category : #specs }
RoassalViewer class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | row add: #label ] origin: 0 @ 0 corner: 1 @ 0.1;
		newRow: [ :row | row add: #visualization ] origin: 0 @ 0.1 corner: 1 @ 1;
		yourself
]

{ #category : #api }
RoassalViewer >> extent [ 
^ 600@400
]

{ #category : #initialization }
RoassalViewer >> initializeWidgets [
	label := self newLabel.
	visualization := self instantiate: RoassalModel.
	label label: 'Roassal Visualization'.
	visualization script: [ :view :canvas |  ].
	self focusOrder add: visualization
]

{ #category : #accessing }
RoassalViewer >> label [
	^ label
]

{ #category : #api }
RoassalViewer >> labelText: anObject [
	label label: anObject.
]

{ #category : #api }
RoassalViewer >> refresh [
	visualization refresh
]

{ #category : #api }
RoassalViewer >> roassalScript: anObject [
	visualization script: anObject.
]

{ #category : #api }
RoassalViewer >> title [ 
^ 'Bloom Filter Bits'
]

{ #category : #accessing }
RoassalViewer >> visualization [
	^ visualization
]
