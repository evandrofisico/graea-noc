package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local Label = require('view.Label')

local SquareCloud = {}
SquareCloud.__index = SquareCloud 
local SquareCloud_mt = { __index = SquareCloud }

setmetatable(SquareCloud, {
  __index = Label, -- this is what makes the inheritance work
})

setmetatable(SquareCloud, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function SquareCloud.new(p,cairo)
        if conky_window == nil then
                return
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
	local text = DrawText:new(txtconfig, cairo_cr)
	return setmetatable({cr = cairo_cr, cs = cs, properties = p,text = text, internal_cairo = internal_cairo}, SquareCloud_mt)
end

function SquareCloud:layout(index,circlecount)
local layout = {} 

if index == nil then
	index = 0
end

if circlecount == nil then
	circlecount = 3
end
-- dom0 data
local dw = self.properties.w
local dh = self.properties.h

-- box
local bx = self.properties.x 
local by = self.properties.y
local bh = dh/self.properties.grid.y
local bw = dw/self.properties.grid.x
--local bw = conky_window.width-2*bx


-- calculo da posicao x e y
local function getCoords(id)
	--id = idd-1
	local xcord = math.floor(id/self.properties.grid.x)
	local ycord = math.floor(id/self.properties.grid.x)
	local yd , xd = math.modf(id/self.properties.grid.x)
	return yd, math.floor(xd*self.properties.grid.x)
end


local yindex, xindex = getCoords(index)


-- graph bg
local gh = bh*0.8
local gw = bw*0.95
local gx = bx+xindex*bw+bw*0.05
local gy = by+yindex*bh+bh*0.1

-- text title
local th = gh*0.80
local ty = by+gh*0.90+yindex*bh
local tx = bx+gw*0.09+xindex*bw


-- final label
local lw = self.properties.w
local lh = th
local lx = self.properties.x
local ly = self.properties.h
--local ly = self.properties.h-self.properties.border.y+lh*2

layout["lw"] = lw
layout["lh"] = lh  
layout["lx"] = lx  
layout["ly"] = ly  


-- semi-circulos das bordas
-- primeiro, raio a esquerda
local cr = gh/2
local cex = gx+cr
local cey = gy+cr
-- raio a direita
local cdx = gx+gw-cr
local cdy = cey

layout["cr"] = cr
layout["cex"] = cex
layout["cey"] = cey
layout["cdx"] = cdx
layout["cdy"] = cdy

-- data background
local dbgr=gh*0.4
layout["dbgr"] = dbgr

-- data circles
local dr = gh*0.35
local dy = yindex*bh + bh*0.5
layout["dx"] = {}
local dx_s = cdx
--local dx_s = xindex*bw+bw*0.95
for i=0,circlecount do
	layout["dx"][i+1] = dx_s-dr*i*2
end

-- indicator
local sw = (gw-cr)*0.5
local sh = gh*0.1
local sx = bx+xindex*bw+bw*0.1
local sy = by+yindex*bh+bh*0.04


layout["dy"] = dy
layout["dr"] = dr

layout["sw"] = sw
layout["sh"] = sh
layout["sx"] = sx
layout["sy"] = sy

layout["bx"] = bx 
layout["by"] = by
layout["bh"] = bh
layout["bw"] = bw

layout["gh"] = gh
layout["gw"] = gw
layout["gx"] = gx
layout["gy"] = gy

layout["tx"] =    tx 
layout["th"] =    th 
layout["ty"] =    ty 

return layout
end


function SquareCloud:drawBg(index,state)
	local e = self:layout(index)
	local grad_start, grad_end
	
	if self.properties.indicator == "right" then
		grad_end = 1.0
		grad_start = 1.0
	elseif self.properties.indicator == "left" then
		grad_start = 1.0
		grad_end = 1.0
	end

	cairo_new_sub_path(self.cr)

	cairo_arc(self.cr,e.cex,e.cey, e.cr ,(3/2)*math.pi+math.pi,(3/2)*math.pi)
	cairo_arc(self.cr,e.cdx,e.cdy, e.cr ,(3/2)*math.pi,(3/2)*math.pi+math.pi)

	cairo_close_path(self.cr)

	--local linpat = cairo_pattern_create_linear( e.gx, e.gy, e.gx+e.gw, e.gy)
	--cairo_pattern_add_color_stop_rgba(linpat, grad_end,   theme.rgb_to_r_g_b(self.properties.bg["default"],0.4))
	--cairo_pattern_add_color_stop_rgba(linpat, grad_start, theme.rgb_to_r_g_b(self.properties.bg["default"],0.4))
	--cairo_set_source(self.cr, linpat)
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg["default"],0.4))
	cairo_fill(self.cr)

        cairo_set_line_width (self.cr, 5)
        cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
	
	--linha indicadora lateral
	if self.properties.indicator == "right" then
		cairo_arc(self.cr,e.cdx,e.cdy, e.cr ,(3/2)*math.pi,(3/2)*math.pi+math.pi)
		cairo_move_to(self.cr, e.gx+e.gw-e.sw, e.gy)
		cairo_line_to(self.cr, e.gx+e.gw-e.cr,e.gy )
		grad_start = 0.02
		grad_end = 1.0
	elseif self.properties.indicator == "left" then
		cairo_arc(self.cr,e.cex,e.cey, e.cr ,(3/2)*math.pi+math.pi,(3/2)*math.pi)
		cairo_move_to(self.cr, e.gx+e.sw, e.gy)
		cairo_line_to(self.cr, e.gx+e.cr,e.gy )
		grad_end = 0.02
		grad_start = 1.0
	end

	-- calculando cor da barra lateral 
	if type(state) == "string" then
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[state], 1.0))
	-- if its is number, is one of the continuous states
	elseif type(state) == "number" then
		local cor_r, cor_g, cor_b =  theme.stateToRGB(state)
		cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 1.0)
	end
	--cairo_fill(self.cr)
	cairo_stroke(self.cr)

end


function SquareCloud:drawData(index,sdata,title)
	-- get number of data items to display
	local itemcount = 0
	local data = {}

	for i=1,#self.properties.labelmap do
		local dn = self.properties.labelmap[i]
		if sdata[dn] ~= nil then
			itemcount = itemcount + 1
			if (dn == "outbound") or (dn == "inbound") then
				data[dn] = sdata[dn]
			else
				data[dn] = 100-sdata[dn]
			end
		end
	end

	local e = self:layout(index,itemcount)

	local state = 0
	self:drawBg(index,state)

	if itemcount >0 then
		local cex = e.cdx-(2*itemcount-2)*e.dr
		cairo_new_sub_path(self.cr)
		cairo_arc(self.cr,cex,e.cey, e.dbgr ,(3/2)*math.pi+math.pi,(3/2)*math.pi)
		cairo_arc(self.cr,e.cdx,e.cdy, e.dbgr ,(3/2)*math.pi,(3/2)*math.pi+math.pi)
		cairo_close_path(self.cr)
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg["DataBG"], 0.8))
		cairo_fill(self.cr)
	end
	
	-- texto de titulo do grafico
	local domainStr = '.' .. self.properties.mydomain
	local title =  string.gsub(title,domainStr," ")
	self.text:set("text", title)
	self.text:set("height",e.th)
	self.text:set("x",e.tx)
	self.text:set("y", e.ty)
	self.text:set("color", self.properties.fg["label"])
	self.text:show()


	-- pie chart graphs
	for i=1,#self.properties.labelmap do
		local item = self.properties.labelmap[i]
		local value = data[item]
		if value == nil then
			return nil
		end
		--graph bg
		cairo_new_sub_path(self.cr)
		cairo_arc(self.cr,e.dx[i],e.dy, e.dr ,0,2*math.pi)
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[item], 0.2))
		cairo_fill(self.cr)
		cairo_set_operator(self.cr,CAIRO_OPERATOR_OVER)
		-- graph data
		local arc, start_arc, end_arc
		arc = 2*math.pi*(value/100)
		start_arc = (3/2)*math.pi - arc/2
		end_arc   = (3/2)*math.pi + arc/2
		-- plotting
		cairo_new_sub_path(self.cr)
		cairo_arc(self.cr,e.dx[i],e.dy, e.dr ,start_arc,end_arc)
		cairo_line_to(self.cr, e.dx[i],e.dy )
		cairo_close_path(self.cr)
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[item], 1.0))
        	--cairo_set_line_width (self.cr, 10)
        	--cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
		--cairo_stroke(self.cr)
		cairo_fill(self.cr)
		i = i + 1
	end
end


function SquareCloud:drawLabels(itens)
local e = self:layout(0)
local tx = e.lh/2

--for dn, value in pairs(itens) do
for i=#itens,1,-1 do
	dn = itens[i]
	--print(dn,tx)
	-- square box, same color as above
	cairo_arc(self.cr,e.lx+tx ,e.ly-e.lh/2, (e.lh/2)*0.8  ,0,2*math.pi)
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg[dn], 1.0))
	cairo_fill(self.cr)
	-- text label with data source name
	--local exts = self.text:Draw({text = dn, sizeby = 'height', height=e.lh*0.8, x=e.lx+tx+e.lh*0.5, y=e.ly-0.25*e.lh })
	self.text:set("text", dn)
	self.text:set("sizeby", 'height')
	self.text:set("height", e.lh*0.8)
	self.text:set("x", e.lx+tx+e.lh*0.5)
	self.text:set("y", e.ly-0.25*e.lh)
	local exts = self.text:show()
	tx = tx + 2*e.lh + tonumber(exts.width)
	-- tx = tx + e.lh + tonumber(exts.width)+4*e.lw
end
end


function SquareCloud:destroy()
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

return SquareCloud
