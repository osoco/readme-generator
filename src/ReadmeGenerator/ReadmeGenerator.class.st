"
I am a README generator for software projects based on Maven and/or Makefiles.

I generates a README file using a Mustache template and project's metadata fetched
from sources of truth like Maven POM file and/or Makefiles.

Usage:

(ReadmeGenerator forPom: 'pom.xml' usingTemplateFileNamed: 'README.tmpl') generate.
"
Class {
	#name : #ReadmeGenerator,
	#superclass : #Object,
	#instVars : [
		'pom',
		'template',
		'workingDirectory'
	],
	#category : #'ReadmeGenerator-Core'
}

{ #category : #building }
ReadmeGenerator class >> forPom: pomFileName usingTemplate: mustacheTemplateContents inWorkingDirectory: aWorkingDirectory [
	^ self new
		pom: pomFileName;
		template: mustacheTemplateContents;
		workingDirectory: aWorkingDirectory;
		yourself
]

{ #category : #building }
ReadmeGenerator class >> forPom: pomFileName usingTemplateFileNamed: mustacheTemplateFileName inWorkingDirectory: aWorkingDirectory [
	^ self
		forPom: pomFileName
		usingTemplate: mustacheTemplateFileName asFileReference contents
		inWorkingDirectory: aWorkingDirectory 
]

{ #category : #generating }
ReadmeGenerator >> generate [
	"Generate the README contents using a Mustache template and project metadata from POM file"

	| pomDoc name description effectivePomDoc moduleDescriptions modules developers contributors scmUrl ciUrl issueUrl pomMetadata context licenses |
	self
		generateEffectivePomFileAndThen: [ :effectivePomFileName | 
			pomDoc := XMLDOMParser parseFileNamed: self pom.
			name := (XPath for: 'project/name' in: pomDoc) stringValue.
			description := (XPath for: 'project/description' in: pomDoc)
				stringValue.
			effectivePomDoc := XMLDOMParser
				parseFileNamed: (self workingDirectory / effectivePomFileName) fullName.
			moduleDescriptions := ((XPath
				for: 'projects/project'
				in: effectivePomDoc)
				collect: [ :projectNode | 
					(XPath for: 'artifactId' in: projectNode) stringValue
						-> (XPath for: 'description' in: projectNode) stringValue ]
				as: OrderedCollection) asDictionary.
			modules := (XPath for: 'project/modules/module' in: pomDoc)
				collect: [ :moduleNode | 
					{('name' -> moduleNode stringValue).
					('description' -> (moduleDescriptions at: moduleNode stringValue))}
						asDictionary ].
			developers := (XPath for: 'project/developers/developer' in: pomDoc)
				collect: [ :node | 
					{('name' -> (node elementAt: 'name') stringValue).
					('email' -> (node elementAt: 'email') stringValue).
					('organization' -> (node elementAt: 'organization') stringValue).
					('url' -> (node elementAt: 'url') stringValue).
					('picUrl'
						-> (XPath for: 'properties/picUrl' in: node) stringValue).
					('role' -> (XPath for: 'roles/role' in: node) stringValue)}
						asDictionary ].
			contributors := (XPath
				for: 'project/contributors/contributor'
				in: pomDoc)
				collect: [ :node | 
					{('name' -> (node elementAt: 'name') stringValue).
					('email' -> (node elementAt: 'email') stringValue).
					('organization' -> (node elementAt: 'organization') stringValue).
					('url' -> (node elementAt: 'url') stringValue).
					('picUrl'
						-> (XPath for: 'properties/picUrl' in: node) stringValue).
					('role' -> (XPath for: 'roles/role' in: node) stringValue)}
						asDictionary ].
			licenses := (XPath for: 'project/licenses/license' in: pomDoc)
				collect:
					[ :node | {('name' -> (node elementAt: 'name') stringValue)} asDictionary ].
			scmUrl := (XPath for: 'project/scm/url' in: pomDoc) stringValue.
			ciUrl := (XPath for: 'project/ciManagement/url' in: pomDoc)
				stringValue.
			issueUrl := (XPath for: 'project/issueManagement/url' in: pomDoc)
				stringValue.
			pomMetadata := {('name' -> name).
			('description' -> description).
			('developers' -> developers).
			('contributors' -> contributors).
			('licenses' -> licenses).
			('scm' -> {('url' -> scmUrl)} asDictionary).
			('ciManagement' -> {('url' -> ciUrl)} asDictionary).
			('issueManagement' -> {('url' -> issueUrl)} asDictionary).
			('modules' -> modules)} asDictionary.
			context := {('pomMetadata' -> pomMetadata).
			('makefile'
				-> [ :wrapped | 
					| makeOutput |
					OSSUnixSubprocess new
						command: 'make';
						workingDirectory: self workingDirectory fullName;
						arguments: {wrapped value};
						redirectStdout;
						runAndWaitOnExitDo: [ :process :outString | makeOutput := outString ].
					makeOutput ])} asDictionary.
			^ self template asMustacheTemplate value: context ]
]

{ #category : #'private - generating' }
ReadmeGenerator >> generateEffectivePomFileAndThen: aBlock [
	OSSUnixSubprocess new
		command: 'mvn';
		workingDirectory: self workingDirectory fullName;
		arguments: #('help:effective-pom' '-Doutput=effective-pom.xml');
		runAndWaitOnExitDo: [ :process :outString | aBlock value: 'effective-pom.xml' ]
]

{ #category : #accessing }
ReadmeGenerator >> pom [
	^ pom
]

{ #category : #accessing }
ReadmeGenerator >> pom: anObject [
	pom := anObject
]

{ #category : #accessing }
ReadmeGenerator >> template [
	^ template
]

{ #category : #accessing }
ReadmeGenerator >> template: anObject [
	template := anObject
]

{ #category : #accessing }
ReadmeGenerator >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
ReadmeGenerator >> workingDirectory: anObject [
	workingDirectory := anObject
]
