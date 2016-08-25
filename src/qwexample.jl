#   simple qwtwplot package example
#
#

using qwtwplot
qwtwStart() # start 'qwtwc' library

# draw thin blue 'sinus':
tMax = 10.
t = Array(linspace(0.,tMax, 10000));
n = length(t);
y = sin(t);
qfigure(1); # "1" the number of the first plot window
 # parameters: 'x' and 'y' data vectors, then 'name of this line', then 'style description', then 'line width'
qplot(t, y, "blue line", "-b", 1)

# add green thick another sinus:
y = sin(t .* 4.) + cos(t * 0.8);
qplot(t, y, "thick green line", "-g", 4) #'x' and 'y' data vectors, then 'name of this line', then 'style description', then 'line width'
qtitle("first plot window") # add a title for the first plot
qxlabel("time (in seconds)") # put a label on X axis
qylabel("happiness") # put a label on Y axis

#= By default, "ZOOM" mode is active. This means that
	now you can select some part of the plot with left mouse button.
	Right mouse button will return you back to the previous state.
	And try mouse wheel also.

	Button with a "hand" - it's a "pan mode".  It will shift all the plots, but not change scale.
	"disk" button - allow you to save image to a file
	"[]" buttom means "make square axis" i.e. make equal scale for X and Y axis.

	Real magic is in left and right buttons; see below about it.

=#

# create another plot, with high frequency signal
noise = rand(n);
y = sin(t * 100.) + noise;
qfigure(2)
qplot(t, y, "sinus + noise", "-m", 2)
qtitle("frequency test")

# what is the frequency of our signal from last window?
# pless "f" button, on new small window select "sinus + noise",
# select "4" from combo box and close this small window
# after this "frequency" plot will be created

# add another line to the first plot:
t1 = Array(linspace(0.,10., 5))
y1 = cos(t1 * 0.5)
qfigure(1); # switch back to the first plot

# if we do not need the lines, only symbols:
qplot1(t1, y1, "points and line", " eb",  30)

 # parameters: 'x' and 'y' data vectors, then 'name of this line',
 # then 'style description', then 'line width', and "symbol size"
qplot(t1, y1, "points and line", "-tm", 2, 10)

#= now, try to use an arrow burtton: it will draw a marker on all the plots.

	Next, select some region on one of the plot with ZOOM tool;  and press right "clip" button.
	All the plots will zoom to the same region.
	There is a bug with "top view" plots, but it can be fixed.

=#


# create a circle on another plot window:
x = sin(t*2.*pi/tMax); y = cos(t*2.*pi/tMax);
qfigure(3);
qplot2(x, y, "circle #1", "-r", 2, t)
qtitle("circle")

# now press "[]" buttol in order to make a circle look like circle

# try to use left button ("ARROW") on a circle plot - it also works

# draw one more circle:
t1 = Array(linspace(0.,2. * pi, 8));
x1 = 0.5*sin(t);
y1 = 0.5*cos(t);
qplot2p(x1, y1, "circle #1", " ec", 20, t1)

# show "main window":
qsmw()

# now lets try to draw a map
mwn = 4 # for example, we have only 4 points
north = [55.688713, 55.698713, 55.678713, 55.60]; # coords in degrees
east = [37.901073, 37.911073, 37.905073, 37.9]; # coords in degrees
t4 = Array(linspace(0.,tMax, 4)); # create corresponding time info (for magic markers)

qfmap(5)
qplot2p(east, north, "trajectory #1", "-rb",  20, t4);
qtitle("top view test");

#another map:
north1 = [65.688713, 65.698713, 65.678713, 65.60]; # coords in degrees
east1 = [27.901073, 28.111073, 28.005073, 27.9]; # coords in degrees
qfmap(6)
qplot2(east1, north1, "trajectory #2", "-rb",  2, t4);
qplot2(east1, north1, "points", " er",  20, t4);
qtitle("top view test #2");


# close all the windows
qclear()
