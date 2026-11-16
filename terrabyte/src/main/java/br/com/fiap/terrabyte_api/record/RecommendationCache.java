package br.com.fiap.terrabyte_api.record;



public record RecommendationCache(RecommendationResponse response, boolean aiGenerated, String modelName, String inputFingerprint) {
}
