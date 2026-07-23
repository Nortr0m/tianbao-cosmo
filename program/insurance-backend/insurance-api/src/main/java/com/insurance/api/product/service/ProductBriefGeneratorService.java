package com.insurance.api.product.service;

import com.insurance.api.product.vo.ProductBriefVO;

/**
 * 产品简介自动生成服务
 * 从产品已有数据（责任、疾病、费率）自动生成简介内容
 */
public interface ProductBriefGeneratorService {

    /**
     * 生成产品简介
     * @param productId 产品ID
     * @return 生成后的简介VO
     */
    ProductBriefVO generateProductBrief(Long productId);

    /**
     * 生成并保存产品简介
     * @param productId 产品ID
     * @return 是否成功
     */
    boolean generateAndSave(Long productId);
}
