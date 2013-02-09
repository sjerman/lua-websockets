--- lua websocket equivalent to test-server.c from libwebsockets.
-- using lua-ev event loop 
local ev = require'ev'
local loop = ev.Loop.default
local server = require'websocket'.server.ev.listen
{
   protocols = {
      ['lws-mirror-protocol'] = function(ws)
	 ws:on_message(
	    function(ws,data)
	       ws:send(data)
--	       ws:broadcast(data)
	    end)
      end,
      ['dumb-increment-protocol'] = function(ws)	       
	 local number = 0
	 local timer = ev.Timer.new(
	    function()
--	       print(number)
	       ws:send(tostring(number))
	       number = number + 1
	    end,0.1,0.1)
--	 timer:start(loop)
	 ws:on_message(
	    function(ws,message)
	       if message:match('reset') then
		  number = 0
	       end
	    end)
	 ws:on_close(
	    function()
	       timer:stop(loop)
	    end)
      end
   },
   port = 12345
}

loop:loop()

