package com.insurance.admin.card.service;

import com.insurance.admin.card.dto.AdminCardTemplateCreateDTO;
import com.insurance.admin.card.dto.AdminCardTemplateQueryDTO;
import com.insurance.admin.card.dto.AdminCardTemplateUpdateDTO;
import com.insurance.admin.card.vo.AdminCardTemplateVO;
import com.insurance.admin.card.vo.CardTemplateStatsVO;
import com.insurance.common.result.PageResult;

/**
 * 管理员卡片模板Service接口
 */
public interface AdminCardTemplateService {

    /**
     * 分页查询卡片模板列表
     */
    PageResult<AdminCardTemplateVO> listCardTemplates(AdminCardTemplateQueryDTO queryDTO);

    /**
     * 创建卡片模板
     */
    Long createCardTemplate(AdminCardTemplateCreateDTO createDTO);

    /**
     * 更新卡片模板
     */
    void updateCardTemplate(Long templateId, AdminCardTemplateUpdateDTO updateDTO);

    /**
     * 删除卡片模板
     */
    void deleteCardTemplate(Long templateId);

    /**
     * 更新卡片模板状态（启用/禁用）
     */
    void updateCardTemplateStatus(Long templateId, Integer isActive);

    /**
     * 获取卡片模板统计
     */
    CardTemplateStatsVO getStats();
}