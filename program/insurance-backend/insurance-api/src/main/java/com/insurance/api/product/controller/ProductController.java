package com.insurance.api.product.controller;

import com.insurance.api.product.dto.ProductQueryDTO;
import com.insurance.api.product.service.ProductService;
import com.insurance.api.product.vo.ProductResponsibilityVO;
import com.insurance.api.product.vo.ProductVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 产品Controller
 */
@RestController
@RequestMapping("/api/v1/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    /**
     * 分页查询产品列表（自动过滤system_status=1 AND sale_status IN (1,2)）
     */
    @GetMapping("/list")
    public Result<PageResult<ProductVO>> listProducts(@Validated ProductQueryDTO queryDTO) {
        return Result.success(productService.listProducts(queryDTO));
    }

    /**
     * 获取产品详情（含子类数据）
     */
    @GetMapping("/{productId}")
    public Result<ProductVO> getProductDetail(@PathVariable Long productId) {
        return Result.success(productService.getProductDetail(productId));
    }

    /**
     * 获取产品责任配置
     */
    @GetMapping("/{productId}/responsibilities")
    public Result<ProductResponsibilityVO> getProductResponsibilities(@PathVariable Long productId) {
        return Result.success(productService.getProductResponsibilities(productId));
    }

    /**
     * 获取热门产品
     */
    @GetMapping("/hot")
    public Result<List<ProductVO>> getHotProducts(@RequestParam(defaultValue = "8") int limit) {
        return Result.success(productService.getHotProducts(limit));
    }

    /**
     * 获取产品类型列表
     */
    @GetMapping("/types")
    public Result<List<Map<String, Object>>> getProductTypes() {
        return Result.success(productService.getProductTypes());
    }

    /**
     * 搜索产品
     */
    @GetMapping("/search")
    public Result<List<ProductVO>> searchProducts(@RequestParam String keyword) {
        return Result.success(productService.searchProducts(keyword));
    }
}
