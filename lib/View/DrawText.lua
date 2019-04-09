local DrawText = {}
local DrawText_mt = { __index = DrawText }

function DrawText:new(p,cairo)
        if conky_window == nil then
                return
        end
	local cairo_cr, cs
	local internal_cairo
	if cairo == nil then
        	cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
        	cairo_cr = cairo_create(cs)
		internal_cairo = true
	else
        	cairo_cr = cairo
		internal_cairo = false
	end
	return setmetatable({cr = cairo_cr, cs = cs, properties = p, internal_cairo = internal_cairo}, DrawText_mt)
end

function DrawText:Draw(prop)
	for name,value in pairs(prop) do
		self.properties[name] = value
	end	
	return self:show()
end

function DrawText:set(propname,value)
	self.properties[propname] = value
end


function DrawText:Extents(prop)
	for name,value in pairs(prop) do
		self.properties[name] = value
	end	
	return self:GetExtents()
end

function DrawText:shadow(extents)
	-- raio do circulo de shadow deve ser calculado com base
	-- 	tamanho total da fonte, chutamos inicialmente como 1/0
	-- 	da altura
	local S_r = extents.height/10
	-- quantidades de instancias do texto fixados na mao, 8
	local TextInst = 8
	local TextRadStep = 2*math.pi/TextInst
	-- definindo cor da sombra
	if self.properties.shadowcolor == nil then
		self.properties.shadowcolor = 0x494949
		self.properties.shadowalpha = 0.4
	end
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.shadowcolor, self.properties.shadowalpha))
	for i=0,TextInst do
		local x = self.properties.x + S_r*math.cos(TextRadStep*i)
		local y = self.properties.y + S_r*math.sin(TextRadStep*i)
		-- shadow feita como um circulo do proprio texto semi-transparente
		cairo_move_to(self.cr, x , y)
		-- rotate text
		if self.properties.rotation ~= nil then
			cairo_save(self.cr)
			cairo_rotate(self.cr, self.properties.rotation)
			cairo_show_text(self.cr, self.properties.text)
			cairo_restore(self.cr)
		else
			cairo_show_text(self.cr, self.properties.text)
		end
		--self.properties.rotation = nil
	end
end


function DrawText:GetExtents()
	-- defining size
	local font_size
	local extents = cairo_text_extents_t:create()
	local test_font_size = 1000.0
	if self.properties.sizeby == "size" then
		font_size = self.properties.size
		cairo_select_font_face(self.cr, self.properties.fontname, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
		cairo_set_font_size(self.cr, font_size)
	elseif  self.properties.sizeby == "height" then
		local sampletext = 'abcdetFgGiLl'
		-- get dimensions for our selected font
		cairo_select_font_face(self.cr, self.properties.fontname, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
		cairo_set_font_size(self.cr, test_font_size)
		cairo_text_extents(self.cr, sampletext, extents)
		local h = math.abs(extents.height)
		local scale = (self.properties.height/h)
		font_size = scale * test_font_size
	elseif self.properties.sizeby == "width" then
		local sampletext = self.properties.text
		-- get dimensions for our selected font
		cairo_select_font_face(self.cr, self.properties.fontname, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
		cairo_set_font_size(self.cr, test_font_size)
		cairo_text_extents(self.cr, sampletext, extents)
		local w = math.abs(extents.width)
		local scale = (self.properties.width/w)
		font_size = scale * test_font_size
	end
	return font_size,extents
end


function DrawText:show()
	local font_size, extents = self:GetExtents()
	cairo_set_font_size(self.cr, font_size)
	-- setting text extents
	cairo_text_extents(self.cr, self.properties.text, extents)
	-- move to position
	if self.properties.shadow then
		self:shadow(extents)
	end
	-- defining color
	cairo_new_sub_path(self.cr)
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.color, self.properties.alpha))
	cairo_move_to(self.cr, self.properties.x , self.properties.y)
	--print(self.properties.text, self.properties.rotation)
	if self.properties.rotation ~= nil then
		cairo_save(self.cr)
		cairo_rotate(self.cr, self.properties.rotation)
		cairo_show_text(self.cr, self.properties.text)
		cairo_restore(self.cr)
	else
		cairo_show_text(self.cr, self.properties.text)
	end
	self.properties.rotation = nil

	if self.internal_cairo then
		cairo_destroy(self.cr)
	end
	return extents
end

return DrawText
