package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local PieChart = {}
PieChart.__index = PieChart

setmetatable(PieChart, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function PieChart.new(p)
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
	return setmetatable({ properties = p, cs = cs, cr = cairo_cr, text = text }, PieChart)
end

function PieChart:destroy()
        cairo_destroy(self.cr)
end


function PieChart:InsertPoints(name,data)
	self.properties[name] = data
end

function PieChart:layout()
	-- graph
	local gh = self.properties.h
	local gw = self.properties.h
	local gr = gh/2 
	local gir = gr*0.3
	local gx = self.properties.x+gr
	local gy = self.properties.y+gr
	-- text
	local tw = gr*2*math.cos(math.pi/4)
	local th = gr*math.sin(math.pi/4)/2
	local tx = gx-tw/2
	local ty = gy-th
	-- label 
	local lw = self.properties.w-gw
	local lh = 4*gh/5
	local lx = self.properties.x+gh
	local ly = self.properties.y+gh/5
	-- volumes --TODO
	return {
	tw = tw, 
	th = th,
	tx = tx,
	ty = ty,
	gh = gh,
	gr = gr,
	gir = gir,
	gx = gx,
	gy = gy,
	lw = lw,
	lh = lh,
	lx = lx,
	ly = ly,
		 }
end

function PieChart:drawPieChart(title,datatitle,data)
	self:totalData(data)
	self:drawPie(data)
	self:drawLabel(data)
	self:drawTitle(title,datatitle)
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

function PieChart:drawTitle(title,datatitle)
	local e = self:layout()
	--self.text:Draw({text = title, height=e.th, x=e.tx,y=e.ty+e.th})
	self.text:set("text", title )
	self.text:set("x", e.tx )
	self.text:set("y", e.ty+e.th )
	self.text:set("height", e.th )
	self.text:show()
	--self.text:Draw({text = self.total.." "..datatitle , height=e.th, x=e.tx,y=e.gy+e.th})
	self.text:set("text", self.total.." "..datatitle )
	self.text:set("height", e.th )
	self.text:set("x", e.tx )
	self.text:set("y", e.gy+e.th )
	self.text:show()
end

function PieChart:totalData(data)
	local total= 0;
	local types = 0;
	for i,v in pairs(data) do
		total = total + v
		types = types+1
	end
	self.total = total
	self.types = types
end

function PieChart:drawPie(data)
	local e = self:layout()
	local i,v,name,value,arc_start
	local arc_start = 0
	local lw = ((e.gr-e.gir)/self.types)
	for name,value in pairs(data) do
		local perc = 2*math.pi*(value/self.total)
		cairo_new_sub_path(self.cr)
		cairo_arc(self.cr,e.gx,e.gy, e.gr-lw/2 ,arc_start,arc_start+perc)
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[name], 1.0))
        	cairo_set_line_width (self.cr, lw)
        	cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
		cairo_stroke(self.cr)
		arc_start = arc_start+perc
	end
end

function PieChart:drawLabel(data)
	local e = self:layout()
	local v,name,value,arc_start
	local lhi = e.lh/self.types
	local i = 0
	local tsizes = {};
	for name,value in pairs(data) do
		-- bolinha com cor do tipo
		cairo_arc(self.cr,e.lx+lhi,e.ly+lhi*i, (lhi/2)*0.8  ,0,2*math.pi)
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[name], 1.0))
		cairo_fill(self.cr)
		-- texto 
		--local exts = self.text:Draw({text = name , height=lhi, x=e.lx+lhi*2,y=e.ly+lhi*(i+0.4)})
		self.text:set("text", name )
		self.text:set("height", lhi )
		self.text:set("x", e.lx+lhi*2 )
		self.text:set("y", e.ly+lhi*(i+0.4) )
		local exts = self.text:show()
		local jobperc = (value/self.total)*100
		local w = tonumber(exts.width)
		i = i+1
		tsizes[i] = w
	end
	local w = math.max(unpack(tsizes))
	local i = 0
	for name,value in pairs(data) do
		--self.text:Draw({text = value, height=lhi, x=e.lx+lhi*3+w,y=e.ly+lhi*(i+0.4)})
		self.text:set("text", value )
		self.text:set("height", lhi )
		self.text:set("x", e.lx+lhi*3+w )
		self.text:set("y", e.ly+lhi*(i+0.4) )
		self.text:show()
		i = i+1
	end

end

function PieChart:destroy()
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
end

return PieChart
