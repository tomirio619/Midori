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

# Simulate & Run
To simulate the project, do the following:
* Open the terminal
* Go to the `vhdl_source` folder.
* Enter the command `make test_core`
* It should have compiled and simulated the midori 128 core and written the simulation in `tb_midori128_core.ghw`
* Enter the command `gtkwave tb_midori128_core.ghw`
* GTKWave will open, however nothing will be shown. To be able to see something, you should add the signals you want to see.
* In the left corner there will be something called `\top` with a plus sign.  If you click it will show
`tb_midori128_core` which is the test-bench. Below it will enumerate some "Signals". You can drag these from
the left to the right.
* After dragging all of them you will see the screen change. Press the button with the magnifying glass
and a square inside, that is your "Zoom to fit". After you press it you should have the vision of the
entire simulation.
* The more you click, the deeper you go into the design. Add as many signals if you want.
* You can also save the current preset of the signals. In GTKwave, go to `File -> Write Save File As` (Ctrl + Shift + S).
Now choose a name and safe the preset. The next time you want to load this preset, you do the following: go to `File -> Read Save File` (Ctrl + O). This wil load all the signals that were stored in this preset.
