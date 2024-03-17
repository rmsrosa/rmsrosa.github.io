# This file was generated, do not modify it. # hide
#hideall
using PrettyTables

formatter = (v,i,j) -> j == 1 ? Int(v) : round(v, digits=3)
# pretty_table(hcat(Vdeg_range, bounds), ["degree" "bound"], header_crayon=crayon"yellow bold", formatters=formatter) # hide - - for VSCode or the REPL, instead of the following
io = IOBuffer()
pretty_table(io, hcat(Vdeg_range, bounds), ["degree" "bound"], backend=:html, standalone=false, formatters=formatter)
println("~~~", String(take!(io)), "~~~")