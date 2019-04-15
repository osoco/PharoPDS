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
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #label ] height: self labelHeight;
		newRow: [ :row | row add: #visualization ];
		yourself
]

{ #category : #api }
RoassalViewer >> extent [
	^ 400 @ 400
]

{ #category : #initialization }
RoassalViewer >> initializeWidgets [
	label := self newLabel.
	visualization := self instantiate: RoassalModel.
	label
		label: 'Roassal Visualization';
		emphasis:  #bold.
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
