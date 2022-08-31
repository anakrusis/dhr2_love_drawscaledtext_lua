
require "dhr2_love_drawscaledtext"

textcolors = {}

table1 = {0x86, 0x96, 0x8e, 0x85, 0x89, 0x84, 0x8f, 0xc0, 0x20, 0x91, 0x8f, 0x91, 0xc7}

function love.load()
	-- inherent color of hieroglyphs from a small palette
	textcolors[0x81] = "yellow"; textcolors[0x82] = "yellow";
	textcolors[0x83] = "brown"; textcolors[0x84] = "red";
	textcolors[0x85] = "gray";
	textcolors[0x87] = "red"; textcolors[0x88] = "brown";
	textcolors[0x89] = "green";
	textcolors[0x8b] = "yellow"; textcolors[0x8c] = "brown";
	textcolors[0x8d] = "brown"; textcolors[0x8e] = "yellow";
	textcolors[0x8f] = "cyan"; textcolors[0x90] = "red";
	textcolors[0x91] = "green"; textcolors[0x92] = "brown";
	textcolors[0x93] = "magenta"; textcolors[0x94] = "cyan";
	textcolors[0x95] = "cyan"; textcolors[0x96] = "red";
	
	cnv = love.graphics.newCanvas( 2048, 2048 );
	renderdata = love.image.newImageData(2048,2048)
	love.graphics.setCanvas(cnv)
	
	love.graphics.setColor(0,0,0);
	love.graphics.rectangle("fill",0,0,2048,2048)
	
	-- -- drawing every character to visualize them all
	-- local x = 0; local y = 0; local ox = 20; local oy = 50;
	-- for k,v in pairs(bbcfont) do
		-- drawscaledtext( 32 * x + ox, 32 * y + oy, 4, 4, string.char(k) )
		-- x = x + 1
		-- if x == 12 then
			-- x = 0; y = y + 1
		-- end
	-- end
	
	drawscaledtext( 32, 32, 4, 4, tbl2str( table1 ) )
	
	
	love.graphics.setCanvas()
	
	cnv_data = cnv:newImageData()
	renderdata:paste(cnv_data, 0, 0)
	
	saveImage();
end

function love.draw()
	love.graphics.draw(cnv)
end

function tbl2str( tbl )
	local out = ""
	for i = 1, #tbl do
		out = out .. string.char(tbl[i]);
	end
	return out;
end

function saveImage()
	if renderdata ~= nil then
		filenameout = "out/out.png"
		
		dataOut = renderdata:encode("png")
		str_out = dataOut:getString()
		
		file = io.open (filenameout, "wb")
		file:write(str_out)
		file:close()
	end
end

