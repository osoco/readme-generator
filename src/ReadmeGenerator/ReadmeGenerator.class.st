Class {
	#name : #ReadmeGenerator,
	#superclass : #Object,
	#instVars : [
		'pom',
		'template'
	],
	#category : #'ReadmeGenerator-Core'
}

{ #category : #building }
ReadmeGenerator class >> forPom: pomFileName usingTemplate: mustacheTemplateContents [
	^ self new
		pom: pomFileName;
		template: mustacheTemplateContents;
		yourself
]

{ #category : #building }
ReadmeGenerator class >> forPom: pomFileName usingTemplateFileNamed: mustacheTemplateFileName [
	^ self
		forPom: pomFileName
		usingTemplate: mustacheTemplateFileName asFileReference contents
]

{ #category : #generating }
ReadmeGenerator >> generate [
	"Generate the README contents using a Mustache template and project metadata from POM file"

	| pomDoc name description effectivePomDoc moduleDescriptions modules developers contributors scmUrl ciUrl issueUrl pomMetadata context |
	self
		generateEffectivePomFileAndThen: [ :effectivePomFileName | 
			pomDoc := XMLDOMParser parseFileNamed: self pom.
			name := (XPath for: 'project/name' in: pomDoc) stringValue.
			description := (XPath for: 'project/description' in: pomDoc)
				stringValue.
			effectivePomDoc := XMLDOMParser parseFileNamed: effectivePomFileName.
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
					('role' -> (XPath for: 'roles/role' in: node) stringValue)}
						asDictionary ].
			scmUrl := (XPath for: 'project/scm/url' in: pomDoc) stringValue.
			ciUrl := (XPath for: 'project/ciManagement/url' in: pomDoc)
				stringValue.
			issueUrl := (XPath for: 'project/issueManagement/url' in: pomDoc)
				stringValue.
			pomMetadata := {('name' -> name).
			('description' -> description).
			('developers' -> developers).
			('contributors' -> contributors).
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
						arguments: {wrapped value};
						redirectStdout;
						runAndWaitOnExitDo: [ :process :outString | makeOutput := outString ].
					makeOutput ])} asDictionary.
			^ self template asMustacheTemplate value: context ]
]

{ #category : #'private - generating' }
ReadmeGenerator >> generateEffectivePomFileAndThen: aBlock [
	OSSUnixSubprocess new
		command: '/run/current-system/sw/bin/mvn';
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
