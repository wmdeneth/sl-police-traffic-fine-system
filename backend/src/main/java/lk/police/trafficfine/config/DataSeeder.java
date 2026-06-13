package lk.police.trafficfine.config;

import lk.police.trafficfine.fine.entity.FineCategory;
import lk.police.trafficfine.fine.repository.FineCategoryRepository;
import lk.police.trafficfine.user.entity.Role;
import lk.police.trafficfine.user.entity.User;
import lk.police.trafficfine.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final FineCategoryRepository categoryRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (userRepository.count() == 0) {
            seedUsers();
        }
        if (categoryRepository.count() == 0) {
            seedCategories();
        }
    }

    private void seedUsers() {
        User admin = User.builder()
                .name("System Admin")
                .email("admin@police.lk")
                .passwordHash(passwordEncoder.encode("admin123"))
                .role(Role.ADMIN)
                .phone("+94770000001")
                .district("Colombo")
                .build();

        User officer = User.builder()
                .name("Traffic Officer")
                .email("officer@police.lk")
                .passwordHash(passwordEncoder.encode("officer123"))
                .role(Role.OFFICER)
                .phone("+94771234567")
                .district("Colombo")
                .build();

        userRepository.save(admin);
        userRepository.save(officer);
        log.info("Seeded default admin and officer users");
    }

    private void seedCategories() {
        categoryRepository.save(FineCategory.builder()
                .categoryCode("SPD")
                .description("Speeding")
                .amount(new BigDecimal("2500.00"))
                .build());
        categoryRepository.save(FineCategory.builder()
                .categoryCode("RRL")
                .description("Running Red Light")
                .amount(new BigDecimal("3000.00"))
                .build());
        categoryRepository.save(FineCategory.builder()
                .categoryCode("NHL")
                .description("No Helmet")
                .amount(new BigDecimal("1000.00"))
                .build());
        categoryRepository.save(FineCategory.builder()
                .categoryCode("PKR")
                .description("Illegal Parking")
                .amount(new BigDecimal("1500.00"))
                .build());
        categoryRepository.save(FineCategory.builder()
                .categoryCode("PHN")
                .description("Using Phone While Driving")
                .amount(new BigDecimal("5000.00"))
                .build());
        log.info("Seeded 5 fine categories");
    }
}
