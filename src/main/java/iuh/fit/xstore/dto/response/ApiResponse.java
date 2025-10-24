package iuh.fit.xstore.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private int code;
    private String message;
    private T result;

    public ApiResponse(ErrorCode errorCode) {
        this.code = errorCode.getCode();
        this.message = errorCode.getMessage();
        this.result = null;
    }

    public ApiResponse(SuccessCode successCode, T result) {
        this.code = successCode.getCode();
        this.message = successCode.getMessage();
        this.result = result;
    }
}
