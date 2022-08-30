-- this is a 2 dimemnsional table with both indices starting at zero
bbcfont = {}
charselected = 1;

ox = 250; oy = 180;
rectsize = 32;

function love.load()
	love.graphics.setFont(love.graphics.newFont(18))
end

function love.filedropped(file)
	bbcfont = {}
	file:open("r");
	local content = file:read();
	file:close();
	
	for i = 1, #content do
		-- each character is eight bytes
		local currchar = math.floor((i - 1) / 8);
		local currbyte = string.byte(string.sub(content, i, i));
		if not bbcfont[currchar] then
			bbcfont[currchar] = {};
		end
		
		-- we just get the least significant bit and divide by 2 eight times
		-- this gives us the bits in reverse order
		for j = 1, 8 do
			local insertposition = 8 * ( (i - 1) % 8 )
			table.insert(bbcfont[currchar], insertposition, currbyte % 2)
			currbyte = math.floor(currbyte / 2)
		end
	end
	
	--for j = 0, #bbcfont do
	--	print("index " .. j)
	--	for i = 0, 63 do
	--		print(bbcfont[j][i])
	--	end
	--end
end

function love.keypressed(key)
	if key == "left" then
		charselected = math.max(0, charselected - 1);
	end
	if key == "right" then
		charselected = math.min(#bbcfont, charselected + 1);
	end
	
	if key == "s" then
		local file = io.open("out/font_out.bin", "wb");
		local output = "";
		
		for j = 0, #bbcfont do
			local currbyte = 0;
			for i = 0, 63 do
				currbyte = (2 * currbyte) + (bbcfont[j][i])
				
				if (i % 8 == 7) then
					output = output .. string.char(currbyte)
					currbyte = 0;
				end
			end
		end
		file:write(output)
		file:close()
	end
end

function love.mousereleased( x,y,button )
	local px = math.floor((x - ox) / rectsize)
	local py = math.floor((y - oy) / rectsize)
	local pind = (py * 8) + px;
	
	if not bbcfont[charselected] then return end
	if not bbcfont[charselected][pind] then return end
	bbcfont[charselected][pind] = (bbcfont[charselected][pind] + 1) % 2
	
	print(px .. " " .. py)
end

function love.draw()
	if not bbcfont[charselected] then love.graphics.print("Drag and drop a font file to get started!", 200, 200); return end
	
	for i = 0, #bbcfont[charselected] do
		local rx = ox + (rectsize * ( i % 8 )); local ry = oy + (rectsize * math.floor( i / 8 ))
		
		local fillstring;
		if bbcfont[charselected][i] == 1 then
			fillstring = "fill"
		else
			fillstring = "line"
		end
		love.graphics.rectangle(fillstring, rx, ry, rectsize, rectsize)
		
	end
	
	love.graphics.print("Left and right arrows to change character, S to save")
end