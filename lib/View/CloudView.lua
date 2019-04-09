CloudView = {}
CloudView_mt = { __index = CloudView }

function CloudView:new(p)
	if conky_window == nil then 
		return 
	end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	local cairo_cr = cairo_create(cs)
        local text = DrawText:new({
                text="test",
                fontname = p.font,
                sizeby = 'width',
                color = p.fg["label"],
                alpha = 1.0,
                shadow = true,
                shadowalpha = 0.5,
                shadowcolor = p.fg["shadow"],
        },cairo_cr)
	return setmetatable({ properties = p, cs = cs, cr = cairo_cr, text = text }, CloudView_mt)
end

function CloudView:destroy()
        cairo_destroy(self.cr)
end


function CloudView:InsertPoints(name,data)
	self.properties[name] = data
end

function CloudView:layout(index)
--[[ if we dont pass any index, presume is the main circle
     which contains all the servers information
--]]
local gh = self.properties.h
local gw = self.properties.w
local grc = gw/2 
local gxc = self.properties.x+grc
local gyc = self.properties.h-grc-(self.properties.h-grc)*0.08
local labelh = (self.properties.h-grc)*0.07
local labely = self.properties.h-(self.properties.h-grc)*0.02
local labelx = self.properties.x
local alpha = (1-index)*math.pi/3
--local alpha = (1-index)*math.pi/3+(tonumber(conky_parse("${updates}"))/10)

if index == -1 then
-- the main circle is aligned to the bottom of the widget
	-- graph
	local gr = gw/2 
	local gx = gxc
	local gy = gyc
	-- graph line
	local lw = gr/20
	-- title text
	local tx = self.properties.x+0.166*self.properties.w
	local ty = -50
	local th = self.properties.h - gw
	local tw = 0.66*self.properties.w-2*self.properties.x
	return {
		gh = gh,
		gw = gw,
		gr = gr,
		gx = gx,
		gy = gy,
		lw = lw,
		th = th,
		tx = tx,
		ty = ty,
		tw = tw,
		labelh = labelh,
		labely = labely,
		labelx = labelx,
		 }
elseif index == 0 then
-- special case, center graph
	-- graph
	local gr = (grc-grc/5)/3
	local gx = gxc
	local gy = gyc
	-- graph line
	local lw = gr/20
	-- title text
	local tw = 2*(gr-3*lw)*math.cos(math.pi/6)
	--local tw = 2*gr*math.cos(math.pi/6)
	local tx = gx-gr+(gr-0.5*tw)
	--local tx = gx-(gr-tw*0.5)
	local th = 2*gr*math.sin(math.pi/6)
	--local ty = gy+(gr-th*0.5)
	local ty = gy-gr/2-th/2
	return {
		gh = gh,
		gw = gw,
		gr = gr,
		gx = gx,
		gy = gy,
		lw = lw,
		th = th,
		tx = tx,
		ty = ty,
		tw = tw,
		labelh = labelh,
		labely = labely,
		labelx = labelx,
	 }
else
	local gr = (grc-grc/5)/3
	local gx = gxc + 2*gr*math.cos(alpha)
	local gy = gyc + 2*gr*math.sin(alpha)
	-- graph line
	local lw = gr/20
	-- text
	local tw = 2*(gr-3*lw)*math.cos(math.pi/6)
	local tx = gx-gr+(gr-0.5*tw)
	--local tx = gx-(gr-tw*0.5)
	local th = 2*gr*math.sin(math.pi/6)
	local ty = gy-gr/2-th/2
	return {
		gh = gh,
		gw = gw,
		gr = gr,
		gx = gx,
		gy = gy,
		lw = lw,
		th = th,
		tx = tx,
		ty = ty,
		tw = tw,
		labelh = labelh,
		labely = labely,
		labelx = labelx,
		 }
end

end

function CloudView:drawTitle(index,title)
	local e = self:layout(index)
	self.text:Draw({text = title, sizeby = 'width', width=e.tw, x=e.tx,y=e.ty+e.th})
end

function CloudView:drawLabels(itens)
local e = self:layout(0)
tx = e.labelh/2
for dn, value in pairs(itens) do
	-- square box, same color as above
	cairo_arc(self.cr,e.labelx+tx ,e.labely-e.labelh/2, (e.labelh/2)*0.8  ,0,2*math.pi)
	--cairo_rectangle(self.cr, e.labelx+tx, e.labely, e.labelh, e.labelh);
	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(self.properties.bg[dn], 1.0))
	cairo_fill(self.cr)
	-- text label with data source name
	local exts = self.text:Draw({text = dn, sizeby = 'height', height=e.labelh, x=e.labelx+tx+e.labelh*0.8, y=e.labely })
	tx = tx + e.labelh + tonumber(exts.width)+4*e.lw
end
end


function CloudView:drawCircles(index,data)
	local e = self:layout(index)
	local i = 0
	if data == nil then
		-- just do a simple white circle in case the machine has no data
		local r = e.gr-(i+1)*(e.lw)
		local cor_r, cor_g, cor_b = colors.hsl_to_rgb(0.0, 0.0, 1.0 )
		cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 0.8)
        	cairo_set_line_width (self.cr, e.lw)
        	cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
        	cairo_new_sub_path(self.cr)
        	cairo_arc(self.cr,e.gx,e.gy,r,0,2*math.pi)
        	cairo_stroke(self.cr);
		return nil
	end

	for item, value in pairs(data) do
		if value == nil then
			return nil
		end
		-- start from the outer edge, reducing the radius
		-- for each additional data point
		local r = e.gr-(math.floor(i)+1)*(e.lw)
		-- background 
		local cor_r, cor_g, cor_b = colors.hsl_to_rgb(0.0, 0.0, 0.1+(i/30) )
		cairo_set_source_rgba(self.cr, cor_r, cor_g, cor_b, 1.0)
        	cairo_set_line_width (self.cr, e.lw)
        	cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
        	cairo_new_sub_path(self.cr)
        	cairo_arc(self.cr,e.gx,e.gy,r,0,2*math.pi)
        	cairo_stroke(self.cr);
		-- to simplify, we get only FREE percentages, so we invert
		-- our values.
		local arc, start_arc, end_arc
		if self.properties.dataview[item] == "fullview" then
			arc = 2*math.pi*((100-value)/100)
			start_arc = (3/2)*math.pi - arc/2
			end_arc   = (3/2)*math.pi + arc/2
			i = i + 1
		elseif self.properties.dataview[item] == "leftview" then
			arc = math.pi*(value/100)
			start_arc = (3/2)*math.pi
			end_arc   = (3/2)*math.pi + arc
			if ( arc == nil) then
				arc = 0
				end_arc   = (3/2)*math.pi+0.01*math.pi
			end
			i = i + 0.5
		elseif self.properties.dataview[item] == "rightview" then
			arc = math.pi*(value/100)
			start_arc = (3/2)*math.pi 
			end_arc   = (3/2)*math.pi - arc
			i = i + 0.5
		end
		
		-- plotting
		cairo_new_sub_path(self.cr)
		cairo_arc(self.cr,e.gx,e.gy, r ,start_arc,end_arc)
		cairo_set_source_rgba(self.cr,theme.rgb_to_r_g_b(self.properties.bg[item], 1.0))
        	cairo_set_line_width (self.cr, e.lw)
        	cairo_set_line_cap(self.cr, CAIRO_LINE_CAP_BUTT);
		cairo_stroke(self.cr)
	end
end


function CloudView:destroy()
	cairo_destroy(self.cr)
end
