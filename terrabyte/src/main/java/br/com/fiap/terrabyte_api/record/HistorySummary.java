package br.com.fiap.terrabyte_api.record;

import java.math.BigDecimal;

public record HistorySummary(BigDecimal min, BigDecimal max, BigDecimal avg) {
}
