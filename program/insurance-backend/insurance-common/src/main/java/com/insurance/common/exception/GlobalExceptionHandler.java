package com.insurance.common.exception;

import com.insurance.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 业务异常 - 根据异常消息智能映射HTTP状态码
     */
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<Result<Void>> handleBusinessException(BusinessException e, HttpServletRequest request) {
        log.warn("业务异常: [{}] {}", request.getRequestURI(), e.getMessage());
        HttpStatus status = resolveHttpStatus(e);
        return ResponseEntity.status(status).body(Result.fail(e.getCode(), e.getMessage()));
    }

    private HttpStatus resolveHttpStatus(BusinessException e) {
        String msg = e.getMessage();
        if (msg == null) return HttpStatus.BAD_REQUEST;
        if (msg.contains("不存在")) return HttpStatus.NOT_FOUND;           // 404
        if (msg.contains("不能为空")) return HttpStatus.BAD_REQUEST;        // 400
        if (msg.contains("不支持的")) return HttpStatus.BAD_REQUEST;        // 400
        if (msg.contains("无效")) return HttpStatus.BAD_REQUEST;           // 400
        if (msg.contains("无法")) return HttpStatus.BAD_REQUEST;           // 400
        if (msg.contains("无权")) return HttpStatus.FORBIDDEN;             // 403
        return HttpStatus.BAD_REQUEST; // 默认业务异常返回400
    }

    /**
     * 参数校验异常 - MethodArgumentNotValidException
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleMethodArgumentNotValidException(MethodArgumentNotValidException e, HttpServletRequest request) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        log.warn("参数校验异常: [{}] {}", request.getRequestURI(), message);
        return Result.fail(400, message);
    }

    /**
     * 参数绑定异常 - BindException
     */
    @ExceptionHandler(BindException.class)
    public Result<Void> handleBindException(BindException e, HttpServletRequest request) {
        String message = e.getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        log.warn("参数绑定异常: [{}] {}", request.getRequestURI(), message);
        return Result.fail(400, message);
    }

    /**
     * 约束校验异常 - ConstraintViolationException
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public Result<Void> handleConstraintViolationException(ConstraintViolationException e, HttpServletRequest request) {
        String message = e.getConstraintViolations().stream()
                .map(ConstraintViolation::getMessage)
                .collect(Collectors.joining(", "));
        log.warn("约束校验异常: [{}] {}", request.getRequestURI(), message);
        return Result.fail(400, message);
    }

    /**
     * 其他异常
     */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e, HttpServletRequest request) {
        log.error("系统异常: [{}]", request.getRequestURI(), e);
        return Result.fail(500, "系统繁忙，请稍后重试");
    }
}
