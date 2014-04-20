README.bbcode: README.mkd
	pandoc -f markdown+pipe_tables -t panbbcode.lua -o $@ --smart $<
