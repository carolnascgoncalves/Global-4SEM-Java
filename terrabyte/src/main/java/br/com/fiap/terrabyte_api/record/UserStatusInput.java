package br.com.fiap.terrabyte_api.record;

import jakarta.validation.constraints.NotNull;

public record UserStatusInput(@NotNull Boolean active) {
}
