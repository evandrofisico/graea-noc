package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local ListItem = {}
ListItem.__index = ListItem


setmetatable(ListItem, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function ListItem.new(p,cairo)
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
local text = DrawText:new(txtconfig,cairo_cr)

return setmetatable({cr = cairo_cr, cs = cs, properties = p,text = text, internal_cairo = internal_cairo}, ListItem)
end

function ListItem:destroy()
if self.internal_cairo then
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
else
	cairo_destroy(cr)
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
end
end

function ListItem:layout()
	-- label 
	local lw = self.properties.w
	local lh = 4*self.properties.h/5
	local lx = self.properties.x
	local ly = self.properties.y

	return {
	lw = lw,
	lh = lh,
	lx = lx,
	ly = ly,
		 }
end

--function ListItem:drawLabel(count,data,rank)
--	local e = self:layout()
--	local v,name,value,arc_start
--	local lhi = e.lh/count
--	local i = 0
--	local tsizes = {};
--	for name,value in pairs(data) do
--		-- bolinha com cor do tipo
--		cairo_arc(self.cr,e.lx+lhi,e.ly+lhi*i, (lhi/2)*0.8  ,0,2*math.pi)
--		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[name], 1.0))
--		cairo_fill(self.cr)
--		-- texto 
--		--local exts = self.text:Draw({text = name , height=lhi, x=e.lx+lhi*2,y=e.ly+lhi*(i+0.4)})
--		self.text:set("text", name )
--		self.text:set("height", lhi )
--		self.text:set("x", e.lx+lhi*2 )
--		self.text:set("y", e.ly+lhi*(i+0.4) )
--		local exts = self.text:show()
--		local w = tonumber(exts.width)
--		i = i+1
--		tsizes[i] = w
--	end
--	local w = math.max(unpack(tsizes))
--	local i = 0
--	for name,value in pairs(data) do
--		self.text:Draw({text = value, height=lhi, x=e.lx+lhi*3+w,y=e.ly+lhi*(i+0.4)})
--		self.text:set("text", value )
--		self.text:set("height", lhi )
--		self.text:set("x", e.lx+lhi*3+w )
--		self.text:set("y", e.ly+lhi*(i+0.4) )
--		self.text:show()
--		i = i+1
--	end
--
--end

function ListItem:drawLabel(count,data,rank)

	local idata = {}
	for i,v in pairs(data) do
		if rank then
			idata[#idata+1] = { name = i, value = tonumber(v) }
		else
			idata[#idata+1] = { name = i, value = v }
		end
	end
	local e = self:layout()
	local v,name,value,arc_start
	local lhi = e.lh/count
	local i = 0
	local tsizes = {};
	if rank then
		table.sort(idata, function (a,b) return a.value > b.value end)
	end
	-- convert data table to a iter

	--for name,value in pairs(data) do
	for ind=1,#idata do
		name = idata[ind].name
		value = idata[ind].value
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
		local w = tonumber(exts.width)
		i = i+1
		tsizes[i] = w
	end
	local w = math.max(unpack(tsizes))
	local i = 0
	--for name,value in pairs(data) do
	for ind=1,#idata do
		name = idata[ind].name
		value = idata[ind].value
		self.text:Draw({text = value, height=lhi, x=e.lx+lhi*3+w,y=e.ly+lhi*(i+0.4)})
		self.text:set("text", value )
		self.text:set("height", lhi )
		self.text:set("x", e.lx+lhi*3+w )
		self.text:set("y", e.ly+lhi*(i+0.4) )
		self.text:show()
		i = i+1
	end

end

return ListItem
