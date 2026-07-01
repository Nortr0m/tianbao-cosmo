package com.insurance.api.card.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.api.card.dto.CardTemplateQueryDTO;
import com.insurance.api.card.service.CardTemplateService;
import com.insurance.api.card.vo.CardTemplateUseVO;
import com.insurance.api.card.vo.CardTemplateVO;
import com.insurance.api.entity.CardTemplate;
import com.insurance.api.mapper.CardTemplateMapper;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 卡片模板Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CardTemplateServiceImpl implements CardTemplateService {

    private final CardTemplateMapper cardTemplateMapper;

    @Override
    public PageResult<CardTemplateVO> listCardTemplates(CardTemplateQueryDTO queryDTO) {
        Page<CardTemplate> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<CardTemplate> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CardTemplate::getIsActive, 1);

        if (queryDTO.getTemplateName() != null && !queryDTO.getTemplateName().isEmpty()) {
            wrapper.like(CardTemplate::getTemplateName, queryDTO.getTemplateName());
        }
        if (queryDTO.getCategoryCode() != null && !queryDTO.getCategoryCode().isEmpty()) {
            wrapper.eq(CardTemplate::getCategoryCode, queryDTO.getCategoryCode());
        }
        if (queryDTO.getIsRecommended() != null) {
            wrapper.eq(CardTemplate::getIsRecommended, queryDTO.getIsRecommended());
        }
        wrapper.orderByDesc(CardTemplate::getIsRecommended)
                .orderByAsc(CardTemplate::getSortOrder);

        Page<CardTemplate> resultPage = cardTemplateMapper.selectPage(page, wrapper);
        List<CardTemplateVO> list = resultPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public CardTemplateVO getCardTemplateDetail(Long templateId) {
        CardTemplate template = cardTemplateMapper.selectById(templateId);
        if (template == null) {
            throw new BusinessException("卡片模板不存在");
        }
        return convertToVO(template);
    }

    @Override
    public CardTemplateUseVO useCardTemplate(Long templateId) {
        CardTemplate template = cardTemplateMapper.selectById(templateId);
        if (template == null) {
            throw new BusinessException("卡片模板不存在");
        }
        if (template.getIsActive() == null || template.getIsActive() == 0) {
            throw new BusinessException("卡片模板已禁用");
        }

        // 更新使用次数
        template.setUseCountTotal(template.getUseCountTotal() != null ? template.getUseCountTotal() + 1 : 1);
        template.setUseCount7d(template.getUseCount7d() != null ? template.getUseCount7d() + 1 : 1);
        template.setUseCount30d(template.getUseCount30d() != null ? template.getUseCount30d() + 1 : 1);
        template.setLastUsedTime(LocalDateTime.now());
        cardTemplateMapper.updateById(template);

        CardTemplateUseVO vo = new CardTemplateUseVO();
        vo.setTemplateId(templateId);
        vo.setTemplateName(template.getTemplateName());
        vo.setSuccess(true);
        vo.setUseCountTotal(template.getUseCountTotal());
        vo.setUsedTime(LocalDateTime.now());
        return vo;
    }

    private CardTemplateVO convertToVO(CardTemplate template) {
        CardTemplateVO vo = new CardTemplateVO();
        BeanUtils.copyProperties(template, vo);
        return vo;
    }
}
