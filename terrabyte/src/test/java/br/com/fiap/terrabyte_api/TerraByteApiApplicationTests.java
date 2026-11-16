package br.com.fiap.terrabyte_api;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.support.DependencyInjectionTestExecutionListener;

@SpringBootTest
@ActiveProfiles("test")
@TestExecutionListeners(DependencyInjectionTestExecutionListener.class)
class TerraByteApiApplicationTests {

	@Test
	void contextLoads() {
	}

}
