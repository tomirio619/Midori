# Midori

This repository contains a Python implementation ofthe Midori 128 bit block cipher.
In addition, it also contains a hardware designed of this cipher, implemented in VHDL.

To be able to run the VHDL project on Windows, you need to have the following things installed

* CMake, can be found [here](https://cmake.org/download/). Also make sure that the corresponding `bin` folder 
  (default location is `C:\Program Files (x86)\CMake\bin`) is added to your `PATH` variable,
  as we will need to invoke this utility from the command line later on.

* GHDL, can be found [here](https://github.com/tgingold/ghdl/releases). Also add the `bin` folder to your path 
(default location is `C:\Program Files (x86)\ghdl-x.yz\bin`, where `x.yz` corresponds to the version you are using). 

* gtkwave, can be found [here](http://gtkwave.sourceforge.net/). Also add the `bin` folder to your path (default location is `C:\Program Files (x86)\gtkwave`) 

* Sublime text. We will use a custom VHDL syntax highlighing. This requires you to install the Sublime Text Package manager called Package Control.
  Once you have this installed, press `CTRL + SHIFT + P`, select `install package` and search for `VHDL`. The package you need to install is called `VHDL Package for Sublime Text 2/3`.
  
Take a look at the make file to see which targets are specified.
