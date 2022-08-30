
require "dhr2_love_drawscaledtext"

function love.load()
	local characterlist = {
	" ", "!", "\""
	
	
	}
end

function love.draw()
	
	-- drawing every character to visualize them all
	local x = 0; local y = 0; local ox = 20; local oy = 50;
	for k,v in pairs(bbcfont) do
		drawscaledtext( 64 * x + ox, 64 * y + oy, 6, 6, string.char(k) )
		x = x + 1
		if x == 12 then
			x = 0; y = y + 1
		end
	end

 -- test_string="This is drawscaledtext()"
 -- drawscaledtext( 20, 50, 1, 1, test_string )
 -- drawscaledtext( 20, 75, 1, 2, test_string )
 -- drawscaledtext( 20, 100, 2, 2, test_string )
 -- drawscaledtext( 20, 125, 2, 1, test_string )
 -- drawscaledtext( 20, 150, 2, 3, test_string )
 -- drawscaledtext( 20, 200, 4, 8, test_string )
 -- drawscaledtext( 10, 300, 16.4, 16.4, "Scaled" )
 -- drawscaledtext( 10, 450, 25, 16.4, "text" )
end

