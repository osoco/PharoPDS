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
		icon: self tutorialIcon;
		withSeparatorAfter
]

{ #category : #icons }
PDSWorldMenu class >> browserIcon [
	^ PDSIcons flaskIcon scaledToSize: 24 @ 24
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
		icon: self browserIcon
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
		help: 'Open PDS Documentation';
		icon: self tutorialIcon
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
PDSWorldMenu class >> pds [
	^ PDSIcons rocketIcon scaledToSize: 24@24
]

{ #category : #'world menu' }
PDSWorldMenu class >> rootMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #pdsMenu)
		label: 'P11c Data Structures';
		icon: self pds ;
		order: 100
]

{ #category : #icons }
PDSWorldMenu class >> tutorialIcon [
	^ PDSIcons mortarboardIcon scaledToSize: 24 @ 24
]
