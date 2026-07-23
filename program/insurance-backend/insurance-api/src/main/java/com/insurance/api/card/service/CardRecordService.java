package com.insurance.api.card.service;

import com.insurance.api.card.dto.CardGenerateDTO;
import com.insurance.api.card.dto.CardRecordQueryDTO;
import com.insurance.api.card.vo.CardGenerateResultVO;
import com.insurance.api.card.vo.CardRecordVO;
import com.insurance.common.result.PageResult;

/**
 * 卡片记录Service接口
 */
public interface CardRecordService {

    /**
     * 生成卡片
     *
     * @param dto 生成卡片参数
     * @return 生成结果
     */
    CardGenerateResultVO generateCard(CardGenerateDTO dto);

    /**
     * 获取历史记录
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<CardRecordVO> getCardHistory(CardRecordQueryDTO queryDTO);

    /**
     * 删除卡片记录
     *
     * @param recordId 记录ID
     */
    void deleteCard(Long recordId);
}
