package lk.police.trafficfine.payment.repository;

import lk.police.trafficfine.payment.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public interface PaymentRepository extends JpaRepository<Payment, UUID> {

    @Query("SELECT COALESCE(SUM(p.amountPaid), 0) FROM Payment p")
    BigDecimal sumTotalAmountCollected();

    @Query("SELECT f.district, SUM(p.amountPaid) FROM Payment p JOIN p.fine f GROUP BY f.district")
    List<Object[]> sumByDistrict();

    @Query("SELECT c.description, SUM(p.amountPaid) FROM Payment p JOIN p.fine f JOIN f.category c GROUP BY c.description")
    List<Object[]> sumByCategory();
}
