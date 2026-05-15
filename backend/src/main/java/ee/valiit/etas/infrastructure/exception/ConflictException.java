package ee.valiit.etas.infrastructure.exception;

import lombok.Getter;

@Getter
public class ConflictException extends RuntimeException {
    private final String message;
    private final Integer errorCode;

    public ConflictException(String message, Integer errorCode) {
        super(message);
        this.message = message;
        this.errorCode = errorCode;
    }
}