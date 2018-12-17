package tries

import kotlin.test.assertEquals
import org.junit.Test

class HelloTest {
    @Test fun helloWorldReturnsPersonalizedMessage() {
        assertEquals("Hello, Molly!", sayHello("Molly"))
    }

    @Test fun helloWorldReturnsGenericMessage() {
        assertEquals("Hello, World!", sayHello())
    }
}
