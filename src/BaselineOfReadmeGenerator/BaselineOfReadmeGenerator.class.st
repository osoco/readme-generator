Class {
	#name : #BaselineOfReadmeGenerator,
	#superclass : #BaselineOf,
	#category : #BaselineOfReadmeGenerator
}

{ #category : #baselines }
BaselineOfReadmeGenerator >> baseline: spec [
	<baseline>
	self ossubprocess: spec.
	self xpath: spec.
	self mustache: spec.
	spec
		for: #(common)
		do: [ spec
				package: 'ReadmeGenerator'
				with: [ spec requires: #('OSSubprocess' 'XPath' 'Mustache') ].
			spec group: 'default' with: #('ReadmeGenerator') ]
]

{ #category : #baselines }
BaselineOfReadmeGenerator >> mustache: spec [
	spec
		baseline: 'Mustache'
		with: [ spec repository: 'github://noha/mustache/repository' ]
]

{ #category : #baselines }
BaselineOfReadmeGenerator >> ossubprocess: spec [
	spec 
		baseline: 'OSSubprocess' 
		with: [ 
			spec
				repository: 'github://pharo-contributions/OSSubprocess:master/repository' ].
]

{ #category : #baselines }
BaselineOfReadmeGenerator >> xpath: spec [
	spec
		baseline: 'XPath'
		with: [ spec
				repository: 'github://pharo-contributions/XML-XPath/src' ]
]
