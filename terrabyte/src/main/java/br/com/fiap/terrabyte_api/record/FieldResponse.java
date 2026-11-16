package br.com.fiap.terrabyte_api.record;

import java.math.BigDecimal;
import java.util.UUID;

public record FieldResponse(UUID id, UUID propertyId, String name, BigDecimal areaHectares) {

}
