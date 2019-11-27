

# README Generator

## Description


    The README Generator is a Pharo Smalltalk based tool to auto-generate a software project's README file
    using the metadata fetched from sources of truth like Maven's POM file and/or Makefiles.

    This way you avoid data repetition and inconsistencies in documentation. You should never edit manually
    your project's README, but regenerate it every time the project's metadata are updated.
  



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


* [Rafael Luque](https://osoco.es) <[rafael.luque_AT_osoco.es](mailto:rafael.luque_AT_osoco.es)> - [Developer]



