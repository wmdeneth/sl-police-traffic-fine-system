package lk.police.trafficfine.fine.repository;

import lk.police.trafficfine.fine.entity.FineCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface FineCategoryRepository extends JpaRepository<FineCategory, UUID> {
    Optional<FineCategory> findByCategoryCode(String categoryCode);
}
