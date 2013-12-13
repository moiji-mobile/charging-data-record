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
	^backend
]

{ #category : #'as yet unclassified' }
CDRClient >> backend: aBackend [
	backend := aBackend
]

{ #category : #'as yet unclassified' }
CDRClient >> createRecordFor: aDialogue [ 
	^self backend createRecordFor: aDialogue
]

{ #category : #'as yet unclassified' }
CDRClient >> initialize [
	super initialize.
	backend := CDRDummyBackend new.
]
