package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local weathericons = require('view.weatherIcons')

local ClockWidget = {}
ClockWidget.__index = ClockWidget 


setmetatable(ClockWidget, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function ClockWidget.new(p,cairo)
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
return setmetatable({cr = cairo_cr, cs = cs, properties = p, internal_cairo = internal_cairo}, ClockWidget)
end


function ClockWidget:draw()
        local hour = tonumber(conky_parse("${time %I}"))
        local minute = tonumber(conky_parse("${time %M}"))
        local seconds = tonumber(conky_parse("${time %S}"))
	local e = self.properties
        cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_ROUND);
        cairo_new_sub_path(self.cr)
        local arc_s = (2*math.pi/60)*seconds
        local arc_m = (2*math.pi/60)*minute+arc_s/60
        local arc_h = (2*math.pi/12)*hour+arc_m/12
        local arc_alpha = 1.0

        cairo_set_line_width (self.cr, e.lw)
        -- desenhando horas
        cairo_arc(self.cr,e.x,e.y,e.r-(e.lw),-math.pi/2,-math.pi/2+arc_h)
        cairo_set_source_rgba(self.cr,rgb_to_r_g_b(e.color_h, arc_alpha))
        cairo_stroke(self.cr);
        -- desenhando minutos
        cairo_arc(self.cr,e.x,e.y,e.r+(e.lw/2),-math.pi/2,-math.pi/2+arc_m)
        cairo_set_source_rgba(self.cr,rgb_to_r_g_b(e.color_m, arc_alpha))
        cairo_stroke(self.cr);
        cairo_arc(self.cr,e.x,e.y,e.r+(2*e.lw),-math.pi/2,-math.pi/2+arc_s)
        cairo_set_source_rgba(self.cr,rgb_to_r_g_b(e.color_s, arc_alpha))
        cairo_stroke(self.cr);

	local txtconf = {
                text="test",
                fontname = "LCARS",
                sizeby = 'size',
                color = e.color_d,
                alpha = 1.0,
                shadow = true,
                shadowalpha = 0.2,
                shadowcolor = 0x000000,
        }

       self.text = DrawText:new(txtconf, self.cr)


        --self.text:Draw({text = conky_parse("${time %H %M}"),  x = e.x-80, y = e.y+8, size = 110})
        --self.text:Draw({text = conky_parse("${time %b %d}"),  x = e.x-40, y = e.y+55, size = 50})
        self.text:set("text", conky_parse("${time %H %M}"))
	self.text:set("x", e.x-80)
	self.text:set("y", e.y+8)
	self.text:set("size", 110)
	self.text:show()
--
        self.text:set("text", conky_parse("${time %b %d}"))
	self.text:set("x", e.x-40)
	self.text:set("y", e.y+55)
	self.text:set("size", 50)
	self.text:show()
end

function ClockWidget:drawWeather(data)
local wicon
local e = self.properties
local time = tonumber(conky_parse("${time %s}"))
local tempicon = "  "
if ( time > tonumber(data.sunrise) and time < tonumber(data.sunset) ) then
-- it is still day!
	if data.iconcode == 800 then
		wicon = weathericons.sunny;
	else
		wicon = weathericons.iconcodeDay[data.iconcode].icocode
	end
else
-- it is night
	if data.iconcode == 800 then
		local phase = {
		[0] = "new",
		[1] = "old",
		[2] = "waning_crescent",
		[3] = "waning_quarter",
		[4] = "waning_gibbous",
		[5] = "full",
		[6] = "waxing_gibbous",
		[7] = "waxing_quarter",
		[8] = "waxing_crescent",
		[9] = "young",
		}
		-- get moon phase
		local pd = moonPhase()
		local pind = math.floor(pd/3)
		--wicon = weathericons.phase[weathericons.moonIcons[pind]]
		wicon = weathericons.moonIcons[phase[pind]]
		--return phase[pind]
	else
		wicon = weathericons.iconcodeNight[data.iconcode].icocode
	end
end
--self.text:Draw({text = wicon, fontname = "Weather Icons",  x = e.x/10, y = e.y*2.1, size = 50})
self.text:set("text", wicon )
self.text:set("fontname", "Weather Icons")
self.text:set("x", e.x-e.r)
--self.text:set("x", e.x/10)
self.text:set("y", e.y*2.1)
self.text:set("size", 50)
local exts = self.text:show()
local w = tonumber(exts.width)

self.text:set("text", math.floor(data.temp) .. '°C   '  .. data.humidity .. '%'   )
self.text:set("fontname", "LCARS")
self.text:set("x", e.x-e.r+w)
self.text:set("y", e.y*2.1)
self.text:set("size", 45)
self.text:show()
end



function ClockWidget:destroy()
if self.internal_cairo then
	-- modificando para tentar gerar imagem 
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
else
	-- --local pngsurf = cairo_image_surface_create(CAIRO_FORMAT_RGB24, conky_window.width, conky_window.height)
	-- --local cr = cairo_create(pngsurf)
	-- --cairo_set_source_surface(cr, self.cs,  0, 0)
	-- --cairo_paint(cr)
	-- --cairo_surface_write_to_png(pngsurf, "teste_saida.png")
	cairo_destroy(cr)
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
	--cairo_surface_destroy(pngsurf)
end
end

return ClockWidget
