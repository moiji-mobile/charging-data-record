Class {
	#name : #CDRBackendBase,
	#superclass : #Object,
	#instVars : [
		'pendingRecords'
	],
	#category : #'CDR-Core'
}

{ #category : #'as yet unclassified' }
CDRBackendBase >> addRecordFor: aDialogue [ 
	| record |
	record := CDRRecord initWithBackend: self.
	record uniqueIdentifier: self assignUniqueIdentifier.
	pendingRecords add: record.
	^record
]

{ #category : #'as yet unclassified' }
CDRBackendBase >> initialize [
	super initialize.
	pendingRecords := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
CDRBackendBase >> recordCreated: aCDRRecord [ 
	self subclassResponsibility
]
