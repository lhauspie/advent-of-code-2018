luaunit = require('luaunit')
local hello = require("hello")


TestHello = {} --class
    function TestHello:testSayHelloWithNumbers()
        result = hello.sayHello( 123456 )
        luaunit.assertEquals( type(result), 'string' )
        luaunit.assertEquals( result, "Hello, 123456 !" )
    end

    function TestHello:testSayHelloWithString()
        result = hello.sayHello( "Logan" )
        luaunit.assertEquals( type(result), 'string' )
        luaunit.assertEquals( result, "Hello, Logan !" )
    end
-- class TestMyStuff

os.exit( luaunit.LuaUnit.run() )
