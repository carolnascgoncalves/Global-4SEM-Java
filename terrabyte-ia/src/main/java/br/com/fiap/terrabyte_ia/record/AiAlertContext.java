package br.com.fiap.terrabyte_ia.record;

import java.util.List;
import java.util.UUID;

public record AiAlertContext(UUID alertId, String priority, String title, String message, String reason, List<ReadingSnapshot> basedOn, boolean simulatedData) {
}
