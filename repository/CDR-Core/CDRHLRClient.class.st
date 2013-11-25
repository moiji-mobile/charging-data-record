Class {
	#name : #CDRHLRClient,
	#superclass : #CDRClient,
	#category : #'CDR-Core'
}

{ #category : #'as yet unclassified' }
CDRHLRClient >> sendRoutingInfo: aMSISDN crn: aCrn dialogue: aDialogue [
	| record |
	record := (self createRecordFor: aDialogue)
				at: 'type' put: 'start';
				at: 'operation' put: 'sendRoutingInfo';
				at: 'msisdn' put: aMSISDN;
				at: 'callReferenceNumber' put: aCrn;
				at: 'client' put: 'hlr';
				created;
				yourself.
	^record
	
	
]

{ #category : #'as yet unclassified' }
CDRHLRClient >> sendRoutingInfo: aString smscAddr: aSmsc dialogue: aDialogue [
	| record |
	record := (self createRecordFor: aDialogue)
				at: 'type' put: 'start';
				at: 'operation' put: 'sendRoutingInfoSM';
				at: 'smsc' put: aSmsc;
				at: 'client' put: 'hlr';
				created;
				yourself.
	^record
]

{ #category : #'as yet unclassified' }
CDRHLRClient >> updateGprsLocationRequest: aSGSNNumber imsi: anIMSI dialogue: aDialogue [
	| record |
	record := (self createRecordFor: aDialogue)
				at: 'type' put: 'start';
				at: 'operation' put: 'updateGprsLocation';
				at: 'imsi' put: anIMSI;
				at: 'sgsn' put: aSGSNNumber;
				at: 'client' put: 'hlr';
				created;
				yourself.
	^record
]

{ #category : #'as yet unclassified' }
CDRHLRClient >> updateLocationRequest: aVLRGT msc: aMSCGT imsi: anIMSI dialogue: aDialogue [
	| record |
	record := (self createRecordFor: aDialogue)
				at: 'type' put: 'start';
				at: 'operation' put: 'updateLocation';
				at: 'imsi' put: anIMSI;
				at: 'msc' put: aMSCGT;
				at: 'vlr' put: aVLRGT;
				at: 'client' put: 'hlr';
				created;
				yourself.
	^record
]
