-- panbbcodeVBulletin - BBCode writer for pandoc
-- Copyright (C) 2015 Kerbas_ad_astra
-- Based on panbbcode, Copyright (C) 2014 Jens Oliver John < dev ! 2ion ! de >
-- Licensed under the GNU General Public License v3 or later.
-- Written for Lua 5.{1,2}

-- PRIVATE

local function enclose(t, s, p)
	if p then
		return string.format("[%s=%s]%s[/%s]", t, p, s, t)
	else
		return string.format("[%s]%s[/%s]", t, s, t)
	end
end

local function prepend(t, s, p)
	if p then
		return string.format("[%s=%s]%s", t, p, s)
	else
		return string.format("[%s]%s", t, s)
	end
end

-- PUBLIC

local cache_notes = {}

function Doc( body, meta, vars )
	local buf = {}
	local function _(e)
		table.insert(buf, e)
	end
	if meta['title'] and meta['title'] ~= "" then
		_(meta['title'])
	end
	_(body)
	if #cache_notes > 0 then
		_("--")
		for i,n in ipairs(cache_notes) do
			_(string.format("[%d] %s", i, n))
		end
	end
	return table.concat(buf, '\n')
end

function Str(s)
	return s
end

function Space()
	return ' '
end

function LineBreak()
	return '\n'
end

function Emph(s)
	return enclose('I', s)
end

function Strong(s)
	return enclose('b', s)
end

function Subscript(s)
	return enclose('SUB', s)
end

function Superscript(s)
	return enclose('SUP', s)
end

function SmallCaps(s)
	return s
end

function Strikeout(s)
	return enclose('s', s)
end

function Link(s, src, title)
	return enclose('url', s, src)
end

function Image(s, src, title)
	return enclose('img', s, src)
end

function CaptionedImage(src, attr, title)
	-- if not title or title == "" then
		return enclose('img', src) -- Commented out "title" line since the forums don't seem to like [img=blah].
	-- else
		-- return enclose('img', src, title)
	-- end
end

function Code(s, attr)
	return string.format("[CODE]%s[/CODE]", s)
end

function InlineMath(s)
	return s
end

function DisplayMath(s)
	return s
end

function Note(s)
	table.insert(cache_notes, s)
	return string.format("[%d]", #cache_notes)
end

function Span(s, attr)
	return s
end

function Plain(s)
	return s
end

function Para(s)
	return s
end

function Header(level, s, attr)
	if level == 1 then
		return enclose('SIZE', enclose('b', enclose('u', s)), '+2')
	elseif level == 2 then
	return enclose('SIZE', enclose('b', enclose('u', s)), '+1')
	elseif level == 3 then
		return enclose('b', enclose('u', s))
	else
		return enclose('b', s)
	end
end

function BlockQuote(s)
	local a, t = s:match('@([%w]+): (.+)')
	if a then
		return enclose('quote', t or "Unknown" , a)
	else
		return enclose('quote', s)
	end
end

function Cite(s)
	return s
end

function Blocksep(s)
	return "\n\n"
end

function HorizontalRule(s)
	return '--'
end

function CodeBlock(s, attr)
	return enclose('CODE', s)
end

local function makelist(items, ltype)
	local buf = ""
	if ltype == '*' then
		buf = "[list]"
	else
		buf = string.format("[list=%s]", ltype)
	end
	for _,e in ipairs(items) do
		buf = buf .. prepend('*', e) .. '\n'
	end
	buf = buf .. '[/list]'
	return buf
end

function BulletList(items)
	return makelist(items, '*')
end

function OrderedList(items)
	return makelist(items, '1')
end

function DefinitionList(items)
	local buf = ""
	local function mkdef(k,v)
		return string.format("%s: %s\n", enclose('b', k), v)
	end
	for _,e in ipairs(items) do
		for k,v in pairs(items) do
			buf = buf .. mkdef(k,v)
		end
	end
	return buf
end

function html_align(align)
	return ""
end

function Table(cap, align, widths, headers, rows)
	local buf = {}
	local function add(s)
		table.insert(buf,s)
	end
	local width = 0
	if widths and widths[1] ~= 0 then
		for _,w in ipairs(widths) do
			width = width + w
		end
	else
		width = 500
	end
	add(string.format("[table=\"width:%d\"]",width))
	add("[tr]")
	for i,h in ipairs(headers) do
		local locAlign = align[i]
		if locAlign == "AlignDefault" then
			add(enclose('td',Strong(h)))
		elseif locAlign == "AlignCenter" then
			add(enclose('td',enclose("center",Strong(h))))
		elseif locAlign == "AlignLeft" then
			add(enclose('td',enclose("left",Strong(h))))
		elseif locAlign == "AlignRight" then
			add(enclose('td',enclose("right",Strong(h))))
		end
	end
	add("[/tr]")
	
	for _,r in ipairs(rows) do
		add("[tr]")
		for i,c in ipairs(r) do
			local locAlign = align[i]
			if locAlign == "AlignDefault" then
				add(enclose('td',c))
			elseif locAlign == "AlignCenter" then
				add(enclose('td',enclose("center",c)))
			elseif locAlign == "AlignLeft" then
				add(enclose('td',enclose("left",c)))
			elseif locAlign == "AlignRight" then
				add(enclose('td',enclose("right",c)))
			end
		end
		add("[/tr]")
	end
	add("[/table]")
	return table.concat(buf, '\n')
end

function Div(s, attr)
	return s
end

-- boilerplate

local meta = {}
meta.__index =
	function(_, key)
		io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
		return function() return "" end
	end
setmetatable(_G, meta)
