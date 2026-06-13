package lk.police.trafficfine.fine.service;

import lk.police.trafficfine.common.BadRequestException;
import lk.police.trafficfine.common.ReferenceGenerator;
import lk.police.trafficfine.common.ResourceNotFoundException;
import lk.police.trafficfine.fine.dto.FineDetailsDto;
import lk.police.trafficfine.fine.dto.FineRequest;
import lk.police.trafficfine.fine.dto.FineResponse;
import lk.police.trafficfine.fine.entity.Fine;
import lk.police.trafficfine.fine.entity.FineCategory;
import lk.police.trafficfine.fine.entity.FineStatus;
import lk.police.trafficfine.fine.repository.FineCategoryRepository;
import lk.police.trafficfine.fine.repository.FineRepository;
import lk.police.trafficfine.user.entity.User;
import lk.police.trafficfine.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class FineService {

    private final FineRepository fineRepository;
    private final FineCategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final ReferenceGenerator referenceGenerator;

    @Transactional
    public FineResponse issueFine(FineRequest request, String officerEmail) {
        User officer = userRepository.findByEmail(officerEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Officer not found"));

        FineCategory category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException("Fine category not found"));

        String referenceNo;
        do {
            referenceNo = referenceGenerator.generate();
        } while (fineRepository.existsByReferenceNo(referenceNo));

        Fine fine = Fine.builder()
                .referenceNo(referenceNo)
                .category(category)
                .officer(officer)
                .driverName(request.getDriverName())
                .vehicleNo(request.getVehicleNo())
                .district(request.getDistrict())
                .status(FineStatus.PENDING)
                .build();

        fine = fineRepository.save(fine);
        return toResponse(fine);
    }

    public FineDetailsDto lookupByReference(String referenceNo) {
        Fine fine = fineRepository.findByReferenceNo(referenceNo)
                .orElseThrow(() -> new ResourceNotFoundException("Fine not found with reference: " + referenceNo));
        return toDetails(fine);
    }

    public Fine getFineByReference(String referenceNo) {
        return fineRepository.findByReferenceNo(referenceNo)
                .orElseThrow(() -> new ResourceNotFoundException("Fine not found with reference: " + referenceNo));
    }

    @Transactional
    public void markAsPaid(Fine fine) {
        if (fine.getStatus() == FineStatus.PAID) {
            throw new BadRequestException("Fine is already paid");
        }
        fine.setStatus(FineStatus.PAID);
        fineRepository.save(fine);
    }

    private FineResponse toResponse(Fine fine) {
        return FineResponse.builder()
                .id(fine.getId())
                .referenceNo(fine.getReferenceNo())
                .categoryId(fine.getCategory().getId())
                .categoryDescription(fine.getCategory().getDescription())
                .amount(fine.getCategory().getAmount())
                .driverName(fine.getDriverName())
                .vehicleNo(fine.getVehicleNo())
                .district(fine.getDistrict())
                .status(fine.getStatus())
                .issuedAt(fine.getIssuedAt())
                .officerName(fine.getOfficer().getName())
                .build();
    }

    private FineDetailsDto toDetails(Fine fine) {
        return FineDetailsDto.builder()
                .id(fine.getId())
                .referenceNo(fine.getReferenceNo())
                .categoryId(fine.getCategory().getId())
                .categoryCode(fine.getCategory().getCategoryCode())
                .categoryDescription(fine.getCategory().getDescription())
                .amount(fine.getCategory().getAmount())
                .driverName(fine.getDriverName())
                .vehicleNo(fine.getVehicleNo())
                .district(fine.getDistrict())
                .status(fine.getStatus())
                .issuedAt(fine.getIssuedAt())
                .build();
    }
}
