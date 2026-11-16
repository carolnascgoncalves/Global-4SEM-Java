package br.com.fiap.terrabyte_api.record;

import java.util.Map;
import java.util.UUID;

public record RecommendationWork(AiDeviceContext context, Map<UUID, RecommendationCache> cached) {
}
