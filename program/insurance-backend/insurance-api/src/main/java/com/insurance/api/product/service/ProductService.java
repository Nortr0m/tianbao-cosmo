package com.insurance.api.product.service;

import com.insurance.api.product.dto.ProductQueryDTO;
import com.insurance.api.product.vo.ProductResponsibilityVO;
import com.insurance.api.product.vo.ProductVO;
import com.insurance.common.result.PageResult;

import java.util.List;
import java.util.Map;

/**
 * 产品Service接口
 */
public interface ProductService {

    /**
     * 分页查询产品列表（自动过滤system_status=1 AND sale_status IN (1,2)）
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<ProductVO> listProducts(ProductQueryDTO queryDTO);

    /**
     * 获取产品详情（含子类数据）
     *
     * @param productId 产品ID
     * @return 产品详情
     */
    ProductVO getProductDetail(Long productId);

    /**
     * 获取产品责任配置
     *
     * @param productId 产品ID
     * @return 责任配置
     */
    ProductResponsibilityVO getProductResponsibilities(Long productId);

    /**
     * 获取热门产品列表
     */
    List<ProductVO> getHotProducts(int limit);

    /**
     * 获取产品类型列表
     */
    List<Map<String, Object>> getProductTypes();

    /**
     * 搜索产品
     */
    List<ProductVO> searchProducts(String keyword);
}
