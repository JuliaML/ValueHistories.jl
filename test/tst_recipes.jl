# THIS FILE IS DEACTIVATED

using Random
using Plots
using VisualRegressionTests

# run a visual regression test comparing the output to the saved reference png
function dotest(testname, func)
    Random.seed!(1)
    reffn = joinpath(refdir, "$testname.png")
    vtest = VisualTest(func, reffn)
    result = test_images(vtest)
    @test success(result)
end

# builds a testable function which saves a png to the location `fn`
# use: VisualTest(@plotfunc(plot(rand(10))), "/tmp/tmp.png")
macro plottest(testname, expr)
    esc(quote
        dotest(string($testname), fn -> begin
            $expr
            png(fn)
        end)
    end)
end

# don't let pyplot use a gui... it'll crash
# note: Agg will set gui -> :none in PyPlot
# - This unglyness needs to change
had_mlp = haskey(ENV, "MPLBACKEND")
_old_env = get(ENV, "MPLBACKEND", "")
ENV["MPLBACKEND"] = "Agg"
import PyPlot
info("Matplotlib version: $(PyPlot.matplotlib[:__version__])")
pyplot(size=(200,150), reuse=true)

refdir = joinpath(dirname(@__FILE__), "refimg")

@plottest "dynmv" begin
	history = ValueHistories.MVHistory(QHistory)
	for i=1:100
		x = 0.1i
		push!(history, :a, x, sin(x))
		push!(history, :wrongtype, x, "$(sin(x))")
		if i % 10 == 0
			push!(history, :b, x, cos(x))
		end
	end
	plot(history)
end

@plottest "dynmv_sub" begin
	history = ValueHistories.MVHistory()
	for i=1:100
		x = 0.1i
		push!(history, :a, x, sin(x))
		push!(history, :wrongtype, x, "$(sin(x))")
		if i % 10 == 0
			push!(history, :b, x, cos(x))
		end
	end
	plot(history, layout=2)
end

@plottest "queueuv" begin
	history = ValueHistories.QHistory(Int)
	for i = 1:100
		push!(history, i, 2i)
	end
	plot(history)
end

@plottest "vectoruv" begin
	history = ValueHistories.History(Int)
	for i = 1:100
		push!(history, i, 100-i)
	end
	plot(history)
end

@plottest "uv_vector" begin
	history1 = ValueHistories.History(Int)
	history2 = ValueHistories.QHistory(Int)
	for i = 1:100
		push!(history1, i, 2i)
		push!(history2, i, 100-i)
	end
	plot([history1, history2], layout = 2)
end

if had_mlp
    ENV["MPLBACKEND"] = _old_env
else
    delete!(ENV, "MPLBACKEND")
end

