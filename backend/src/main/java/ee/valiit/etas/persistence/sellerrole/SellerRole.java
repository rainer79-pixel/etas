package ee.valiit.etas.persistence.sellerrole;

import ee.valiit.etas.persistence.role.Role;
import ee.valiit.etas.persistence.sellercontact.SellerContact;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "seller_role", schema = "etas")
public class SellerRole {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "seller_contact_id", nullable = false)
    private SellerContact sellerContact;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "seller_role_id", nullable = false)
    private Role role;

}
