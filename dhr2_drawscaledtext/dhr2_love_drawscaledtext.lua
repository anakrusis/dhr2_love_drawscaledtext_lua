--[[

  .----------------------------.
  | dhr2_love_drawscaledtext.lua |
  '----------------------------'
 
  ................................................................
  . Johnsonscript style 'drawscaledtext' function for lua/love2d .
  . by patty aka dhr2                                            .
  ................................................................

  This library provides a function 'drawscaledtext( x, y, xs, ys, string )' that draws an ASCII text string to the screen using an 8x8 1bit bitmap font.

  It will draw text string 'string' at screen position x,y with independent width and height scaling factors xs,ys.
  For instance, xs=1 ys=1 will set the font size to 8x8. xs=1 ys=2 will set the font size to 8x16, etc.
  Scaling factors below 1 will be clamped to 1.

  TO DO:
   * Some support for unicode could potentially be added.
   * Perhaps an optimisation could be added where the we check if the X position goes outside of the screen/canvas bounds and exit the function if so.

  This software is licensed under GPLv3. You can use the software but ONLY if you want to and ONLY under the terms described under the GPL version 3

--]]


--[[
 Define font array and define the glyphs for the characters.
--]]

bbcfont = {}
file = love.filesystem.newFile("font16.bin")
file:open("r")
content = file:read()
file:close()

-- this is repurposed from the editor code, with a few differences:
for i = 1, #content, 2 do
	local currchar = math.floor((i - 1) / 32);
	local currbyte = string.byte(string.sub(content, i, i))*256 + string.byte(string.sub(content, i+1, i+1)); 
	-- we create the table with eight blank rows in it here
	if not bbcfont[currchar] then
		bbcfont[currchar] = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}};
	end
	-- the row number is just i mod 8 (accounting for off-by-one lua sillyness)
	local row = (math.floor(( i - 1 )) % 16) + 1;
	
	-- just as before, we just get the least significant bit and divide by 2 eight times
	-- this gives us the bits in reverse order
	for j = 1, 16 do
		-- but the insert position is always 1 now because we have these little 8-wide sub-tables
		local insertposition = 1
		table.insert(bbcfont[currchar][ row ], insertposition, currbyte % 2)
		currbyte = math.floor(currbyte / 2)
	end


end

-- defining colors for hieroglyphic text
colors = {
	white = {1,1,1},
	gray = {0.66,0.66,0.66},
	yellow = {1,1,0},
	red = {1,0,0},
	brown = {0.66, 0.33, 0},
	green = {0,1,0},
	cyan = {0,1,1},
	magenta = {0.66,0,1}
}


--[[

 .................................
 . The 'drawscaledtext' function .
 .................................

--]]


bbcfont[0] = {
 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
 {0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0},
 {0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0},
 {0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0},
 {0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0},
 {0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0},
 {0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0},
 {0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0},
 {0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0},
 {0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0},
 {0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0},
 {0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0},
 {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
}


function drawscaledtext( x, y, xs, ys, string )

 -- Scale factors of less than 1 are not supported.  
 if xs < 1 then
  xs = 1
 end
 if ys < 1 then
  ys = 1
 end
 
 -- If the specified scale factor is 1, we do not need to interpolate.
 local interpolate
 interpolate = not ( xs == 1 and ys == 1 )

 -- This local function 'charpixel()' is used for looking up pixels in the 8x8 pixel character glyphs.
 -- Note that it assumes that bbcfont[c] is not nil. It is only called after we are sure a glyph has been defined for character byte 'c'.
 function charpixel( x, y, c )
  if x<1 or x>16 or y<1 or y>16 then
   return false
  end
  return ( bbcfont[c][y][x] ~= 0 )
 end

 -- Main drawing loop. Iterate over every character in 'string',
 -- check if a glyph corresponding to the character byte exists in 'bbcfont' the array of glyph definitions,
 -- and draw that glyph at the appropriate screen location at the appropriate scaled size
 -- (or if no glyph was defined for this character byte, we use the fallback glyph)
 local ch, c, i
 ch = string.sub( string, 1, 1 )
 i=1

 while ch ~= "" do

  c = string.byte( ch )

  if bbcfont[c] == nil then      -- If no glyph is define for this character, we use the fallback glyph.
   c = 0
  end
  
  if textcolors[c] then
	love.graphics.setColor( colors[ textcolors[c] ] )
  else
	love.graphics.setColor( colors[ "white" ] );
  end

  for xx=1,16,1 do               --  For each pixel in the 8x8 pixel glyph representing this character,
   for yy=1,16,1 do              --   if the pixel is set/true, we draw it as a rectangle,
                                 --   else, we interpolate by drawing a set of up to 4 triangles depending on the surrounding glyph pixels.
    if charpixel( xx,   yy,  c ) then 

     love.graphics.rectangle( "fill", x + (xx-1)*xs, y + (yy-1)*ys, xs, ys )

    else

     if interpolate then

      local above,below,left,right, x1,y1,x2,y2

      above = charpixel( xx,   yy-1,  c )
      below = charpixel( xx,   yy+1,  c )
      left  = charpixel( xx-1, yy,    c )
      right = charpixel( xx+1, yy,    c )

      x1  =  x + (xx-1) *  xs
      x2  =  x +  xx    *  xs
      y1  =  y + (yy-1) *  ys
      y2  =  y +  yy    *  ys

      if ( above ) and ( left ) then
       love.graphics.polygon( "fill", x1,y1, x2,y1, x1,y2 )
      end
      if ( above ) and ( right ) then
       love.graphics.polygon( "fill", x2,y1, x1,y1, x2,y2 )
      end
      if ( below ) and ( left  ) then
       love.graphics.polygon( "fill", x1,y2, x1,y1, x2,y2 )
      end
      if ( below ) and ( right ) then
       love.graphics.polygon( "fill", x2,y2, x1,y2, x2,y1 )
      end
      
     end -- endif interpolate

    end -- endif charpixel
   end -- end for yy
  end -- end for xx

  i = i + 1
  ch = string.sub( string, i, i )
  x = x + 16*xs

 end -- endwhile

end

