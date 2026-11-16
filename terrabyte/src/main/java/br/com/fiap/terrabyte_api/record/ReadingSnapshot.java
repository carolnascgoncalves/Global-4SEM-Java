package br.com.fiap.terrabyte_api.record;

import java.math.BigDecimal;
import java.time.Instant;

public record ReadingSnapshot(String type, BigDecimal value, String unit, Instant recordedAt) {
}
