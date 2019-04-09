package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local Graph = {}
Graph.__index = Graph

setmetatable(Graph, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function Graph.new(p)
	if conky_window == nil then 
		return 
	end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	local cairo_cr = cairo_create(cs)
	local textconf = {
                text="test",
                fontname = p.font,
                sizeby = 'height',
                color = p.fg["label"],
                alpha = 1.0,
                shadow = true,
                shadowalpha = 0.5,
                shadowcolor = p.fg["shadow"],
	}
        local text = DrawText:new(textconf,cairo_cr)
	return setmetatable({ properties = p, cs = cs, cr = cairo_cr, text = text }, Graph)
end

function Graph:destroy()
        cairo_destroy(self.cr)
end


function Graph:InsertPoints(name,data)
	self.properties[name] = data
end

function Graph:layout()
	-- graph
	local wratio = 0.7
	local gh = self.properties.h-2*self.properties.margin
	local gw = (self.properties.w-3*self.properties.margin)*wratio -- the other 0.3 goes into the labels
	local gx = self.properties.x+self.properties.margin
	local gy = self.properties.y+self.properties.margin

	-- label 
	local lw = (self.properties.w-3*self.properties.margin)*(1-wratio)
	local lh = gh
	local lx = self.properties.x+2*self.properties.margin+gw
	local ly = self.properties.y+self.properties.margin

	return {
	gh = gh,
	gw = gw,
	gx = gx,
	gy = gy,
	lw = lw,
	lh = lh,
	lx = lx,
	ly = ly,
		 }
end

function Graph:drawGraph(title,datatitle,data)
	self:totalData(data)
	self:drawPie(data)
	self:drawLabel(data)
	self:drawTitle(title,datatitle)
end


function Graph:drawTitle(title)
	local e = self:layout()
	self.text:set("text", title )
	self.text:set("x", self.properties.x+self.properties.margin )
	self.text:set("y", self.properties.y )
	self.text:set("height", self.properties.margin )
	self.text:show()
end

--[[
formato de data:
data = {
	tipo1 = valor numerico,
	tipo2 = valor numerico,
	.
	.
	.
	tipon = valor numerico,
}
--]]

function Graph:getMax(data)
-- get normalization constant for our total data
local maxval = {}
local alltimemax = {}
for xdata=1,#data do
	for label,value in pairs(data[xdata]) do
		if type(value) == "number" then
			maxval[#maxval+1] = value
		end
	end
end

return math.max(unpack(maxval))
end

function Graph:plotAxis()
local e = self:layout()
-- plot axis
cairo_move_to(self.cr, e.gx, e.gy )
cairo_line_to(self.cr, e.gx, e.gy+e.gh)
cairo_line_to(self.cr, e.gx+e.gw, e.gy+e.gh)
cairo_set_line_width (self.cr, 4)
cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.fg["label"], 1.0))
cairo_stroke(self.cr);
end

function Graph:drawData(data)
-- use the maximum value as a scale for all other data to
-- plot.
local maxint = self:getMax(data)
-- plot axis
self:plotAxis()


local e = self:layout()
local yscale = (e.gh/maxint)*0.95
local xscale = (e.gw/(#data))*0.95

-- Ugly and strange way to call a function, yes, I know
-- If someone finds a better way to change it based on
-- a flag on the configuration file that does not involves
-- a large if block or a pseudo switch/case using tables,
-- send a patch!
self["draw"..self.properties.graphstyle](self,data,xscale,yscale)
self:XTicks(data,xscale,yscale)
end


function Graph:drawBars(data,xscale,yscale)
local e = self:layout()
-- we only plot labels from our config, so...
for xdata=1,#data do
	local lasth = {}
	for i=1,#self.properties.datanames do
		local dname = self.properties.datanames[i]
		if ( lasth[xdata] == nil ) then
			lasth[xdata] = 0
		end
		cairo_rectangle(self.cr, e.gx+(xdata-0.9)*xscale, e.gy+(e.gh-data[xdata][dname]*yscale-lasth[xdata]) , xscale*0.8, data[xdata][dname]*yscale);
		--cairo_line_to(self.cr, e.gx+(xdata-1)*xscale, e.gy+(e.gh-data[xdata][dname]*yscale ))
		--cairo_set_line_width (self.cr, 2)
		cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg[dname], 1.0))
		cairo_fill(self.cr);
		-- if it is a barbg == all data summed, do not sum it's heigth
		if self.properties.drawstyles[dname] ~= "barbg" then
			lasth[xdata] = lasth[xdata] +  data[xdata][dname]*yscale
		end
	end
end
end


function Graph:drawLines(data,xscale,yscale)
local e = self:layout()
-- we only plot labels from our config, so...
for i=1,#self.properties.datanames do
	local dname = self.properties.datanames[i]
	cairo_new_path(self.cr)
	local xdata=1
	if self.properties.drawstyles[dname] == "fill" then
		cairo_move_to(self.cr, e.gx, e.gy+e.gh )
		cairo_line_to(self.cr, e.gx+(xdata-1)*xscale, e.gy+(e.gh-data[xdata][dname]*yscale ))
	else
		cairo_move_to(self.cr, e.gx+(xdata-1)*xscale, e.gy+(e.gh-data[xdata][dname]*yscale ))
	end
	for xdata=2,#data do
		cairo_line_to(self.cr, e.gx+(xdata-1)*xscale, e.gy+(e.gh-data[xdata][dname]*yscale ))
	end
	if self.properties.drawstyles[dname] == "fill" then
		cairo_line_to(self.cr, e.gx+(#data-1)*xscale, e.gy+e.gh )
	end
	if self.properties.drawstyles[dname] == "fill" then
	 	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[dname], 0.4))
		cairo_fill(self.cr);
	else
		cairo_set_line_width (self.cr, 2)
		cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg[dname], 1.0))
		cairo_stroke(self.cr);
	end
end
end

function Graph:XTicks(data,xscale,yscale)
local e = self:layout()
self.text:set("y", e.gy+e.gh + 10 )
self.text:set("height", xscale*0.8 )
for xdata=1,#data do
	--self.text:Draw({text = value, height=lhi, x=e.lx+lhi*3+w,y=e.ly+lhi*(i+0.4)})
	local ticktext
	if self.properties.ticktransfunc ~= nil then
		ticktext = self.properties.ticktransfunc(data[xdata][self.properties.ticksource])
	else
		ticktext = data[xdata][self.properties.ticksource]
	end

	self.text:set("text", ticktext)
	self.text:set("x", e.gx+(xdata*xscale)-xscale*0.8 )
	self.text:set("rotation",(1/4)*math.pi)
	self.text:show()
	--print(data[xdata][self.properties.ticksource])
end
--self.text:set("rotation",nil)
end


function Graph:drawLabel(data)
local maxlabel = {}
local labelcount = 0 
local sumtotal = 0 
for xdata=1,#data do
	for label,value in pairs(data[xdata]) do
		if type(value) == "number" then
			if maxlabel[label] ~= nil then
				maxlabel[label][ #maxlabel[label]+1 ] = value
			--maxval[#maxval+1] = value
			else
				maxlabel[label] = {}
				labelcount = labelcount + 1
			end
		end
	end
end


local e = self:layout()
local v,name,value,arc_start
local lhi = e.lh/labelcount
local i = 0
local tsizes = {};
for name,valuearray in pairs(maxlabel) do
	local value = math.max(unpack(valuearray))
	-- bolinha com cor do tipo
	cairo_arc(self.cr,e.lx+lhi,e.ly+lhi*i, (lhi/2)*0.8  ,0,2*math.pi)
	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[name], 1.0))
	cairo_fill(self.cr)
	-- texto 
	self.text:set("text", name )
	self.text:set("height", lhi )
	self.text:set("x", e.lx+lhi*2 )
	self.text:set("y", e.ly+lhi*(i+0.4) )
	local exts = self.text:show()
	local w = tonumber(exts.width)
	i = i+1
	tsizes[i] = w
end

local w = math.max(unpack(tsizes))
local i = 0
for name,valuearray in pairs(maxlabel) do
	local value = math.max(unpack(valuearray))
	self.text:set("text", value )
	self.text:set("height", lhi )
	self.text:set("x", e.lx+lhi*3+w )
	self.text:set("y", e.ly+lhi*(i+0.4) )
	self.text:show()
	i = i+1
end
end

function Graph:destroy()
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
end

return Graph
