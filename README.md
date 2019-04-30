# PharoPDS

Probabilistic data structures implemented in Pharo.

PharoPDS is written and supported by developers at [OSOCO](https://osoco.es).

## Install PharoPDS

To install PharoPDS on your Pharo image you can just execute the following script:

```Smalltalk
    Metacello new
      baseline: #ProbabilisticDataStructures;
    	repository: 'github://osoco/PharoPDS:master/src';
    	load
```

You can optionally install all the custom extensions and interactive tutorials included with the project executing the following script to install the group 'All':


```Smalltalk
    Metacello new
      baseline: #ProbabilisticDataStructures;
    	repository: 'github://osoco/PharoPDS:master/src';
    	load: 'All'
```

To add PharoPDS to your own project's baseline just add this:

```Smalltalk
    spec
    	baseline: #ProbabilisticDataStructures
    	with: [ spec repository: 'github://osoco/PharoPDS:master/src' ]
```

Note that you can replace the #master by another branch or a tag.
