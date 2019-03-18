Extension { #name : #Integer }

{ #category : #'*PDS-Hash' }
Integer >> <-<- shiftAmount [
	"rotate left shift"

	^ self bitRotationShift: shiftAmount
]

{ #category : #'*PDS-Hash' }
Integer >> bitRotationShift: shiftCount [
    ^ BinaryOperations leftRotate: self by: shiftCount  
]
