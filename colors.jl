#!/usr/bin/env julia

function main()
    println("Test main")
    @show ARGS
    opt = defaultOpts()
    println(opt)
    o = cmd_opts()
#    validOpts(o)
end

mutable struct Opts
    gamma::Float64
    r::Float64
    low::Float64
    high::Float64
    s::Float64
    hue::Float64
    num_cols::Int
end

#function validOpts(opts)
#    if opts.s < 0 || opts.s > 1
#        println("Invalid starting color")
#    end
#end

function checkCMD(i::Int, len::Int, name)
    if len < i + 1
        println("Error - ", name, " option without value provided")
        exit(3)
    end
end

function cmd_opts()
    opts = defaultOpts()
    arg = ARGS
    println(arg)
    len=length(arg)
    opts.num_cols = parse(Int, arg[1])
    for i in 2:len
        if !startswith(arg[i], "-")
            println(arg[i])
            continue
        end
        if arg[i] == "-h" || arg[i] == "--help"
            println("Help - how to use this progam")
            println("First parameter: Positional. Has to be number of wanted colors")
            exit(0)
        elseif arg[i] == "-g" || arg[i] == "--gamma"
            checkCMD(i, len, "gamma")
            opts.gamma = parse(Float64, arg[i+1])
        elseif arg[i] == "-s" || arg[i] == "--start" || arg[i] == "--start-color"
            checkCMD(i, len, "start color")
            opts.s = parse(Float64, arg[i+1])
        elseif arg[i] == "-r" || arg[i] == "--rotation"
            checkCMD(i,len, "rotation")
            opts.r = parse(Float64, arg[i+1])
        elseif arg[i] == "--hue"
            checkCMD(i, len, "hue")
            opts.hue = parse(Float64, arg[i+1])
        elseif arg[i] == "--low" || arg[i] == "-l"
            checkCMD(i, len, "low")
            opts.low = parse(Float64, arg[i+1])
        elseif arg[i] == "--high"
            checkCMD(i, len, "high")
            opts.high = parse(Float64, arg[i+1])
        end
    end
    println(opts)
end

function defaultOpts()
    Opts(
        1.0,
        1.2,
        0.1,
        0.8,
        0.5,
        1,
        2
    )
end
 

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end