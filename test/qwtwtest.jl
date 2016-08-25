#   simple qwtwplot package test
#
#

using qwtwplot
qwtwStart()

# draw thin blue 'simus':
t = Array(linspace(0.,10.));
y = sin(x);
qfigure(1);
qplot(t, y, "hello qwtw", "-b", 1)

# add green thick another sinus:

y = sin(x .* 4.) + cos(x * 0.8);

qplot(x, y, "hello qwtw", "-g", 4)



# create a circle on another plot window:
t = Array(linspace(0.,2. * pi));
x = sin(t); y = cos(t)
qfigure(2);
qplot2(x, y, "hello qwtw", "-m", 2, t)
