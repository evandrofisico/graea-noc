package.path=package.path..";/usr/share/dashboard/lib/?.lua"
local DrawText = require('view.DrawText')

local BigMessage = {}
BigMessage. __index = BigMessage 

setmetatable(BigMessage, {
__call = function (cls, ...)
	return cls.new( ...)
end,
})

function BigMessage.new(p)
        if conky_window == nil then
                return
        end
        local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
        local cairo_cr = cairo_create(cs)
	local txtconfig = {
                text="test",
                fontname = p.font,
                sizeby = 'width',
                color = p.fg["title"],
                alpha = 1.0,
                shadow = false,
                shadowalpha = 0.5,
                shadowcolor = p.fg["shadow"],
	}

        local text = DrawText:new(txtconfig, cairo_cr)
	p.y_shift = 0
	p.x_shift = 0
	return setmetatable({cr = cairo_cr,cs = cs, properties = p, text = text}, BigMessage)
end

function BigMessage:destroy()
        cairo_destroy(self.cr)
	cairo_surface_destroy(self.cs)
end

function BigMessage:alpha(frames)
	-- fade in 
	if frames < self.properties.fade_frames then
		return frames*(1/self.properties.fade_frames)
	-- 
	elseif frames > self.properties.fade_frames + self.properties.showmsg_frames then
		return  1-(frames-self.properties.fade_frames-self.properties.showmsg_frames)/self.properties.fade_frames
	else
		return 1
	end
end

function BigMessage:DrawEvent(e,frames)
	local color
	e.w = self.properties.width
	e.h = self.properties.height
	e.x = 0
	e.y = 0
	cairo_rectangle(self.cr, e.x, e.y, e.w, e.h);
	local alpha = self:alpha(frames)
	
	if self.properties.bg[e.type] == nil then
		color = self.properties.bg["neutral"]
	else
		color = self.properties.bg[e.type]
	end

	cairo_set_source_rgba(self.cr, theme.rgb_to_r_g_b(color, alpha))
	cairo_fill_preserve(self.cr)
	self.text.properties.alpha = alpha
        --self.text:Draw({text = e.title, width=self.properties.width*0.9, x=self.properties.width*0.05,y=self.properties.height*0.4*alpha})
	self.text:set("text", e.title)
	self.text:set("width", self.properties.width*0.9)
	self.text:set("x", self.properties.width*0.05)
	self.text:set("y", self.properties.height*0.4*alpha)
	self.text:show()

        --self.text:Draw({text = e.text, width=self.properties.width*0.9, x=self.properties.width*0.05,y=self.properties.height*0.7+(1-alpha)*self.properties.height*0.3,color = self.properties.fg["text"],})
	self.text:set("text", e.text)
	self.text:set("width",self.properties.width*0.9)
	self.text:set("x", self.properties.width*0.05)
	self.text:set("y", self.properties.height*0.7+(1-alpha)*self.properties.height*0.3)
	self.text:set("color", self.properties.fg["text"])
	self.text:show()
	
end
return BigMessage
