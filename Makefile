README.bbcode: README.mkd panbbcode.lua
	pandoc -f markdown+pipe_tables -t panbbcodeVBulletin.lua -o $@ --smart $<
