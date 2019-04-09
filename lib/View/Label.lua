package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local Label = {}
Label.__index = Label


setmetatable(Label, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function Label.new(p,cairo)
if conky_window == nil then
        return 0
end

local cairo_cr, cs, internal_cairo
if cairo == nil then
	cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	cairo_cr = cairo_create(cs)
	internal_cairo = true
else
	cairo_cr = cairo
	internal_cairo = false
end
local txtconfig = {
        text="test",
        fontname = p.font,
        sizeby = 'height',
        color = p.fg["title"],
        alpha = 1.0,
	shadow = true,
	shadowalpha = 0.5,
	shadowcolor = p.fg["shadow"],
	}
local text = DrawText:new(txtconfig,cairo_cr)

return setmetatable({cr = cairo_cr, cs = cs, properties = p,text = text, internal_cairo = internal_cairo}, Label)
end

function Label:destroy()
if self.internal_cairo then
	-- modificando para tentar gerar imagem 
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
else
	cairo_destroy(cr)
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
end
end

function Label:layout(index,wtype)
local layout = {} 

if index == nil then
	index = 0
end

-- box
local bx = self.properties.border.x
local by = self.properties.border.y
local bh = (self.properties.border.h/self.properties.grid.y)
local bw = (self.properties.border.w/self.properties.grid.x)

-- graph
local gh = bh*0.9
local gw = bw
local gx = self.properties.border.x
local gy = self.properties.border.y+index*bh

layout["bx"] = bx 
layout["by"] = by
layout["bh"] = bh
layout["bw"] = bw
layout["gh"] = gh
layout["gw"] = gw
layout["gx"] = gx
layout["gy"] = gy

if wtype == "imageGraph" then
	--image
	-- lets reserve 50% of the widget for image and the rest for text
	local imgx =  gw*0.10
        local imgy = gh*0.15+index*bh
	local imgw = gw*0.4
	local imgh = gh*0.8

	local th = gh*0.4
	local th2 = gh*0.25
	local tx = gw*0.55
	local tx2 = gw*0.62
	local ty = gh*0.55+index*bh
	local ty2 = gh*0.95+index*bh

	layout["th"]  = th 
	layout["tx"]  = tx
	layout["ty"]  = ty
	layout["th2"] = th2
	layout["tx2"] = tx2
	layout["ty2"] = ty2

	layout["imgx"] = imgx
	layout["imgy"] = imgy
	layout["imgw"] = imgw
	layout["imgh"] = imgh
end

-- text
if wtype == "textWidget" then
	local th = gh*0.4
	local th2 = gh*0.25
	local tx = bx+gw*0.10
	local tx2 = bx+gw*0.12
	local ty = by+gh*0.55+index*bh
	local ty2 = by+gh*0.95+index*bh

	layout["th"]  = th 
	layout["tx"]  = tx
	layout["ty"]  = ty
	layout["th2"] = th2
	layout["tx2"] = tx2
	layout["ty2"] = ty2
end

if wtype == "singleGraph" then
	-- text title
	local tx = gw*0.10
	local th = gh*0.2
	local ty = gh*0.35+index*bh
	local th2 = gh*0.2
	local grtx = tx
	local grty = gh*0.5+index*bh
	local grty2 = gh*0.75+index*bh
	local grth = gh*0.2
	local grtw = gw*0.8
	local tx2 = gw*0.2
	local ty2 = gh*0.75+th2+index*bh
	layout["tx"] =    tx 
	layout["th"] =    th 
	layout["ty"] =    ty 
	layout["th2"] =   th2 
	layout["tx2"] =   tx2 
	layout["ty2"] =   ty2 
	layout["grtx"] =  grtx
	layout["grty"] =  grty
	layout["grty2"] =  grty2
	layout["grth"] =  grth
	layout["grtw"] =  grtw
end


if wtype == "dualGraph" then
	-- text title
	local tx = gw*0.10
	local th = gh*0.2
	local ty = gh*0.35+index*bh
	-- graph rectangle
	local grtx = tx
	local grth = gh*0.2
	local grtw = gw*0.8
	local grty1 = gh*0.5+index*bh
	local grty2 = gh*0.75+index*bh
	layout["tx"] =    tx 
	layout["th"] =    th 
	layout["ty"] =    ty 
	layout["grtx"] =  grtx
	layout["grth"] =  grth
	layout["grtw"] =  grtw
	layout["grty"] =  {}
	layout["grty"][1] =  grty1
	layout["grty"][2] =  grty2
end

if wtype == "lineGraph" then
	local tx = gw*0.10
	local ty = gh*0.55+index*bh
	local th = gh*0.5

	local tx2 = gw*0.12
	local th2 = gh*0.25
	local ty2 = gh*0.95+index*bh


	local grtx = tx
	local grty = gh*0.7+index*bh
	local grth = gh*0.2
	local grtw = gw*0.8

	layout["th"]  = th 
	layout["tx"]  = tx
	layout["ty"]  = ty
	layout["grtx"] =  grtx
	layout["grty"] =  grty
	layout["grth"] =  grth
	layout["grtw"] =  grtw
end

-- status line
if self.properties.indicator == "right" then
	local sw = gw*0.03
	local sx = gx+gw*0.97
	layout["sw"] = sw
	layout["sx"] = sx
elseif self.properties.indicator == "left" then
	local sw = gw*0.03
	local sx = gx
	layout["sw"] = sw
	layout["sx"] = sx
end


return layout
end

function Label:drawBg(index,state,wtype)
	local e = self:layout(index, wtype)
	local grad_start, grad_end
	
	if self.properties.indicator == "right" then
		cairo_rectangle_round_right(self.cr, e.gx, e.gy, e.gw, e.gh,5);
		grad_end = 1.0
		grad_start = 1.0
	elseif self.properties.indicator == "left" then
		cairo_rectangle_round_left(self.cr, e.gx, e.gy, e.gw, e.gh,5);
		grad_start = 1.0
		grad_end = 1.0
	end

	--local linpat = cairo_pattern_create_linear( e.gx, e.gy, e.gx+e.gw, e.gy)
	--cairo_pattern_add_color_stop_rgba(linpat, grad_end,   theme.rgb_to_r_g_b(self.properties.bg["default"],0.4))
	--cairo_pattern_add_color_stop_rgba(linpat, grad_start, theme.rgb_to_r_g_b(self.properties.bg["default"],0.4))
	--cairo_set_source(self.cr, linpat)
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg["default"],0.4))
	cairo_fill(self.cr)
	
	--linha indicadora lateral
	if self.properties.indicator == "right" then
		cairo_rectangle_round_right(self.cr, e.sx, e.gy, e.sw, e.gh,5);
	elseif self.properties.indicator == "left" then
		cairo_rectangle_round_left(self.cr, e.sx, e.gy, e.sw, e.gh,5);
	end

	-- calculando cor da barra lateral 
	if type(state) == "string" then
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[state], 1.0))
	-- if its is number, is one of the continuous states
	elseif type(state) == "number" then
		local cor_r, cor_g, cor_b =  theme.stateToRGB(state)
		cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 1.0)
	end
	cairo_fill(self.cr)
end

function Label:textWidget(index,title,text,state)
	local e = self:layout(index,"textWidget")
	self:drawBg(index,state,"textWidget")

	--self.text:Draw({text = title, height=e.th,  x=e.tx, y=e.ty, color = self.properties.fg["title"],})
	self.text:set("text", title)
	self.text:set("height",e.th)
	self.text:set("x",e.tx)
	self.text:set("y", e.ty)
	self.text:set("color", self.properties.fg["title"])
	self.text:show()
	--self.text:Draw({text = text,  height=e.th2, x=e.tx2,y=e.ty2, color = self.properties.fg["description"],})
	self.text:set("text", text)
	self.text:set("height",e.th2)
	self.text:set("x",e.tx2)
	self.text:set("y", e.ty2)
	self.text:set("color", self.properties.fg["description"])
	self.text:show()
end

--[[
formato do data
data = {
	label1 = valor entre 0 e 100,
	label2 = valor entre 0 e 100,
	.
	.
	.
	labeln = valor entre 0 e 100,
}

na conf
]]--
function Label:singleGraph(index,title,data,ltype)
	local e = self:layout(index,"singleGraph")
	local state = 0
	for dn, value in pairs(data) do
		state=state+value
	end
	self:drawBg(index,state,"singleGraph")
	-- texto de titulo do grafico
	local title =  string.gsub(title,"_"," ")
	--self.text:Draw({text = title, height=e.th,  x=e.tx, y=e.ty, color = self.properties.fg["title"],})
	self.text:set("text", title)
	self.text:set("height",e.th)
	self.text:set("x",e.tx)
	self.text:set("y", e.ty)
	self.text:set("color", self.properties.fg["title"])
	self.text:show()
	-- plotando fundo
	cairo_rectangle(self.cr, e.grtx, e.grty, e.grtw, e.grth);
	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.fg["outline"], 0.7))
	cairo_set_line_width (self.cr, self.properties.lw)
	cairo_stroke(self.cr);
	local x = 0
	-- plotting each data bar
	for dn, value in pairs(data) do
		local dx = e.grtw*(value/100)
		cairo_rectangle(self.cr, e.grtx+x, e.grty, dx, e.grth);
		cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg["bg"], 1.0))
		cairo_fill(self.cr)
		x = x + dx
	end

	-- plotting each data bar label
	local tx = 0
	for dn, value in pairs(data) do
		-- square box, same color as above
		cairo_rectangle(self.cr, e.grtx+tx, e.grty2, e.grth, e.grth);
		cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg[dn], 1.0))
		cairo_fill(self.cr)
		-- text label with data source name
		local lname = string.gsub(dn,ltype..".",'')
		--local exts = self.text:Draw({text = lname, height=e.th, x=e.grtx+tx+e.grth+2*self.properties.lw, y=e.ty2 })
		self.text:set("text", lname)
		self.text:set("height", e.th)
		self.text:set("x", e.grtx+tx+e.grth+2*self.properties.lw)
		self.text:set("y", e.ty2)
		local exts = self.text:show()
		tx = tx + e.grth + tonumber(exts.width)
	end
end

function Label:dualGraph(index,title,data)
	local e = self:layout(index,"dualGraph")
	local vals = {}
	for dn, value in pairs(data) do
		vals[#vals+1] = value
	end
	local state = math.max(unpack(vals))
	self:drawBg(index,state,"dualGraph")
	-- texto de titulo do grafico
	local title =  string.gsub(title,"_"," ")
	--self.text:Draw({text = title, height=e.th,  x=e.tx, y=e.ty, color = self.properties.fg["title"],})
	self.text:set("text", title)
	self.text:set("height",e.th)
	self.text:set("x",e.tx)
	self.text:set("y", e.ty)
	self.text:set("color", self.properties.fg["title"])
	self.text:show()
	-- plotting each data bar
	cairo_set_line_width (self.cr, self.properties.lw)
	local gi = 1
	for dn, value in pairs(data) do
		-- plotando fundo
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[dn], 0.7))
		cairo_rectangle(self.cr, e.grtx, e.grty[gi], e.grtw, e.grth);
		cairo_stroke(self.cr);
		-- indicator value
		local dx = e.grtw*(value/100)
		cairo_rectangle(self.cr, e.grtx, e.grty[gi], dx, e.grth);
		cairo_fill(self.cr)
		gi = gi + 1
	end
end

function Label:lineGraph(index,title,data)
	local e = self:layout(index,"lineGraph")
	local state = 100-data
	self:drawBg(index,state,"lineGraph")
	-- texto de titulo do grafico
	local title =  string.gsub(title,"_"," ")
	--self.text:Draw({text = title, height=e.th,  x=e.tx, y=e.ty, color = self.properties.fg["title"],})
	self.text:set("text", title)
	self.text:set("height",e.th)
	self.text:set("x",e.tx)
	self.text:set("y", e.ty)
	self.text:set("color", self.properties.fg["title"])
	self.text:show()
	-- plotando fundo
	cairo_rectangle(self.cr, e.grtx, e.grty, e.grtw, e.grth);
	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg["bg"], 0.7))
	cairo_set_line_width (self.cr, self.properties.lw)
	cairo_fill(self.cr)

	-- plotting the data bar
	local dx = e.grtw*(data/100)
	cairo_rectangle(self.cr, e.grtx, e.grty, dx, e.grth);
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg["value"], 1.0))
	cairo_fill(self.cr)
end


function Label:imageGraph(index,title,text,state,imagefile)
	local e = self:layout(index,"imageGraph")
	self:drawBg(index,state,"imageGraph")

	-- draw imagefile
	local image = cairo_image_surface_create_from_png(imagefile)

	-- image size
	local w = cairo_image_surface_get_width(image)
	local h = cairo_image_surface_get_height(image)
	cairo_save(self.cr)
	-- image maximum size calculation
	-- test
	cairo_translate(self.cr,e.imgx,e.imgy)
	local w_ratio = e.imgw/w
	local h_ratio = e.imgh/h
	local scale = math.min(w_ratio, h_ratio)
	cairo_scale(self.cr, scale, scale);
	cairo_set_source_surface(self.cr, image, 0, 0);
	
	cairo_paint(self.cr)
	cairo_surface_destroy(image)
	cairo_restore(self.cr)

	--self.text:Draw({text = title, height=e.th,  x=e.tx, y=e.ty, color = self.properties.fg["title"],})
	self.text:set("text", title)
	self.text:set("height",e.th)
	self.text:set("x",e.tx)
	self.text:set("y", e.ty)
	self.text:set("color", self.properties.fg["title"])
	self.text:show()
	--self.text:Draw({text = text ,  height=e.th2, x=e.tx2,y=e.ty2, color = self.properties.fg["description"],})
	self.text:set("text", text)
	self.text:set("height",e.th2)
	self.text:set("x",e.tx2)
	self.text:set("y", e.ty2)
	self.text:set("color", self.properties.fg["description"])
	self.text:show()
end
return Label
