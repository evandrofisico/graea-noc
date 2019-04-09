
-- -- function print_r (t, indent, done)
-- --         done = done or {}
-- --         indent = indent or ''
-- --         local nextIndent -- Storage for next indentation value
-- --         for key, value in pairs (t) do
-- --                 if type (value) == "table" and not done [value] then
-- --                         nextIndent = nextIndent or
-- --                         (indent .. string.rep(' ',string.len(tostring (key))+2))
-- --                         -- Shortcut conditional allocation
-- --                         done [value] = true
-- --                         print (indent .. "[" .. tostring (key) .. "] => Table {");
-- --                         print  (nextIndent .. "{");
-- --                         print_r (value, nextIndent .. string.rep(' ',2), done)
-- --                         print  (nextIndent .. "}");
-- --                 else
-- --                         print  (indent .. "[" .. tostring (key) .. "] => " .. tostring (value).."")
-- --                 end
-- --         end
-- -- end
-- -- 
-- -- 
-- -- function print_r (t, indent) -- alt version, abuse to http://richard.warburton.it
-- -- 	local indent=indent or ''
-- -- 	for key,value in pairs(t) do
-- -- 		io.write(indent,'[',tostring(key),']') 
-- -- 		if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
-- -- 		else io.write(' = ',tostring(value),'\n') end
-- -- 	end
-- -- end

-- alt version2, handles cycles, functions, booleans, etc
--  - abuse to http://richard.warburton.it
-- output almost identical to print(table.show(t)) below.
function print_r (t, name, indent)
	local tableList = {}
	local function table_r (t, name, indent, full)
		local serial=string.len(full) == 0 and name
		or type(name)~="number" and '["'..tostring(name)..'"]' or '['..name..']'
		io.write(indent,serial,' = ') 
		if type(t) == "table" then
			if tableList[t] ~= nil then io.write('{}; -- ',tableList[t],' (self reference)\n')
			else
				tableList[t]=full..serial
				if next(t) then -- Table not empty
					io.write('{\n')
					for key,value in pairs(t) do table_r(value,key,indent..'\t',full..serial) end 
					io.write(indent,'};\n')
				else io.write('{};\n') end
			end
		else io.write(type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"'
			or tostring(t),';\n') end
		end
		table_r(t,name or '__unnamed__',indent or '','')
	end
function rgb_to_r_g_b(colour, alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function r_g_b_to_rgb(r,g,b)
	return (r*255*0x10000+g*255*0x100+b*255)
end

function cairo_rectangle_round(lcr, x, y,  width , height , corner_radius_aspect)
        local aspect = 1.0
        local corner_radius = height / corner_radius_aspect
        local radius = corner_radius / aspect;
        local degrees = math.pi/180.0;
        cairo_new_sub_path (lcr);
        cairo_arc (lcr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
        cairo_arc (lcr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
        cairo_arc (lcr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
        cairo_arc (lcr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
        cairo_close_path (lcr);
end

function cairo_rectangle_round_left(lcr, x, y,  width , height , corner_radius_aspect)
        local aspect = 1.0
        local corner_radius = height / corner_radius_aspect
        local radius = corner_radius / aspect;
        local degrees = math.pi/180.0;
        cairo_new_sub_path (lcr);
	cairo_move_to(lcr, x + width, y)
	cairo_line_to(lcr, x + width, y + height )
        cairo_arc (lcr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
        cairo_arc (lcr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
        cairo_close_path (lcr);
end


function cairo_rectangle_round_right(lcr, x, y,  width , height , corner_radius_aspect)
        local aspect = 1.0
        local corner_radius = height / corner_radius_aspect
        local radius = corner_radius / aspect;
        local degrees = math.pi/180.0;
        cairo_new_sub_path (lcr);
        cairo_move_to(lcr, x, y+height);
        cairo_line_to(lcr, x, y);
        cairo_arc (lcr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
        cairo_arc (lcr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
        cairo_close_path (lcr);
end


function build_w_cb(t)
return function(s,len)
        table.insert(t,s)
        return len,nil
end
end


function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
        return key, t[key]
    end
    -- fetch the next value
    key = nil
    for i = 1,table.getn(t.__orderedIndex) do
        if t.__orderedIndex[i] == state then
            key = t.__orderedIndex[i+1]
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end


-- algoritmo do john conway
function moonPhase()
local apr = require('apr')
local datec = apr.time_explode()
local r = datec.year%100;
r = r%19
if (r>9) then 
	r = r-19
end
r = ((r * 11) % 30) + datec.month + datec.day;
if (datec.month<3) then
	 r = r+ 2
end
r = r - 8.3
r = math.floor(r+0.5)%30;
if (r < 0) then
	return r+30
else
	return r
end
end

function passBind(t, k)
    return function(...) return t[k](t, ...) end
end

--
-- Splits string s into array of lines, returning the result.
-- New-line character sequences ("\n", "\r\n", "\r"),
-- if any, are included at the ends of the lines.
--
function split_newlines(s)
  local ts = {}
  local posa = 1
  while 1 do
    local pos, chars = s:match('()([\r\n].?)', posa)
    if pos then
      if chars == '\r\n' then pos = pos + 1 end
      local line = s:sub(posa, pos)
      ts[#ts+1] = line
      posa = pos + 1
    else
      local line = s:sub(posa)
      if line ~= '' then ts[#ts+1] = line end
      break      
    end
  end
  return ts
end


