package ee.valiit.etas;

import lombok.Getter;

@Getter
public enum Status {
    ACTIVE("A"),
    SOFT_DELETED("D");

    private final String code;

    Status(String code) {
        this.code = code;
    }

}