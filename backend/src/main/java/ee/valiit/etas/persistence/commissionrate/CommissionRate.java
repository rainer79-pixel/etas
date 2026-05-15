package ee.valiit.etas.persistence.commissionrate;

import ee.valiit.etas.persistence.producttype.ProductType;
import ee.valiit.etas.persistence.seller.Seller;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "commission_rate", schema = "etas")
public class CommissionRate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "seller_id", nullable = false)
    private Seller seller;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "product_type_id", nullable = false)
    private ProductType productType;

    @Column(name = "fee_per_transaction", precision = 10, scale = 4)
    private BigDecimal feePerTransaction;

    @Column(name = "fee_percent", precision = 5, scale = 2)
    private BigDecimal feePercent;

    @NotNull
    @Column(name = "includes_vat", nullable = false)
    private Boolean includesVat;

    @NotNull
    @Column(name = "valid_from", nullable = false)
    private LocalDate validFrom;

    @Column(name = "valid_to")
    private LocalDate validTo;

}
