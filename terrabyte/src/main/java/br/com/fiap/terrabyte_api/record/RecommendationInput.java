package br.com.fiap.terrabyte_api.record;

import br.com.fiap.terrabyte_api.validation.NonZeroUuid;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record RecommendationInput(@NotNull @NonZeroUuid UUID deviceId) {
}
