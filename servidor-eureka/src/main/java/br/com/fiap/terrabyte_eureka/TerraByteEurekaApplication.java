package br.com.fiap.terrabyte_eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@SpringBootApplication
public class TerraByteEurekaApplication {

	public static void main(String[] args) {
		SpringApplication.run(TerraByteEurekaApplication.class, args);
	}

}
