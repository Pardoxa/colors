#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

METHOD = 1

def is_numeric?(obj) 
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end
 

def get_cmd_opts()
    options = OpenStruct.new
    
    options.gamma = 1.0
    options.r = 1.2
    options.l1 = 0.1
    options.l2 = 0.8
    options.s = 0.5
    options.hue = 1

    OptionParser.new do |opt|
        opt.on('-h', '--hue HUE', 'Hue intensity scaling 0 <= hue <= 1'){|o| options.hue = o.to_f}
        opt.on('-g', '--gamma GAMMA', 'Gamma value. gamma < 1 mphasises low intensity values, gamma > 1 high intensity ones'){|o| options.gamma = o.to_f}
        opt.on('-s', '--start STARTCOLOR', 'Starting color? Value should be 0 <= s <= 1'){|o| options.s = o.to_f}
        opt.on('-r', '--rot ROTATION', "rotations in color (typically -1.5 to 1.5)"){|o| options.r = o.to_f}
        opt.on("", '--l1 LUMINECENCE_LOW', "Minimal brightness"){|o| options.l1 = o.to_f}
        opt.on("", '--l2 LUMINECENCE_HIGH', "Maximal brightness"){|o| options.l2 = o.to_f}
    end.parse!

    options[:num_cols] = ARGV[0].to_i
    if !is_numeric?(ARGV[0])
        puts "First argument is positional and has to be the number of wanted colors"
        exit 2
    end

    options
end

def main()
    opts = get_cmd_opts()
    puts "#{opts}"

    factor = (opts.l2 - opts.l1)/ (opts.num_cols - 1)

    brightness = Array.new(opts.num_cols) { |e| opts.l1 + e * factor}

    rgb = brightness.map{
        |b|
        color(b, opts.gamma, opts.s, opts.r, opts.hue)
    }

    rgb_255 = rgb.map{
        |rgb_vals|
        into_rgb(rgb_vals)
    }
    gray_vals = rgb.map{
        |rgb_vals|
        gray(rgb_vals, METHOD)
    }

    hex = rgb_255.map{
        |rgb_vals|
        rgb2hex(rgb_vals)
    }

    puts "#{hex}"
    html_both(hex, gray_vals)

end

def html_both(rgb, gray)
    File.open("colors.html", 'w') {
        |file|
        rgb.each{
            |value|
            file.write("<div style=\"background-color: ##{value} ; padding: 10px; border: 0px solid black;\"><p>##{value}</p>")
        }
        rgb.each{
            |v|
            file.write("</div>")
        }
        gray.zip(rgb).each{
            |(value, rgb_val)|
            file.write("<div style=\"background-color: ##{value} ; padding: 10px; border: 0px solid black;\"><p>##{value} ~ Original Color: ##{rgb_val}</p>")
        }
        gray.zip(rgb).each{
            |v|
            file.write("</div>")
        }
    }
end

def html(hex)
    File.open("colors.html", 'w') {
        |file|
        hex.each{
            |value|
            file.write("<div style=\"background-color: ##{value} ; padding: 10px; border: 1px solid green;\"><p>##{value}</p>")
        }
    }
     
end

def into_rgb(arr)
    arr.map{
        |c|
        (c*255).to_i
    }
end 

def rgb2hex(rgb)
    rgb.map{
        |e|
        into_hex(e)
    }.join()
end

def into_hex(i)
    s = i.to_s(16)
    while s.length < 2
        s = "0#{s}"
    end
    s
end

def color(lam, gamma, s, r, hue)
    lg = lam ** gamma 
    phi = 2.0 * (s/3.0 + r * lam) * Math::PI
    
    a = hue*lg*(1-lg)*0.5
    
    cos_phi = Math::cos(phi)
    sin_phi = Math::sin(phi)

    red = a * (-0.14861*cos_phi + 1.78277 * sin_phi) + lg
    green = lg + a* (-0.29227*cos_phi -0.90649*sin_phi)
    blue = lg + a * cos_phi * 1.97294

    [red, green, blue]
end

def gray(rgb, method)
    c = 1.0
    if method == 1
        c = Math::sqrt(rgb[0]**2 *0.299 + rgb[1]**2 * 0.587 + 0.114 * rgb[2]**2)
    elsif method == 2
        c = rgb.reduce(0, :+)
        c = c / 3.0
    elsif method == 3
        c = 0.299*rgb[0] + 0.587 * rgb[1] + 0.114 *rgb[2]
    end
    col = [c,c,c]
    col255 = into_rgb(col)
    rgb2hex(col255)
end


if __FILE__ == $0
    main()
end