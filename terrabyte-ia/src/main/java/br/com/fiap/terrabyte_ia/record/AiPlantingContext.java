package br.com.fiap.terrabyte_ia.record;

import java.time.Instant;

public record AiPlantingContext(String cropName, String stage, Instant plantedAt) {
}
