"
I am responsible for passing CallDataRecord (CDR) to somewhere else.
"
Class {
	#name : #CDRClient,
	#superclass : #Object,
	#instVars : [
		'backend'
	],
	#category : #'CDR-Core'
}

{ #category : #'as yet unclassified' }
CDRClient >> backend [
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
CDRClient >> createRecordFor: aDialogue [ 
	^self backend createRecordFor: aDialogue
]
