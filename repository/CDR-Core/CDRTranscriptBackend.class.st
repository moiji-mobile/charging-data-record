Class {
	#name : #CDRTranscriptBackend,
	#superclass : #CDRBackendBase,
	#instVars : [
		'pendingRecords',
		'lastId'
	],
	#category : #'CDR-Core'
}

{ #category : #'as yet unclassified' }
CDRTranscriptBackend >> assignUniqueIdentifier [
	^ lastId := lastId + 1
]

{ #category : #'as yet unclassified' }
CDRTranscriptBackend >> initialize [
	super initialize.
	lastId := 0.
]

{ #category : #'as yet unclassified' }
CDRTranscriptBackend >> recordCreated: aRecord [
	pendingRecords remove: aRecord.
	Transcript
		nextPutAll: ('CDR(<1s>) Time(<1p>)' expandMacrosWith: aRecord forCDR with: aRecord createdTime);
		cr.
]
