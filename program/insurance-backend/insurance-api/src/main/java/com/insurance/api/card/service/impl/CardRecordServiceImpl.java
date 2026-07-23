package com.insurance.api.card.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.api.card.dto.CardGenerateDTO;
import com.insurance.api.card.dto.CardRecordQueryDTO;
import com.insurance.api.card.service.CardRecordService;
import com.insurance.api.card.vo.CardGenerateResultVO;
import com.insurance.api.card.vo.CardRecordVO;
import com.insurance.api.entity.CardRecord;
import com.insurance.api.entity.CardTemplate;
import com.insurance.api.mapper.CardRecordMapper;
import com.insurance.api.mapper.CardTemplateMapper;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import com.insurance.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 卡片记录Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CardRecordServiceImpl implements CardRecordService {

    private final CardRecordMapper cardRecordMapper;
    private final CardTemplateMapper cardTemplateMapper;

    @Override
    public CardGenerateResultVO generateCard(CardGenerateDTO dto) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }

        // 获取模板信息
        String backgroundUrl = null;
        String cardTitle = null;
        String cardSubtitle = null;
        if (dto.getTemplateId() != null) {
            CardTemplate template = cardTemplateMapper.selectById(dto.getTemplateId());
            if (template != null) {
                backgroundUrl = template.getBackgroundUrl();
                cardTitle = template.getDefaultTitle();
                cardSubtitle = template.getDefaultSubtitle();
            }
        }

        // 构建记录
        CardRecord record = new CardRecord();
        BeanUtils.copyProperties(dto, record);
        record.setUserId(userId);
        record.setBackgroundUrl(backgroundUrl);
        record.setCardTitle(cardTitle);
        record.setCardSubtitle(cardSubtitle);
        // 暂时用模板背景图代替生成的图片
        record.setGeneratedImageUrl(backgroundUrl);
        record.setGenerateTime(LocalDateTime.now());

        cardRecordMapper.insert(record);

        // 返回结果
        CardGenerateResultVO resultVO = new CardGenerateResultVO();
        resultVO.setRecordId(record.getRecordId());
        resultVO.setImageUrl(record.getGeneratedImageUrl());
        resultVO.setGenerateTime(record.getGenerateTime());
        return resultVO;
    }

    @Override
    public PageResult<CardRecordVO> getCardHistory(CardRecordQueryDTO queryDTO) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }

        Page<CardRecord> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<CardRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CardRecord::getUserId, userId);

        if (queryDTO.getTemplateId() != null) {
            wrapper.eq(CardRecord::getTemplateId, queryDTO.getTemplateId());
        }
        if (queryDTO.getProductId() != null) {
            wrapper.eq(CardRecord::getProductId, queryDTO.getProductId());
        }
        wrapper.orderByDesc(CardRecord::getGenerateTime);

        Page<CardRecord> resultPage = cardRecordMapper.selectPage(page, wrapper);
        List<CardRecordVO> list = resultPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public void deleteCard(Long recordId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            throw new BusinessException("用户未登录");
        }

        CardRecord record = cardRecordMapper.selectById(recordId);
        if (record == null) {
            throw new BusinessException("卡片记录不存在");
        }
        if (!record.getUserId().equals(userId)) {
            throw new BusinessException("无权删除该记录");
        }

        cardRecordMapper.deleteById(recordId);
    }

    private CardRecordVO convertToVO(CardRecord record) {
        CardRecordVO vo = new CardRecordVO();
        BeanUtils.copyProperties(record, vo);
        return vo;
    }
}
