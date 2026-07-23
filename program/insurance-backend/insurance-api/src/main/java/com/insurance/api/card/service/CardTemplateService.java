package com.insurance.api.card.service;

import com.insurance.api.card.dto.CardTemplateQueryDTO;
import com.insurance.api.card.vo.CardTemplateUseVO;
import com.insurance.api.card.vo.CardTemplateVO;
import com.insurance.common.result.PageResult;

/**
 * 卡片模板Service接口
 */
public interface CardTemplateService {

    /**
     * 分页查询卡片模板列表
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<CardTemplateVO> listCardTemplates(CardTemplateQueryDTO queryDTO);

    /**
     * 获取卡片模板详情
     *
     * @param templateId 模板ID
     * @return 模板详情
     */
    CardTemplateVO getCardTemplateDetail(Long templateId);

    /**
     * 使用卡片模板
     *
     * @param templateId 模板ID
     * @return 使用结果
     */
    CardTemplateUseVO useCardTemplate(Long templateId);
}
