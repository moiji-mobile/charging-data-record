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
CDRClient >> addRecordFor: aDialogue [ 
	^self backend addRecordFor: aDialogue
]

{ #category : #'as yet unclassified' }
CDRClient >> backend [
	self shouldBeImplemented.
]
