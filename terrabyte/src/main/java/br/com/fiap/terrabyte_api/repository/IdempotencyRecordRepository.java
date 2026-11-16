package br.com.fiap.terrabyte_api.repository;

import br.com.fiap.terrabyte_api.model.IdempotencyRecord;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IdempotencyRecordRepository extends JpaRepository<IdempotencyRecord, UUID> {

	Optional<IdempotencyRecord> findByUserIdAndKey(UUID userId, String key);
}
