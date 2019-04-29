Class {
	#name : #PDSRoassalViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'label',
		'visualization',
		'roassalScript',
		'labelText'
	],
	#category : #'PDS-Playground-Widgets'
}

{ #category : #specs }
PDSRoassalViewer class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #label ] height: self labelHeight;
		newRow: [ :row | row add: #visualization ];
		yourself
]

{ #category : #api }
PDSRoassalViewer >> extent [
	^ 400 @ 400
]

{ #category : #initialization }
PDSRoassalViewer >> initializeWidgets [
	label := self newLabel.
	visualization := self instantiate: RoassalModel.
	label
		label: 'Roassal Visualization';
		emphasis:  #bold.
	visualization script: [ :view :canvas |  ].
	self focusOrder add: visualization
]

{ #category : #accessing }
PDSRoassalViewer >> label [
	^ label
]

{ #category : #api }
PDSRoassalViewer >> labelText: anObject [
	label label: anObject.
]

{ #category : #api }
PDSRoassalViewer >> refresh [
	visualization refresh
]

{ #category : #api }
PDSRoassalViewer >> roassalScript: anObject [
	visualization script: anObject.
]

{ #category : #api }
PDSRoassalViewer >> title [ 
^ 'Bloom Filter Bits'
]

{ #category : #accessing }
PDSRoassalViewer >> visualization [
	^ visualization
]
