package br.com.fiap.terrabyte_api.service;

import br.com.fiap.terrabyte_api.record.AiDeviceContext;
import br.com.fiap.terrabyte_api.record.AiRecommendationBatch;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "terrabyte-ia", contextId = "recommendationAi")
public interface RecommendationFeignService {

	@PostMapping("/internal/recommendations")
	AiRecommendationBatch generate(@RequestHeader("X-Internal-Key") String key, @RequestBody AiDeviceContext context);
}
