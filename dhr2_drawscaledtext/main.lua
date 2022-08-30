
require "dhr2_love_drawscaledtext"

function love.draw()
 test_string="This is drawscaledtext()"
 drawscaledtext( 20, 50, 1, 1, test_string )
 drawscaledtext( 20, 75, 1, 2, test_string )
 drawscaledtext( 20, 100, 2, 2, test_string )
 drawscaledtext( 20, 125, 2, 1, test_string )
 drawscaledtext( 20, 150, 2, 3, test_string )
 drawscaledtext( 20, 200, 4, 8, test_string )
 drawscaledtext( 10, 300, 16.4, 16.4, "Scaled" )
 drawscaledtext( 10, 450, 25, 16.4, "text" )
end

