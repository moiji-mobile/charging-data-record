Class {
	#name : #CDRRecord,
	#superclass : #Object,
	#instVars : [
		'backend',
		'dictionary'
	],
	#category : #'CDR-Core'
}

{ #category : #creation }
CDRRecord class >> initWithBackend: aBackend [
	^self new
		backend: aBackend;
		yourself
]

{ #category : #information }
CDRRecord >> at: aKey [
	^dictionary at: aKey
]

{ #category : #information }
CDRRecord >> at: aKey put: aValue [
	dictionary at: aKey put: aValue
]

{ #category : #creation }
CDRRecord >> backend: aBackend [
	backend := aBackend
]

{ #category : #'as yet unclassified' }
CDRRecord >> created [
	self
		at: 'state' put: 'created';
		at: 'createdTime' put: DateAndTime now.
	backend recordCreated: self.
]

{ #category : #'as yet unclassified' }
CDRRecord >> createdTime [
	^self at: 'createdTime'
]

{ #category : #'as yet unclassified' }
CDRRecord >> forCDR [
	^self at: 'identifier'
]

{ #category : #'as yet unclassified' }
CDRRecord >> initialize [
	super initialize.
	dictionary := Dictionary new.
	self at: 'state' put: 'initial'.
]

{ #category : #creation }
CDRRecord >> uniqueIdentifier: anIdentifier [
	self at: 'identifier' put: anIdentifier
]
