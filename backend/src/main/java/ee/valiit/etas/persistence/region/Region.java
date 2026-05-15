package ee.valiit.etas.persistence.region;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "region", schema = "etas")
public class Region {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Size(max = 20)
    @NotNull
    @Column(name = "region_name", nullable = false, length = 20)
    private String regionName;

    @NotNull
    @Column(name = "sequence_number", nullable = false)
    private Integer sequenceNumber;

}
