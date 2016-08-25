# qwtwplot

This is another 2D plotting tool for Julia language.  It is based on (my) `qwtw` `"C"` library, which is based on `qwt` library which is based on `QT` library.

Current version works only for `Windows7 x64`.
In short, how to install it (for Windows7 x64):
----------------------------
* install `qwtw` library using an installer from
		https://github.com/ig-or/qwtw/releases/download/v1.0/qwtwsetup.exe
* in Julia command prompt, run 		`Pkg.clone("https://github.com/ig-or/qwtwplot")`
* look at usage example `test/qwtwtest.jl`
* and let the force be with you

Another description
----------------------------
You can see how it looks like here:
		https://github.com/ig-or/qwtw

Current version works only for `Windows7 x64`, but it should not be difficult to make everything work for x32 Windows and for Linux. Actually I'm using all this both from Windows and from Fedora Linux.

In orider to use this package, you'll have to have `qwtw` library "installed". For `Windows7 x64` I have an "installer"
		https://github.com/ig-or/qwtw/releases/download/v1.0/qwtwsetup.exe

For Linux you'll have to build `qwtw` library by yourself. It depends on a number of other libraries, so it can be a bit tricky (but for `Fedora Linux` instructions from `qwtw` project page works I should be able to create at least an RPM when I will have more time).




[![Build Status](https://travis-ci.org/ig-or/qwtwplot.jl.svg?branch=master)](https://travis-ci.org/ig-or/qwtwplot.jl)
