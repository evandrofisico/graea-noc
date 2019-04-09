package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')
local Mapa = {}
local Mapa_mt = { __index = Mapa }


function Mapa:new(p,cairo)
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

local text = DrawText:new({
        text="test",
        fontname = p.font,
        sizeby = 'width',
        color = p.fg["title"],
        alpha = theme.text["alpha"],
	shadow = theme.text["shadow"],
	shadowalpha = theme.text["shadowalpha"],
	shadowcolor = theme.text["shadowcolor"],
	width = math.abs(conky_window.width - p.max_w)/2
},cairo_cr)
_G.currentgroup = 1
return setmetatable({cr = cairo_cr, cs = cs, properties = p, text = text, internal_cairo = internal_cairo}, Mapa_mt)
end

function Mapa:destroy()
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
	cairo_surface_destroy(pngsurf)
end
end



function Mapa:ConvertPointData(x,y)
cx =  (x)*self.properties.scale+self.properties.border.x
cy =  (907 - y )*self.properties.scale+self.properties.border.y
return cx, cy
end


function Mapa:DrawPoint(unit,state,psize)
local lat = self.properties['location'][unit].lat
local long =self.properties['location'][unit].long
local size = math.log(psize or 256)
px,py = self:ConvertPoint(lat,long)	
cairo_new_path(self.cr)
cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.fg["border"], 0.8))
cairo_set_line_width (self.cr, 2)
cairo_arc(self.cr,  px,  py, size, 0, 2*math.pi)
cairo_stroke_preserve(self.cr);
-- if its a string, is one of the discrete color states
if type(state) == "string" then
	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[state], 1.0))
-- if its is number, is one of the continuous states
elseif type(state) == "number" then
	local cor_r, cor_g, cor_b = theme.stateToRGB(state)
	cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 0.8)
end
cairo_fill(self.cr);
end

function Mapa:DrawLabel(unit,state,uni)
local lat = self.properties['location'][unit].lat
local long =self.properties['location'][unit].long
-- color
local colorstate_r, colorstate_g, colorstate_b
-- calculando cor da barra lateral 
if type(state) == "string" then
	--cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[state], 1.0))
	colorstate_r, colorstate_g, colorstate_b = theme.rgb_to_r_g_b(self.properties.bg[state])
-- if its is number, is one of the continuous states
elseif type(state) == "number" then
	colorstate_r, colorstate_g, colorstate_b =  theme.stateToRGB(state)
end

px,py = self:ConvertPoint(lat,long)	
cairo_new_path(self.cr)
cairo_set_line_join(self.cr, CAIRO_LINE_JOIN_ROUND); 
-- posicao final
local line_len = math.abs(conky_window.width - self.properties.max_w)/2
local fx2 = line_len + self.properties.border.x + self.properties.max_w 
local fy2 = (conky_window.height/self.properties.grid.y)*uni+(conky_window.height/self.properties.grid.y)*0.1
local fx1 = self.properties.max_w + self.properties.border.x
local fy1 = (conky_window.height/self.properties.grid.y)*uni
local lh = (conky_window.height/self.properties.grid.y)
-- desenhando linha 
cairo_set_source_rgba(self.cr,colorstate_r, colorstate_g, colorstate_b, 1.0)
cairo_move_to(self.cr, px, py )
if uni%2==0 then
	cairo_line_to(self.cr, fx1, fy2 )
	cairo_move_to(self.cr, fx1, fy2 )
	cairo_rel_line_to(self.cr, line_len, 0 )
	fx=fx2
	fy=fy2
else
	cairo_line_to(self.cr, fx1, fy1 )
	cairo_move_to(self.cr, fx1, fy1 )
	--cairo_rel_line_to(self.cr, line_len*0.7, 0 )
	fx=fx1
	fy=fy1
end
cairo_set_line_width (self.cr, 2)
cairo_stroke_preserve(self.cr);
cairo_new_sub_path(self.cr)

if self.properties.indicator == "right" then
	cairo_rectangle_round_right(self.cr, fx, fy-lh*0.8,line_len*0.9 , 1.8*lh,5);
elseif self.properties.indicator == "left" then
	cairo_rectangle_round_left(self.cr, fx, fy-lh*0.8,line_len*0.9 , 1.8*lh,5);
	--cairo_rectangle_round_left(self.cr, e.gx, e.gy, e.gw, e.gh,5);
end


if theme.style == "fill" then
	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg["default"], 0.4))
	cairo_fill(self.cr)
elseif theme.style == "line" then
	cairo_set_line_width (self.cr, 1)
	cairo_set_source_rgba(self.cr, colorstate_r, colorstate_g, colorstate_b, 1.0)
	cairo_stroke(self.cr);
end



--linha indicadora lateral
if self.properties.indicator == "right" then
	cairo_rectangle_round_right(self.cr, fx, fy-lh*0.8,0.05*line_len , 1.8*lh,5);
elseif self.properties.indicator == "left" then
	cairo_rectangle_round_left(self.cr, fx, fy-lh*0.8,0.05*line_len , 1.8*lh,5);
end
cairo_set_source_rgba(self.cr, colorstate_r, colorstate_g, colorstate_b, 1.0)
cairo_fill(self.cr)


-- desenhando nome da unidade
ua_name = string.gsub(unit,"_"," ")
self.text:Draw({sizeby = 'height', text = ua_name , height = lh*0.9, x=fx+0.10*line_len,y=fy})
self.text:Draw({sizeby = 'height', text = self.properties['location'][unit].design , height = lh*0.8, x=fx+0.15*line_len,y=fy+30})
end

function Mapa:DrawShape(uf,state)
-- color
local colorstate_r, colorstate_g, colorstate_b
-- calculando cor da barra lateral 
if type(state) == "string" then
	--cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[state], 1.0))
	colorstate_r, colorstate_g, colorstate_b = theme.rgb_to_r_g_b(self.properties.bg[state])
-- if its is number, is one of the continuous states
elseif type(state) == "number" then
	colorstate_r, colorstate_g, colorstate_b =  theme.stateToRGB(state)
end

cairo_new_path(self.cr)
cairo_move_to(self.cr, self.properties.mapa[uf][1].x, self.properties.mapa[uf][1].y )

for i=1,#self.properties.mapa[uf]-1 do
	cairo_line_to(self.cr,  self.properties.mapa[uf][i].x,  self.properties.mapa[uf][i].y )
end
cairo_close_path(self.cr);
-- se tema eh preenchido, setar cor de borda normal e preencher formas,
-- caso contrario, apenas desenhar o outline com a cor especificada
if theme.style == "fill" then
	cairo_set_line_width (self.cr, 4)
 	cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.fg["border"], 0.8))
 	cairo_stroke_preserve(self.cr);
	cairo_set_source_rgba(self.cr, colorstate_r, colorstate_g, colorstate_b, 1.0)
	cairo_fill(self.cr);
elseif theme.style == "line" then
	cairo_set_line_width (self.cr, 4)
	cairo_set_source_rgba(self.cr, colorstate_r, colorstate_g, colorstate_b, 1.0)
	cairo_stroke(self.cr);
end

-- cairo_set_source_rgba(self.cr, colorstate_r, colorstate_g, colorstate_b, 1.0)
-- cairo_fill(self.cr);
end


function Mapa:NextGroup()
if self.properties.services[_G.currentgroup+2] == nil then
	_G.currentgroup = 1
else
	_G.currentgroup = _G.currentgroup+1
end
end

function Mapa:CurrentGroup()
return self.properties.services[_G.currentgroup]
end
return Mapa
