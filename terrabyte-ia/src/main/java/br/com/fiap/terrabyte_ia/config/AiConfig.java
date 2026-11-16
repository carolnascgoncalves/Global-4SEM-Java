package br.com.fiap.terrabyte_ia.config;

import java.time.Clock;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AiConfig {

	@Bean
	public Clock clock() {
		return Clock.systemUTC();
	}
}
