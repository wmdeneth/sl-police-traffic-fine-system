package lk.police.trafficfine.fine.service;

import lk.police.trafficfine.fine.entity.FineCategory;
import lk.police.trafficfine.fine.repository.FineCategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FineCategoryService {

    private final FineCategoryRepository categoryRepository;

    public List<FineCategory> getAllCategories() {
        return categoryRepository.findAll();
    }
}
