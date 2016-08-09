using Plots
using VisualRegressionTests

# don't let pyplot use a gui... it'll crash
# note: Agg will set gui -> :none in PyPlot
ENV["MPLBACKEND"] = "Agg"
import PyPlot
info("Matplotlib version: $(PyPlot.matplotlib[:__version__])")
pyplot(size=(200,150), reuse=true)

refdir = Pkg.dir("ValueHistories", "test", "refimg")

# run a visual regression test comparing the output to the saved reference png
function dotest(testname, func)
    srand(1)
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

@plottest "dynmv" begin
	history = ValueHistories.DynMultivalueHistory(QueueUnivalueHistory)
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
	history = ValueHistories.DynMultivalueHistory()
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
	history = ValueHistories.QueueUnivalueHistory(Int)
	for i = 1:100
		push!(history, i, 2i)
	end
	plot(history)
end

@plottest "vectoruv" begin
	history = ValueHistories.VectorUnivalueHistory(Int)
	for i = 1:100
		push!(history, i, 100-i)
	end
	plot(history)
end

@plottest "uv_vector" begin
	history1 = ValueHistories.VectorUnivalueHistory(Int)
	history2 = ValueHistories.QueueUnivalueHistory(Int)
	for i = 1:100
		push!(history1, i, 2i)
		push!(history2, i, 100-i)
	end
	plot([history1, history2], layout = 2)
end
