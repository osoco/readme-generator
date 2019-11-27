"
I am the command line handler for Readme Generator.

My keyword is ""readme-generator"".

Options:
  [--baseDirectory ]   A directory where files can be found (default: /data)
  [--template]         Mustache template file for README (default: README.tmpl)
  [--pomFileName]      A Maven POM file name to extract project's metadata (default: pom.xml)
  [--outputFile]       The file to output README contents (default: README)
"
Class {
	#name : #ReadmeGeneratorCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'baseDirectory'
	],
	#category : #'ReadmeGenerator-CLI'
}

{ #category : #accessing }
ReadmeGeneratorCommandLineHandler class >> commandName [
	^ 'readme-generator'
]

{ #category : #accessing }
ReadmeGeneratorCommandLineHandler class >> description [ 
^ 'Generates a README from project''s POM file and Makefile'
]

{ #category : #activation }
ReadmeGeneratorCommandLineHandler >> activate [
	| result template pomFileName |
	self activateHelp
		ifTrue: [ ^ self ].
	self
		optionAt: 'baseDirectory'
		ifPresent: [ :dir | baseDirectory := dir asFileReference ].
	template := (self baseDirectory resolve: self templateOption)
		contents.
	pomFileName := (self baseDirectory resolve: self pomFileNameOption)
		fullName.
	result := (ReadmeGenerator
		forPom: pomFileName
		usingTemplate: template
		inWorkingDirectory: self baseDirectory) generate.
   
	(self baseDirectory / self outputFileOption) writeStreamDo: [ :stream | stream nextPutAll: result].
	self exitSuccess
]

{ #category : #activation }
ReadmeGeneratorCommandLineHandler >> baseDirectory [
	^ baseDirectory ifNil: [ '/data' asFileReference ]
]

{ #category : #activation }
ReadmeGeneratorCommandLineHandler >> outputFileOption [
	^ self optionAt: 'outputFile' ifAbsent: [ 'README.md' ]
]

{ #category : #activation }
ReadmeGeneratorCommandLineHandler >> pomFileNameOption [
	^ self optionAt: 'pomFileName' ifAbsent: [ 'pom.xml' ]
]

{ #category : #activation }
ReadmeGeneratorCommandLineHandler >> templateOption [
	^ self optionAt: 'template' ifAbsent: [ 'README.tmpl' ]
]
