Class {
	#name : #ConfigurationOfCDR,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfCDR
}

{ #category : #'development support' }
ConfigurationOfCDR class >> DevelopmentProcess [

"DEVELOPMENT Process
	- load current version:
	  	(self project version: #stable) load: 'ALL'.
	- open new version for development:
		self createNewDevelopmentVersion
	- update the the development version to match mcz file versions
		self updateToLatestPackageVersions: '- fixed bug uvw'
	- do development and periodically save mcz files and update configuration
		self saveModifiedPackages: '- fixed bug xyz'
	- do development and periodically save mcz files and configuration until ready for release
		self saveModifiedPackagesAndConfiguration: '- fixed bug xyz'
	- save configuration
		self saveConfiguration: commitMessage '- checkpoint configuration'
RELEASE Process
	- mark development version as release:
		self releaseDevelopmentVersion: 'commit comment'
	- copy configuration for general access for Squeak and Pharo:
		self copyToSqueakSource.
	- copy configuration for general access for GLASS (Dale is willing to test and release for GLASS):
		self copyToGemSource.
"
]

{ #category : #private }
ConfigurationOfCDR class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #'development support' }
ConfigurationOfCDR class >> compareVersions [
	"Compare the current #stable version to current #development version"

	"self compareVersions"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	((Smalltalk at: #MetacelloToolBox) compareVersionsIn: self) inspect

]

{ #category : #'development support' }
ConfigurationOfCDR class >> copyToGemSource [
	"Copy the current configuration mcz file to http://seaside.gemstone.com/ss/MetacelloRepository"

	"Note you before copying config to GemSource, you should have tested the release in GLASS.
	 You also need to have commit rights to the GemSource repository."

	"self copyToGemSource"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) copyConfiguration: self to: 'http://seaside.gemstone.com/ss/MetacelloRepository'
]

{ #category : #'development support' }
ConfigurationOfCDR class >> copyToSqueakSource [
	"Copy the current configuration mcz file to http://www.squeaksource.com/MetacelloRepository"

	"self copyToSqueakSource"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) copyConfiguration: self to: 'http://www.squeaksource.com/MetacelloRepository'
]

{ #category : #'development support' }
ConfigurationOfCDR class >> createNewBaselineVersion [
	"Create a new baseline version based upon #stable version's baseline.
	 A new baseline should be created if new packages have been added or package dependencies have changed."

	"self createNewDevelopmentVersion"
	
	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) createNewBaselineVersionIn: self description: ''

]

{ #category : #'development support' }
ConfigurationOfCDR class >> createNewDevelopmentVersion [
	"Create a new development version using the #stable version as model."

	"self createNewDevelopmentVersion"
	
	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) createNewDevelopmentVersionIn: self description: ''
]

{ #category : #private }
ConfigurationOfCDR class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), load latest mcz file for ConfigurationOfMetacello (using old 
	 Gofer API), then load the latest version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [ | error |
		"list of repositories to try, in case primary repository is not accessible"
		(Array 
			with: 'http://www.squeaksource.com/MetacelloRepository' 
			with: 'http://seaside.gemstone.com/ss/metacello') do: [:repositoryUrl |
				([
					Smalltalk at: #Gofer ifAbsent: [
						"Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
						self bootstrapPackage: 'Gofer-Core-lr.115' from: repositoryUrl ].
					Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
						gofer := goferClass new
							url: repositoryUrl;
							yourself.
						[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
						gofer load ]]
							on: Error
							do: [ :ex |
								error := ex.
								Transcript 
									cr; 
									show: 'failed ensureMetacello: ';
									show: ex description printString;
									show: '...retrying'.
								"try again"
								ex return: nil ]) ~~ nil
					ifTrue: [
						"load 'default' group of Metacello"
						(Smalltalk at: #ConfigurationOfMetacello) perform: #load.
						^self ]].
		"shouldn't get here unless the load failed ... throw an error"
		self error: 'retry with alternate repository failed: ', error description printString ]
]

{ #category : #'metacello tool support' }
ConfigurationOfCDR class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfCDR class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #loading }
ConfigurationOfCDR class >> loadBleedingEdge [
	^ (self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfCDR class >> loadDevelopment [
	^ (self project version: #development) load
]

{ #category : #'metacello tool support' }
ConfigurationOfCDR class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfCDR class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfCDR class >> releaseDevelopmentVersion: commitMessage [
	"Release #development version (set version blessing to #release), update the #development and #stable symbolic versions and save the configuration."

	"self releaseDevelopmentVersion: '- release version 1.0.2'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) releaseDevelopmentVersionIn: self description: commitMessage
]

{ #category : #'development support' }
ConfigurationOfCDR class >> saveConfiguration: commitMessage [
	"Save the configuration."

	"self saveConfiguration: '- fixed bug'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) saveConfigurationPackageFor: self name asString description: commitMessage
]

{ #category : #'development support' }
ConfigurationOfCDR class >> saveModifiedPackages: commitMessage [
	"Save modified mcz files and update the configuration."

	"self saveModifiedPackages: '- fixed bug'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) saveModifiedPackagesIn: self description:  commitMessage
]

{ #category : #'development support' }
ConfigurationOfCDR class >> saveModifiedPackagesAndConfiguration: commitMessage [
	"Save modified mcz files, update and then save the configuration."

	"self saveModifiedPackagesAndConfiguration: '- fixed bug'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) saveModifiedPackagesAndConfigurationIn: self description: commitMessage
]

{ #category : #loading }
ConfigurationOfCDR class >> update [
	self project updateProject.
	self loadDevelopment
]

{ #category : #'development support' }
ConfigurationOfCDR class >> updateToLatestPackageVersions: descriptionString [
	"Updates mcz file versions in current version"

	"self updateToLatestPackageVersions: '- latest mcz files for 1.0.4'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	((Smalltalk at: #MetacelloToolBox) updateToLatestPackageVersionsIn: self description: descriptionString) isEmpty
		ifTrue: [ self inform: 'All specs up to date' ]
]

{ #category : #'development support' }
ConfigurationOfCDR class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."
	
	"self validate"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #'as yet unclassified' }
ConfigurationOfCDR >> baseline01: spec [ 
        <version: '0.1-baseline'>
        
	spec for: #common do: [
		spec blessing: #baseline.
                spec repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main'.    
                spec 
				package: 'CDR-Core';
				package: 'CDR-HTTP' with: [ spec requires: #('CDR-Core' 'Neo JSON' )].
				
			spec
				project: 'Phexample' with: [
					spec
						className: 'ConfigurationOfPhexample';
						versionString: '1.2';
						repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].	
						
			spec project: 'Neo JSON' with: [
				spec
					className: 'ConfigurationOfNeoJSON';
					versionString: #'stable';
					repository: 'http://mc.stfx.eu/Neo' ].
                spec
				group: 'default' with: #('CDR-Core' 'CDR-HTTP') ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfCDR >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '0.22'.

]

{ #category : #'as yet unclassified' }
ConfigurationOfCDR >> project [

	^ project ifNil: [ | projectAttributes |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		project := (Smalltalk at: #MetacelloMCProject) new.
		projectAttributes := #().
		Smalltalk at: #SystemVersion ifPresent: [:cl | | versionString |
			versionString := cl current version.
			((versionString beginsWith: 'Pharo-1.0') or: [versionString beginsWith: 'PharoCore1.0'])
				ifTrue: [ projectAttributes := projectAttributes, #(#'GreaseForPharo1.0') ] ].
		project projectAttributes:  projectAttributes.
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear ]
]

{ #category : #'as yet unclassified' }
ConfigurationOfCDR >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '0.1'.

]

{ #category : #versions }
ConfigurationOfCDR >> version01: spec [
	<version: '0.1' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '0.1 : new config for CDR'.
		spec author: 'NorbertHartl'.
		spec timestamp: '12/10/2013 14:18'.
		spec project: 'Phexample' with: '1.2'.
		spec 
			package: 'CDR-Core' with: 'CDR-Core-HolgerHansPeterFreyther.10';
			package: 'CDR-HTTP' with: 'CDR-HTTP-HolgerHansPeterFreyther.1'. ].

]

{ #category : #versions }
ConfigurationOfCDR >> version021: spec [
	<version: '0.21' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '0.2 : added neoJSON as dependency
0.21 : added neo json as dependency to CDR-HTTP'.
		spec author: 'NorbertHartl'.
		spec timestamp: '12/10/2013 14:30'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'Neo JSON' with: #'stable'.
		spec 
			package: 'CDR-Core' with: 'CDR-Core-HolgerHansPeterFreyther.10';
			package: 'CDR-HTTP' with: 'CDR-HTTP-HolgerHansPeterFreyther.1'. ].

]

{ #category : #versions }
ConfigurationOfCDR >> version022: spec [
	<version: '0.22' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '0.21 : added neo json as dependency to CDR-HTTP'.
		spec author: 'NorbertHartl'.
		spec timestamp: '12/10/2013 14:30'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'Neo JSON' with: #'stable'.
		spec 
			package: 'CDR-Core' with: 'CDR-Core-HolgerHansPeterFreyther.10';
			package: 'CDR-HTTP' with: 'CDR-HTTP-HolgerHansPeterFreyther.1'. ].

]

{ #category : #versions }
ConfigurationOfCDR >> version02: spec [
	<version: '0.2' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '0.1 : new config for CDR
0.2 : added neoJSON as dependency'.
		spec author: 'NorbertHartl'.
		spec timestamp: '12/10/2013 14:25'.
		spec project: 'Phexample' with: '1.2'.
		spec 
			package: 'CDR-Core' with: 'CDR-Core-HolgerHansPeterFreyther.10';
			package: 'CDR-HTTP' with: 'CDR-HTTP-HolgerHansPeterFreyther.1'. ].

]
