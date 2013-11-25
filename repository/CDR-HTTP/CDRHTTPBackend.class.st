"
I collect traces and then will upload them using HTTP.
"
Class {
	#name : #CDRHTTPBackend,
	#superclass : #CDRBackendBase,
	#instVars : [
		'host',
		'port',
		'uploadTimer',
		'recordsSemaphore',
		'uploadUrl',
		'pendingRecords'
	],
	#category : #'CDR-HTTP'
}

{ #category : #'as yet unclassified' }
CDRHTTPBackend class >> convertToJson: aRecordList [
	^NeoJSONWriter toString: (aRecordList collect: [:record | record content]).
]

{ #category : #'as yet unclassified' }
CDRHTTPBackend >> assignUniqueIdentifier [
	^UUID new asString
]

{ #category : #'as yet unclassified' }
CDRHTTPBackend >> handleUpload: aJson records: recordList [
	| res |
	
	res := ZnEasy put: uploadUrl data: (ZnStringEntity with: aJson type: 'application/json').
	res status = 201
		ifFalse: [
			Transcript nextPutAll: ('The upload has returned <1p> assuming it failed' expandMacrosWith: res status); cr.
			self prependRecords: recordList]
]

{ #category : #'as yet unclassified' }
CDRHTTPBackend >> initialize [
	super initialize.
	uploadUrl := 'http://localhost/cdr'.
	recordsSemaphore := Semaphore forMutualExclusion.
	pendingRecords := OrderedCollection new.
]

{ #category : #configuration }
CDRHTTPBackend >> maxPendingRecords [
	"When to upload more early?"
	^1000
]

{ #category : #upload }
CDRHTTPBackend >> prependRecords: aList [
	recordsSemaphore critical: [
			pendingRecords addAllFirst: aList].
]

{ #category : #'as yet unclassified' }
CDRHTTPBackend >> recordCreated: aRecord [
	uploadTimer ifNil: [
		uploadTimer := TimerScheduler instance scheduleInSeconds: self timeout block: [self uploadRecords]].

	recordsSemaphore critical: [pendingRecords add: aRecord].

	pendingRecords size > self maxPendingRecords
		ifTrue: [self uploadRecords].
]

{ #category : #upload }
CDRHTTPBackend >> swapPendingRecords: newCollection [
	^recordsSemaphore critical: [
		| tmp |
		tmp := pendingRecords.
		pendingRecords := newCollection.
		tmp].
]

{ #category : #configuration }
CDRHTTPBackend >> timeout [
	"Upload logs every sixty seconds"
	^60
]

{ #category : #'as yet unclassified' }
CDRHTTPBackend >> uploadRecords [
	uploadTimer ifNotNil: [:timeout | timeout cancel].
	uploadTimer := nil.

	[ | records |
	[
		| json |
		"Copy out the old entries"
		records := self swapPendingRecords: OrderedCollection new.
		json := self class convertToJson: records.
		self handleUpload: json records: records.
	] on: Error do: [:e |
		"Re-add"
		Transcript nextPutAll: 'Something wrong with JSON/Upload. Going to re-add the records'; cr; flush.
		records ifNotNil: [self prependRecords: records]
	]] fork.
]
