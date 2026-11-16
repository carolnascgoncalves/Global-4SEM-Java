package br.com.fiap.terrabyte_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@EnableFeignClients
@SpringBootApplication
public class TerraByteApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(TerraByteApiApplication.class, args);
	}

}
