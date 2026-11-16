package br.com.fiap.terrabyte_api.record;

import br.com.fiap.terrabyte_api.model.UserRole;
import jakarta.validation.constraints.NotNull;

public record UserRoleInput(@NotNull UserRole role) {
}
