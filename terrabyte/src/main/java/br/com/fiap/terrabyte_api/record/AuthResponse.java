package br.com.fiap.terrabyte_api.record;

public record AuthResponse(String accessToken, String tokenType, int expiresIn, UserResponse user) {
}
