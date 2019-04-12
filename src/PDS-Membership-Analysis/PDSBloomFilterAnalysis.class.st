Class {
	#name : #PDSBloomFilterAnalysis,
	#superclass : #Object,
	#category : #'PDS-Membership-Analysis'
}

{ #category : #'instance creation' }
PDSBloomFilterAnalysis class >> open [
	<script: 'self open'>
	self new analyzeFalsePositiveProbability inspectWithLabel: 'Bloom Filter False Positive Analysis'
]

{ #category : #examples }
PDSBloomFilterAnalysis >> analyzeFalsePositiveProbability [
	" 
    PDSBloomFilterAnalysis new analyzeFalsePositiveProbability
	"
	| fpp ds1 g p ds s ns targetElements dec bloom fp points targetFpp numberExperiments startingValue stepValue averagePoints averageDs |
	targetElements := 100.
	targetFpp := 0.03.
	numberExperiments := 10.
	startingValue := 10.
	stepValue := 10.
	points := OrderedCollection new.
	averagePoints := OrderedCollection new.
	startingValue to: targetElements * 1.5 by: stepValue do: [ :numElements | 
		| averageValue |
		averageValue := 0.
		numberExperiments
			timesRepeat: [ bloom := BloomFilter new: targetElements fpp: targetFpp.
				s := (1 to: numElements)
					collect: [ :each | each asString , '-' , each atRandom asString , '@osoco.es' ].
				ns := (1 to: numElements)
					collect:
						[ :each | each asString , '-' , each atRandom asString , '@noosoco.es' ].
				s do: [ :each | bloom add: each asByteArray ].
				fp := ns count: [ :each | bloom contains: each asByteArray ].
				points add: numElements @ (fp / ns size) asFloat.
				averageValue := averageValue
					+ ((fp / ns size) asFloat / numberExperiments) asFloat ].
		averagePoints add: numElements @ averageValue ].
	g := RTGrapher new.
	ds := RTData new.
	ds dotShape cross color: (Color gray alpha: 0.3).
	ds points: points.
	ds x: #x.
	ds y: #y.
	ds label: 'Measured FPP'.
	averageDs := RTData new.
	averageDs dotShape rectangle color: (Color red alpha: 0.5).
	averageDs points: averagePoints.
	averageDs x: #x.
	averageDs y: #y.
	averageDs
		connectUsing:
			(RTStyledMultiLine new dashedLine
				color: (Color red alpha: 0.5);
				width: 2).
	averageDs label: 'Average Measured FPP'.
	dec := PDSStandardDeviationDecorator new.
	dec
		moveBehind;
		color: (Color red alpha: 0.3);
		points: points.
	g addDecorator: dec.
	g add: ds.
	g add: averageDs.
	fpp := [ :size | 
	1 - (bloom hashes * size / bloom storageSize) negated exp
		raisedTo: bloom hashes ].
	ds1 := RTData new.
	ds1 label: 'Estimated FPP'.
	ds1 noDot.
	ds1 points: (0 to: bloom targetElements * 1.5 by: 1).
	ds1 connectColor: Color blue.
	ds1 x: #yourself.
	ds1 y: fpp.
	g add: ds1.
	p := RTHorizontalLineDecorator new.
	p add: (fpp value: bloom targetElements).
	p shape line color: (Color blue alpha: 0.2).
	g addDecorator: p.
	p := RTVerticalLineDecorator new.
	p add: bloom targetElements.
	p shape line color: (Color blue alpha: 0.3).
	g addDecorator: p.
	g
		addDecorator:
			(PDSBoundCursorFollower new
				color: Color blue;
				bindFunction: fpp).
	g legend right.
	g axisX title: '# Elements Added'.
	g axisY title: 'False Positive Probability (FPP)'.
	^ g
]
