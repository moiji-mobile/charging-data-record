"
A CDRHTTPBackendTest is a test class for testing the behavior of CDRHTTPBackend
"
Class {
	#name : #CDRHTTPBackendTest,
	#superclass : #TestCase,
	#category : #'CDR-HTTP-Tests'
}

{ #category : #'as yet unclassified' }
CDRHTTPBackendTest >> testJsonConversion [
	| records json |
	records := OrderedCollection new.
	records
		add: CDRRecord new;
		add: CDRRecord new;
		add: CDRRecord new.

	json := CDRHTTPBackend convertToJson: records.
	self assert: json equals: '[{"state":"initial"},{"state":"initial"},{"state":"initial"}]'.
]

{ #category : #'as yet unclassified' }
CDRHTTPBackendTest >> testSwapPendingRecords [
	| backend pending extracted |
	backend := CDRHTTPBackend new.
	pending := backend instVarNamed: #pendingRecords.

	self assert: pending size equals: 0.
	pending
		add: 1;
		add: 2;
		add: 3.
	extracted := backend swapPendingRecords: OrderedCollection new.
	self assert: extracted == pending.
	
	pending := backend instVarNamed: #pendingRecords.
	pending
		add: 4;
		add: 5.

	backend prependRecords: extracted.
	self assert: pending size equals: 5.

	1 to: 5 do: [:each |
		self assert: (pending at: each) equals: each].
]
