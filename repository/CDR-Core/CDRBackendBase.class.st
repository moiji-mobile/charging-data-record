Class {
	#name : #CDRBackendBase,
	#superclass : #Object,
	#category : #'CDR-Core'
}

{ #category : #'as yet unclassified' }
CDRBackendBase >> createRecordFor: aDialogue [ 
	| record |
	record := CDRRecord initWithBackend: self.
	record uniqueIdentifier: self assignUniqueIdentifier.
	^record
]

{ #category : #'as yet unclassified' }
CDRBackendBase >> recordCreated: aCDRRecord [ 
	self subclassResponsibility
]
