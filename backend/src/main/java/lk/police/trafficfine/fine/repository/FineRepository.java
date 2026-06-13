package lk.police.trafficfine.fine.repository;

import lk.police.trafficfine.fine.entity.Fine;
import lk.police.trafficfine.fine.entity.FineStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface FineRepository extends JpaRepository<Fine, UUID> {
    Optional<Fine> findByReferenceNo(String referenceNo);
    boolean existsByReferenceNo(String referenceNo);
    long countByStatus(FineStatus status);
}
