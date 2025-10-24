package iuh.fit.xstore.exception;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.AppException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = RuntimeException.class)
    ResponseEntity<ApiResponse<Object>> handleRuntime(RuntimeException ex) {
        ApiResponse<Object> response = new ApiResponse<>();
        response.setCode(400);
        response.setMessage(ex.getMessage());
        response.setResult(null);
        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(AppException.class)
    ResponseEntity<ApiResponse<Object>> handleAppException(AppException appException) {
        ApiResponse<Object> response = new ApiResponse<>();
        response.setCode(appException.getErrorCode().getCode());
        response.setMessage(appException.getErrorCode().getMessage());
        response.setResult(null);

        return ResponseEntity.status(appException.getErrorCode().getCode()).body(response);
    }

}
