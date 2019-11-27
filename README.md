

# README Generator



The README Generator is a Pharo Smalltalk based tool to auto-generate a software project's README file using the metadata fetched from sources of truth like Maven's POM file and/or Makefiles.
    
This way you avoid data repetition and inconsistencies in documentation. You should never edit manually your project's README, but regenerate it every time the project's metadata are updated.

## Installation

You can install this tool evaluating the following expression in a Pharo image:

```Smalltalk
Metacello new
    baseline: 'ReadmeGenerator';
    repository: 'github://osoco/READMEGenerator/src';
    load.
```

## Running with Docker

You can use the tool without installing software via the following its [Docker image](https://hub.docker.com/r/osoco/readme-generator).

Simply execute the following command from the project's root directory:

```
$ docker run -v $(pwd):/data osoco/readme-generator:latest [--help]
```

  



## Usage

The targets to build or run the application are defined via its [Makefile](Makefile):

```shell
                           
Clean                      
-----                      
mrproper                      Delete all artefacts
                           
Build                      
-------                    
build                         Build README Generator
get-image                     Download the latest stable Pharo image and VM
install                       Install README Generator and dependencies
                           
Docker                     
------                     
build-docker                  Run all tests
                           
Running                    
-------                    
run                           Run the generator

```



## Project Links

* Source Code: [GitHub](https://github.com/osoco/READMEGenerator)

## Team


* <img src="https://osoco.es/images/personas/rafael-luque.jpg" height="30"> [Rafael Luque](https://osoco.es) (*Pharo Developer*)


## License

* MIT License




