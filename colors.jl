#!/usr/bin/env julia

function main()
    @show ARGS
    opt = defaultOpts()
    println(opt)
    o = cmd_opts()
    validOpts(o)
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

function validOpts(self::Opts)
    invalid = false
    if self.s < 0 || self.s > 1
        println("Invalid starting color. It has to be 0 <= starting color <= 1; You used ", self.s)
        invalid = true
    end

    if self.hue < 0 || self.hue > 1
        println("Invalid hue, it has to be 0 <= hue <= 1; you used ",self.hue)
        invalid = true
    end

    if self.low >= self.high 
        invalid = true
        println("low < high has to be true, but it wasn't. low: ", self.low, " high: ", self.high)
    end

    if self.low < 0 || self.low >= 1
        invalid = true
        println("low has to be 0 <= low < 1; Low was ", self.low)
    end

    if self.high <= 0 || self.high > 1
        invalid = true
        println("high has to be 0 < high <= 1; high was ", self.high)
    end

    if invalid
        println("Terminating due to invalid Options")
        exit(10)
    end
end

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
    if len < 1 
        println("First argument is positional and has to be the number of requested colors")
        exit(3)
    end
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
    opts
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