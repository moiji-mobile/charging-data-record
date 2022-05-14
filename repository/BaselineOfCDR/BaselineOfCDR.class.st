Class {
	#name : #BaselineOfCDR,
	#superclass : #BaselineOf,
	#category : #BaselineOfCDR
}

{ #category : #baselines }
BaselineOfCDR >> baseline: spec [
   <baseline>

	spec baseline: 'OsmoCore' with: [
		spec
			repository: 'github://moiji-mobile/osmocom-core:v9/source'].
	spec baseline: 'NeoJSON' with: [
		spec
			repository: 'github://svenvc/NeoJSON/repository' ].
		
	spec package: #'CDR-Core'.
	spec package: #'CDR-HTTP' with: [
		spec requires: #( #OsmoCore #NeoJSON ).
	].
	
]
