package ee.valiit.etas.persistence.invoice;

import ee.valiit.etas.persistence.seller.Seller;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "invoice", schema = "etas")
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "seller_id", nullable = false)
    private Seller seller;

    @Size(max = 20)
    @NotNull
    @Column(name = "period", nullable = false, length = 20)
    private String period;

    @Size(max = 100)
    @Column(name = "number", length = 100)
    private String number;

    @NotNull
    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(name = "issued_on")
    private LocalDate issuedOn;

    @NotNull
    @Column(name = "calculated_fee", nullable = false, precision = 12, scale = 2)
    private BigDecimal calculatedFee;

    @Size(max = 2000)
    @Column(name = "notes", length = 2000)
    private String notes;

}
