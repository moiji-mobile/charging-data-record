Class {
	#name : #CDRDummyBackend,
	#superclass : #CDRBackendBase,
	#instVars : [
		'lastId'
	],
	#category : #'CDR-Core'
}

{ #category : #'as yet unclassified' }
CDRDummyBackend >> assignUniqueIdentifier [
	^ lastId := lastId + 1
]

{ #category : #'as yet unclassified' }
CDRDummyBackend >> initialize [
	super initialize.
	lastId := 0.
]

{ #category : #'as yet unclassified' }
CDRDummyBackend >> recordCreated: aRecord [
]
