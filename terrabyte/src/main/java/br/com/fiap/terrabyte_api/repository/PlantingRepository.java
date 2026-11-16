package br.com.fiap.terrabyte_api.repository;

import br.com.fiap.terrabyte_api.model.Planting;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlantingRepository extends JpaRepository<Planting, UUID> {

	Page<Planting> findByFieldIdAndFieldPropertyUserId(UUID fieldId, UUID userId, Pageable pageable);
	Optional<Planting> findByIdAndFieldIdAndFieldPropertyUserId(UUID id, UUID fieldId, UUID userId);
}
