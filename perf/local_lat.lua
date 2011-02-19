-- Copyright (c) 2010 Aleksey Yeschenko <aleksey@yeschenko.com>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

if not arg[3] then
    print("usage: lua local_lat.lua <bind-to> <message-size> <roundtrip-count> [<zmq-module>]")
    os.exit()
end

local bind_to = arg[1]
local message_size = tonumber(arg[2])
local roundtrip_count = tonumber(arg[3])
local mod = arg[4] or "zmq"
if mod == 'disable_ffi' then
	disable_ffi = true
	mod = 'zmq'
end

local zmq = require(mod)

local ctx = zmq.init(1)
local s = ctx:socket(zmq.REP)
s:bind(bind_to)

local msg

for i = 1, roundtrip_count do
    msg = s:recv()
		assert(#msg == message_size, "Invalid message size")
    s:send(msg)
end

s:close()
ctx:term()
