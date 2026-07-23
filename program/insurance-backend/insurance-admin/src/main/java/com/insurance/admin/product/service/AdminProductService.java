package com.insurance.admin.product.service;

import com.insurance.admin.product.dto.AdminProductCreateDTO;
import com.insurance.admin.product.dto.AdminProductQueryDTO;
import com.insurance.admin.product.dto.AdminProductUpdateDTO;
import com.insurance.admin.product.vo.AdminProductVO;
import com.insurance.admin.product.vo.AnnuityRateImportResultVO;
import com.insurance.admin.product.vo.PremiumRateImportResultVO;
import com.insurance.admin.product.vo.WholeLifeRateImportResultVO;
import com.insurance.common.result.PageResult;

/**
 * 管理员产品Service接口
 */
public interface AdminProductService {

    /**
     * 分页查询产品列表（全量，支持双状态筛选）
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<AdminProductVO> listProducts(AdminProductQueryDTO queryDTO);

    /**
     * 创建产品
     *
     * @param createDTO 创建信息
     * @return 产品ID
     */
    Long createProduct(AdminProductCreateDTO createDTO);

    /**
     * 更新产品
     *
     * @param productId 产品ID
     * @param updateDTO 更新信息
     */
    void updateProduct(Long productId, AdminProductUpdateDTO updateDTO);

    /**
     * 更新产品系统状态
     *
     * @param productId 产品ID
     * @param systemStatus 系统状态
     */
    void updateSystemStatus(Long productId, Integer systemStatus);

    /**
     * 更新产品销售状态
     *
     * @param productId 产品ID
     * @param saleStatus 销售状态
     */
    void updateSaleStatus(Long productId, Integer saleStatus);

    /**
     * 获取产品详情
     *
     * @param productId 产品ID
     * @return 产品详情
     */
    AdminProductVO getProductDetail(Long productId);

    /**
     * 导入增额终身寿险费率/现金价值
     *
     * @param productId 产品ID
     * @param file Excel文件
     * @return 导入结果
     */
    WholeLifeRateImportResultVO importWholeLifeRates(Long productId, org.springframework.web.multipart.MultipartFile file);

    /**
     * 导入年金险费率/现金价值
     *
     * @param productId 产品ID
     * @param file 文件
     * @return 导入结果
     */
    AnnuityRateImportResultVO importAnnuityRates(Long productId, org.springframework.web.multipart.MultipartFile file);

    /**
     * 导入重疾险费率
     *
     * @param productId 产品ID
     * @param file Excel文件
     * @return 导入结果
     */
    PremiumRateImportResultVO importPremiumRates(Long productId, org.springframework.web.multipart.MultipartFile file);
}
