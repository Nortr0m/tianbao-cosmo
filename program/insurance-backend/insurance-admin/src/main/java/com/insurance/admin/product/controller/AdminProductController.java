package com.insurance.admin.product.controller;

import com.insurance.admin.product.dto.AdminProductCreateDTO;
import com.insurance.admin.product.dto.AdminProductQueryDTO;
import com.insurance.admin.product.dto.AdminProductUpdateDTO;
import com.insurance.admin.product.service.AdminProductService;
import com.insurance.admin.product.vo.AdminProductVO;
import com.insurance.admin.product.vo.AnnuityRateImportResultVO;
import com.insurance.admin.product.vo.PremiumRateImportResultVO;
import com.insurance.admin.product.vo.WholeLifeRateImportResultVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * 管理员产品Controller
 */
@RestController
@RequestMapping("/api/v1/admin/product")
@RequiredArgsConstructor
public class AdminProductController {

    private final AdminProductService adminProductService;

    /**
     * 分页查询产品列表（全量，支持双状态筛选）
     */
    @GetMapping("/list")
    public Result<PageResult<AdminProductVO>> listProducts(@Validated AdminProductQueryDTO queryDTO) {
        return Result.success(adminProductService.listProducts(queryDTO));
    }

    /**
     * 创建产品
     */
    @PostMapping
    public Result<Long> createProduct(@Validated @RequestBody AdminProductCreateDTO createDTO) {
        return Result.success(adminProductService.createProduct(createDTO));
    }

    /**
     * 更新产品
     */
    @PutMapping("/{productId}")
    public Result<Void> updateProduct(@PathVariable Long productId,
                                       @RequestBody AdminProductUpdateDTO updateDTO) {
        adminProductService.updateProduct(productId, updateDTO);
        return Result.success();
    }

    /**
     * 更新产品系统状态
     */
    @PutMapping("/{productId}/system-status")
    public Result<Void> updateSystemStatus(@PathVariable Long productId,
                                            @RequestParam Integer systemStatus) {
        adminProductService.updateSystemStatus(productId, systemStatus);
        return Result.success();
    }

    /**
     * 更新产品销售状态
     */
    @PutMapping("/{productId}/sale-status")
    public Result<Void> updateSaleStatus(@PathVariable Long productId,
                                          @RequestParam Integer saleStatus) {
        adminProductService.updateSaleStatus(productId, saleStatus);
        return Result.success();
    }

    /**
     * 获取产品详情
     */
    @GetMapping("/{productId}")
    public Result<AdminProductVO> getProductDetail(@PathVariable Long productId) {
        return Result.success(adminProductService.getProductDetail(productId));
    }

    /**
     * 导入增额终身寿险费率/现金价值
     */
    @PostMapping("/{productId}/import-rates")
    public Result<WholeLifeRateImportResultVO> importRates(
            @PathVariable Long productId,
            @RequestParam("file") MultipartFile file) {
        return Result.success(adminProductService.importWholeLifeRates(productId, file));
    }

    /**
     * 导入年金险费率/现金价值
     */
    @PostMapping("/{productId}/import-annuity-rates")
    public Result<AnnuityRateImportResultVO> importAnnuityRates(
            @PathVariable Long productId,
            @RequestParam("file") MultipartFile file) {
        return Result.success(adminProductService.importAnnuityRates(productId, file));
    }

    /**
     * 导入重疾险费率
     */
    @PostMapping("/{productId}/import-premium-rates")
    public Result<PremiumRateImportResultVO> importPremiumRates(
            @PathVariable Long productId,
            @RequestParam("file") MultipartFile file) {
        return Result.success(adminProductService.importPremiumRates(productId, file));
    }
}
