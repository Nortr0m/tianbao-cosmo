package com.insurance.admin.card.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.admin.card.dto.AdminCardTemplateCreateDTO;
import com.insurance.admin.card.dto.AdminCardTemplateQueryDTO;
import com.insurance.admin.card.dto.AdminCardTemplateUpdateDTO;
import com.insurance.admin.card.service.AdminCardTemplateService;
import com.insurance.admin.card.vo.AdminCardTemplateVO;
import com.insurance.admin.card.vo.CardTemplateStatsVO;
import com.insurance.api.entity.CardTemplate;
import com.insurance.api.mapper.CardTemplateMapper;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 管理员卡片模板Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminCardTemplateServiceImpl implements AdminCardTemplateService {

    private final CardTemplateMapper cardTemplateMapper;

    @Override
    public PageResult<AdminCardTemplateVO> listCardTemplates(AdminCardTemplateQueryDTO queryDTO) {
        Page<CardTemplate> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<CardTemplate> wrapper = new LambdaQueryWrapper<>();

        // 支持keyword模糊搜索（搜索templateName和searchKeywords）
        if (queryDTO.getKeyword() != null && !queryDTO.getKeyword().isEmpty()) {
            wrapper.and(w -> w
                    .like(CardTemplate::getTemplateName, queryDTO.getKeyword())
                    .or()
                    .like(CardTemplate::getSearchKeywords, queryDTO.getKeyword())
            );
        }
        // 兼容旧的templateName精确搜索
        if (queryDTO.getTemplateName() != null && !queryDTO.getTemplateName().isEmpty()) {
            wrapper.like(CardTemplate::getTemplateName, queryDTO.getTemplateName());
        }
        if (queryDTO.getCategoryCode() != null && !queryDTO.getCategoryCode().isEmpty()) {
            wrapper.eq(CardTemplate::getCategoryCode, queryDTO.getCategoryCode());
        }
        if (queryDTO.getIsActive() != null) {
            wrapper.eq(CardTemplate::getIsActive, queryDTO.getIsActive());
        }
        wrapper.orderByDesc(CardTemplate::getSortOrder)
               .orderByDesc(CardTemplate::getCreatedAt);

        Page<CardTemplate> resultPage = cardTemplateMapper.selectPage(page, wrapper);
        List<AdminCardTemplateVO> list = resultPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public Long createCardTemplate(AdminCardTemplateCreateDTO createDTO) {
        CardTemplate template = new CardTemplate();
        BeanUtils.copyProperties(createDTO, template);
        cardTemplateMapper.insert(template);
        return template.getTemplateId();
    }

    @Override
    public void updateCardTemplate(Long templateId, AdminCardTemplateUpdateDTO updateDTO) {
        CardTemplate template = cardTemplateMapper.selectById(templateId);
        if (template == null) {
            throw new BusinessException("卡片模板不存在");
        }
        BeanUtils.copyProperties(updateDTO, template);
        cardTemplateMapper.updateById(template);
    }

    @Override
    public void deleteCardTemplate(Long templateId) {
        CardTemplate template = cardTemplateMapper.selectById(templateId);
        if (template == null) {
            throw new BusinessException("卡片模板不存在");
        }
        cardTemplateMapper.deleteById(templateId);
    }

    @Override
    public void updateCardTemplateStatus(Long templateId, Integer isActive) {
        CardTemplate template = cardTemplateMapper.selectById(templateId);
        if (template == null) {
            throw new BusinessException("卡片模板不存在");
        }
        template.setIsActive(isActive);
        cardTemplateMapper.updateById(template);
    }

    @Override
    public CardTemplateStatsVO getStats() {
        List<CardTemplate> all = cardTemplateMapper.selectList(null);
        CardTemplateStatsVO vo = new CardTemplateStatsVO();
        vo.setTotalCount((long) all.size());
        vo.setActiveCount(all.stream().filter(t -> t.getIsActive() != null && t.getIsActive() == 1).count());
        vo.setInactiveCount(all.stream().filter(t -> t.getIsActive() != null && t.getIsActive() == 0).count());
        vo.setSystemCount(all.stream().filter(t -> t.getIsSystem() != null && t.getIsSystem() == 1).count());
        vo.setRecommendedCount(all.stream().filter(t -> t.getIsRecommended() != null && t.getIsRecommended() == 1).count());
        vo.setTotalUseCount(all.stream().mapToLong(t -> t.getUseCountTotal() != null ? t.getUseCountTotal() : 0).sum());
        vo.setTotalUseCount7d(all.stream().mapToLong(t -> t.getUseCount7d() != null ? t.getUseCount7d() : 0).sum());
        vo.setTotalUseCount30d(all.stream().mapToLong(t -> t.getUseCount30d() != null ? t.getUseCount30d() : 0).sum());
        return vo;
    }

    private AdminCardTemplateVO convertToVO(CardTemplate template) {
        AdminCardTemplateVO vo = new AdminCardTemplateVO();
        BeanUtils.copyProperties(template, vo);
        return vo;
    }
}