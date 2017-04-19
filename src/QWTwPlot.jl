module QWTwPlot

#=  this code below should
	handle OS and Julia language version differences
=#

oss = 0;
ver = 0;
sys_str = "is_windows()";
if VERSION > v"0.4.50"
	ver = 5;
	@printf("\tjulia version > 0.4 detected\n")
	sys_str = "(is_windows())";

elseif VERSION >= v"0.4"
	ver = 4;
	@printf("\tjulia version 0.4 detected\n")
	sys_str = "(@windows? 1 : 0)"
else
	@printf("\tunknown julia version, sorry\n")
	ver = 0;
end

win = eval(parse(sys_str))
if (convert(Bool, win))
	@printf("\t Windows detected\n");
	ENV["PATH"]=ENV["ALLUSERSPROFILE"]*"\\qwtw;"*ENV["PATH"];
	oss = 1;
else
	@printf("\t non-Windows detected\n");
	oss = 2;
end

# DLLs and function handles below:
qwtwLibHandle = 0
qwtwFigureH = 0
qwtwFigure3DH = 0
qwtwTopviewH = 0
qwtwsetimpstatusH = 0
qwtwCLearH = 0
qwtwPlotH = 0
qwtwPlot2H = 0
qwtwPlot3DH = 0
qwtwXlabelH = 0
qwtwYlabelH = 0
qwywTitleH = 0
qwtwVersionH = 0
qwtwMWShowH = 0

# start qwtw "C" library and attach handlers to it:
function qwtwStart(debugMode::Int64 = 0)

	libName = "nolib"
#	if is_windows()
	if oss == 1
		libName = "qwtwc"
	else
		libName = "libqwtwc.so"
	end
	if debugMode != 0 libName = string(libName, "d"); end

	global qwtwLibHandle, qwtwFigureH, qwtwTopviewH,  qwtwsetimpstatusH, qwtwCLearH, qwtwPlotH
	global qwtwPlot2H, qwtwXlabelH, qwtwYlabelH, qwywTitleH, qwtwVersionH, qwtwMWShowH
	global qwtwPlot3DH, qwtwFigure3DH

	if qwtwLibHandle != 0 # looks like we already started
		return
	end
	qwtwStop()
	qwtwLibHandle = Libdl.dlopen(libName)
	qwtwFigureH = Libdl.dlsym(qwtwLibHandle, "qwtfigure")
	qwtwFigure3DH = Libdl.dlsym(qwtwLibHandle, "qwtfigure3d")
	qwtwTopviewH = Libdl.dlsym(qwtwLibHandle, "topview")
	qwtwsetimpstatusH = Libdl.dlsym(qwtwLibHandle, "qwtsetimpstatus")
	qwtwCLearH = Libdl.dlsym(qwtwLibHandle, "qwtclear")
	qwtwPlotH = Libdl.dlsym(qwtwLibHandle, "qwtplot")
	qwtwPlot3DH = Libdl.dlsym(qwtwLibHandle, "qwtplot3d")
	qwtwPlot2H = Libdl.dlsym(qwtwLibHandle, "qwtplot2")
	qwtwXlabelH = Libdl.dlsym(qwtwLibHandle, "qwtxlabel")
	qwtwYlabelH = Libdl.dlsym(qwtwLibHandle, "qwtylabel")
	qwywTitleH = Libdl.dlsym(qwtwLibHandle, "qwttitle")
	qwtwVersionH = Libdl.dlsym(qwtwLibHandle, "qwtversion")
	qwtwMWShowH = Libdl.dlsym(qwtwLibHandle, "qwtshowmw")


	version = qversion();
	println(version);

	return;
end

# detach from qwtw library (very useful for debugging)
# but PLEASE do not call it. This is for
# debugging (underlying qwtw "C" library) only.
function qwtwStop()
	global qwtwLibHandle
	if qwtwLibHandle != 0
		Libdl.dlclose(qwtwLibHandle)
	end
	qwtwLibHandle = 0
end

# return version info (as string)
function qversion()
	global qwtwVersionH
	v =  Array(Int8, 128)
	ccall(qwtwVersionH, Int32, (Ptr{Int8},), v);
	#return bytestring(pointer(v))
	cmd = "unsafe_string(pointer($v))";
	if ver < 5
		cmd = "bytestring(pointer($v))";
	end

	#return unsafe_string(pointer(v))
	return eval(parse(cmd))
end;

function traceit( msg )
      global g_bTraceOn

      if ( true )
         bt = backtrace() ;
         s = sprint(io->Base.show_backtrace(io, bt))

         println( "debug: $s: $msg" )
      end
end

# create a new plot window (with specific window ID)
function qfigure(n)
#  a::String = libName();
	global qwtwFigureH
	ccall(qwtwFigureH, Void, (Int32,), n);
end;

# create a new  window to draw on a map (with specific window ID)
function qfmap(n)
	global qwtwTopviewH
	ccall(qwtwTopviewH, Void, (Int32,), n);
end;

# create a new  window to draw a 3D points (QT engine)
function qf3d(n)
	global qwtwFigure3DH
	ccall(qwtwFigure3DH, Void, (Int32,), n);
end;

#=  set up an importance status for next lines. looks like '0' means 'not important'
'not important' will not participate in 'clipping'
=#
function qimportant(i)
	global qwtwsetimpstatusH
	ccall(qwtwsetimpstatusH, Void, (Int32,), i);
end

#= close all the plots
=#
function qclear()
	global qwtwCLearH
	ccall(qwtwCLearH, Void, ());
end

# open "main control window"
function qsmw()
	global qwtwMWShowH
	ccall(qwtwMWShowH, Void, ());
end

# plot normal lines
# what does 'style' parameter means? look on
# example code
# for info about it (  https://github.com/ig-or/QWTwPlot.jl/blob/master/src/qwexample.jl  )
function qplot(x::Vector{Float64}, y::Vector{Float64}, name::String, style::String,
		lineWidth, symSize)
	global qwtwPlotH
	if length(x) != length(y)
		@printf("qplot: x[%d], y[%d]\n", length(x), length(y))
		traceit("error")
	end
	assert(length(x) == length(y))

	n = length(x)
	ww::Int32 = lineWidth;
	s::Int32 = symSize
	try
		ccall(qwtwPlotH, Void, (Ptr{Float64}, Ptr{Float64}, Int32, Ptr{UInt8}, Ptr{UInt8}, Int32, Int32),
			x, y, n, name, style, ww, s);
		sleep(0.025)
	catch
		@printf("qplot: error #2\n")
		traceit("error #2")
	end
end;

# plot lines without symbols
function qplot(x::Vector{Float64}, y::Vector{Float64}, name::String, style::String,
		lineWidth)
	qplot(x, y, name, style, lineWidth, 1)
end;

# draw symbols with optional line width = 1
function qplot1(x::Vector{Float64}, y::Vector{Float64}, name::String, style::String, w)
	global qwtwPlotH
	assert(length(x) == length(y))
	n = length(x)
	ww::Int32 = w;
	ccall(qwtwPlotH, Void, (Ptr{Float64}, Ptr{Float64}, Int32, Ptr{UInt8}, Ptr{UInt8}, Int32, Int32),
		x, y, n, name, style, 1, ww);
	sleep(0.025)

end;

# draw symbols in 3D space
# currently style and 'w' are not used
function qplot3d(x::Vector{Float64}, y::Vector{Float64}, z::Vector{Float64},
	 		name::String, style::String, w)
	global qwtwPlotH
	assert(length(x) == length(y))
	n = length(x)
	ww::Int32 = w;
	ccall(qwtwPlot3DH, Void, (Ptr{Float64}, Ptr{Float64}, Ptr{Float64},
			Int32, Ptr{UInt8}, Ptr{UInt8}, Int32, Int32),
		x, y, z, n, name, style, 1, ww);
	sleep(0.025)

end;

# plot 'top view'
function qplot2(x::Array{Float64}, y::Array{Float64}, name::String, style::String, w, time::Array{Float64})
	global qwtwPlot2H
	assert(length(x) == length(y))
	n = length(x)
	ww::Int32 = w;
	ccall(qwtwPlot2H, Void, (Ptr{Float64}, Ptr{Float64}, Int32, Ptr{UInt8}, Ptr{UInt8}, Int32, Int32, Ptr{Float64}),
		x, y, n, name, style, ww, 1, time);
	sleep(0.025)

end;

# plot 'top view'
function qplot2p(x::Array{Float64}, y::Array{Float64}, name::String, style::String, w, time::Array{Float64})
	global qwtwPlot2H
	assert(length(x) == length(y))
	n = length(x)
	ww::Int32 = w;
	ccall(qwtwPlot2H, Void, (Ptr{Float64}, Ptr{Float64}, Int32, Ptr{UInt8}, Ptr{UInt8}, Int32, Int32, Ptr{Float64}),
		x, y, n, name, style, 1, ww, time);
	sleep(0.025)

end;

# put label on horizontal axis
function qxlabel(s::String)
	global qwtwXlabelH
	ccall(qwtwXlabelH, Void, (Ptr{UInt8},), s);
end;

# put label on left vertical axis
function qylabel(s::String)
	global qwtwYlabelH
	ccall(qwtwYlabelH, Void, (Ptr{UInt8},), s);
end;

# put title on current plot
function qtitle(s::String)
	global qwywTitleH
	ccall(qwywTitleH, Void, (Ptr{UInt8},), s);
end;


export qfigure, qfmap, qsetmode, qplot, qplot1, qplot2, qplot2p, qxlabel,  qylabel, qtitle
export qimportant, qclear, qwtwStart, qwtwStop, qversion, qsmw
export traceit
export qplot3d, qf3d


end # module
