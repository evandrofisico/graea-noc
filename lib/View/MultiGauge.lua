package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local MultiGauge = {}
MultiGauge.__index = MultiGauge

setmetatable(MultiGauge, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function MultiGauge.new(p)
	if conky_window == nil then 
		return 
	end
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
	        color = p.fg["label"],
	        alpha = 1.0,
		shadow = true,
		shadowalpha = 0.2,
		shadowcolor = 0x000000,
	}

	local text = DrawText:new(txtconfig,cairo_cr)
	return setmetatable({ properties = p, cs = cs, cr = cairo_cr, text = text ,internal_cairo = internal_cairo}, MultiGauge)
end

function MultiGauge:destroy()
if self.internal_cairo then
	-- modificando para tentar gerar imagem 
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
else
	-- local pngsurf = cairo_image_surface_create(CAIRO_FORMAT_RGB24, conky_window.width, conky_window.height)
	-- local cr = cairo_create(pngsurf)
	-- cairo_set_source_surface(cr, self.cs,  0, 0)
	-- cairo_paint(cr)
	-- cairo_surface_write_to_png(pngsurf, "teste_saida.png")
	cairo_destroy(cr)
	cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
	cairo_surface_destroy(pngsurf)
end
end


function MultiGauge:InsertPoints(name,data)
	self.properties[name] = data
end

function MultiGauge:layout()
	-- graph
	--local start_theta = math.pi*(9/8)
	--local end_theta = math.pi/2
	local start_theta = math.pi/4
	local end_theta = 3*math.pi/2
	local label_angle = math.pi/4
	local gh = conky_window.height
	local gw = gh
	local gxc = gw/2
	local gyc = gh/2
	-- graph -- data line (max data lines = 10)
	local lw = gh/(2*(self.properties.grid.max_dlines+0.5))
	local maxr = lw*self.properties.grid.max_dlines
	-- text
	local th = lw -- trigonometria eh magia!!!!
	local tx = gw
	local ty = gh/2*(1+math.sin(math.pi/4))

	return {
	start_theta = start_theta,
	end_theta = end_theta,
	label_angle = label_angle,
	gh = gh,
	gw = gw,
	gxc = gxc,
	gyc = gyc,
	lw = lw,
	maxr = maxr,
	th = th,
	tx = tx,
	ty = ty,
	}
end

function MultiGauge:drawTitle(title)
	local e = self:layout()
	self.text:set("text", title)
	self.text:set("height", e.th)
	self.text:set("x", e.gxc)
	self.text:set("y", e.lw)
	self.text:show()
	--self.text:Draw({text = title, height=e.th, x=e.gxc,y=e.lw})
end


function MultiGauge:drawNew(index,name,data)
	local e = self:layout()
	local pc_s = data.level/(data.max-data.min)
	local hue = 1.0-pc_s
	local state = 100-hue*100
        local arc_s = (5*math.pi/4)*pc_s
	local radius = e.maxr-(e.lw*index)
	-- bg
	-- hue:0, saturation:0, light minimo em 0.1 e subindo em unidades de indice,
	-- de forma que indicadores mais centrais tem cinzas mais claros
	local cor_r, cor_g, cor_b = colors.hsl_to_rgb(0.0, 0.0, 0.1+(index/30) )
	cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 1.0)
        cairo_set_line_width (self.cr, e.lw)
        cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
        cairo_new_sub_path(self.cr)
        cairo_arc(self.cr,e.gxc,e.gyc,radius,e.start_theta,e.end_theta)
        cairo_stroke(self.cr);
	-- arc
        cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_ROUND);
	local cor_r, cor_g, cor_b =  theme.stateToRGB(state)
	-- local cor_r, cor_g, cor_b = colors.hsl_to_rgb(hue*100, 0.96, 0.2)
	cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 1.0)
        cairo_set_line_width (self.cr, e.lw)
        cairo_arc(self.cr,e.gxc,e.gyc,radius,e.start_theta,e.start_theta+arc_s)
        cairo_stroke(self.cr);
	-- linha ate o texto
	---- -- calculo do inicio da linha 
	local line_sx = e.gxc+radius*math.cos(e.label_angle)
	local line_sy = e.gyc+radius*math.sin(e.label_angle)
	local line_ex = e.tx
	local line_ey = line_sy-(e.tx-line_sx)
	cairo_move_to(self.cr,line_sx,line_sy)
	cairo_line_to(self.cr,line_ex,line_ey)
        cairo_set_line_width (self.cr, e.lw/5)
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.fg["line"], 1.0))
        cairo_stroke(self.cr);
	-- texto do tipo de alerta
	--self.text:Draw({text=name..": "..tostring(math.floor(pc_s*100)).."%",height=e.th,x=line_ex,y=line_ey})
	self.text:set("text", name..": "..tostring(math.floor(pc_s*100)).."%")
	self.text:set("height", e.th)
	self.text:set("x", line_ex)
	self.text:set("y", line_ey)
	self.text:show()
end

return MultiGauge
