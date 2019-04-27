Class {
	#name : #PDSWorldMenu,
	#superclass : #Object,
	#category : #'PDS-Core-World Menu'
}

{ #category : #'world menu' }
PDSWorldMenu class >> bloomFilterTutorialMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #pdsBloomFilterTutorialMenu)
		parent: #pdsMenu;
		label: 'Bloom Filter tutorial';
		target: self;
		selector: #openBloomFilterTutorial;
		order: 2;
		help: 'Open Bloom Filter interactive tutorial';
		withSeparatorAfter
]

{ #category : #'world menu' }
PDSWorldMenu class >> browserMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #pdsBrowserMenu)
		parent: #pdsMenu;
		label: 'Algorithms Browser';
		target: self;
		selector: #openBrowser;
		order: 10;
		help: 'Open the PDS Algorithms Browser';
		icon: (Smalltalk ui icons iconNamed: #glamorousGo)
]

{ #category : #'world menu' }
PDSWorldMenu class >> documentationMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #pdsDocumentationMenu)
		parent: #pdsMenu;
		label: 'Interactive documentation';
		target: self;
		selector: #openPDSDocumentation;
		order: 1;
		help: 'Open PDS Documentation'
]

{ #category : #'api - actions' }
PDSWorldMenu class >> openBloomFilterTutorial [
	GtInspector
		openOnPlayBook: (GtDocument forClass: PDSBloomFilter )
]

{ #category : #'api - actions' }
PDSWorldMenu class >> openBrowser [ 
PDSAlgorithmBrowser open
]

{ #category : #'api - actions' }
PDSWorldMenu class >> openPDSDocumentation [
	GtInspector openOnPlayBook: (GtDocument forClass: BaselineOfProbabilisticDataStructures )
]

{ #category : #icons }
PDSWorldMenu class >> pdsIcon [
^ (Form
	extent: (16@16)
	depth: 32
	fromArray: #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 111848106 2425590675 4019360402 4019360402 2425590675 111848106 0 0 0 0 0 0 0 0 0 0 2425590675 4287795858 4287795858 4287795858 4287795858 2425590675 0 0 0 0 0 0 0 0 0 0 4019360402 4287795858 4287795858 4287795858 4287795858 4019360402 0 0 0 0 0 0 0 0 0 0 4019360402 4287795858 4287795858 4287795858 4287795858 4019360402 0 0 0 0 0 0 0 0 0 0 2425590675 4287795858 4287795858 4287795858 4287795858 2425590675 0 0 0 0 0 0 0 0 0 0 111848106 2425590675 4019360402 4019360402 2425590675 111848106 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	offset: (0@0))
]

{ #category : #'world menu' }
PDSWorldMenu class >> rootMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #pdsMenu)
		label: 'P11c Data Structures';
		icon: (Smalltalk ui icons iconNamed: #smallObjects);
		order: 100
]
