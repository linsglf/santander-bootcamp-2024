package me.dio.controller.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.NoSuchElementException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<StandardError> illegalArgumentException(IllegalArgumentException e) {
        var error = new StandardError(System.currentTimeMillis(), HttpStatus.UNPROCESSABLE_ENTITY.value(), "Unprocessable Entity", e.getMessage(), "/users");
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY.value()).body(error);
    }

    @ExceptionHandler(NoSuchElementException.class)
    public ResponseEntity<StandardError> noSuchElementException(NoSuchElementException e) {
        var error = new StandardError(System.currentTimeMillis(), HttpStatus.NOT_FOUND.value(), "Not Found", "Resource ID not found.", "/users");
        return ResponseEntity.status(HttpStatus.NOT_FOUND.value()).body(error);
    }

    @ExceptionHandler(Throwable.class)
    public ResponseEntity<StandardError> throwable(Throwable e) {
        var message = "Unexpected server error, see thr logs.";
        logger.error(message, e);
        var error = new StandardError(System.currentTimeMillis(), HttpStatus.INTERNAL_SERVER_ERROR.value(), "Internal Server Error", e.getMessage(), "/users");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR.value()).body(error);
    }
}
