package com.insurance.admin.card.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.admin.card.dto.AdminCardCategoryCreateDTO;
import com.insurance.admin.card.dto.AdminCardCategoryQueryDTO;
import com.insurance.admin.card.dto.AdminCardCategoryUpdateDTO;
import com.insurance.admin.card.service.AdminCardCategoryService;
import com.insurance.admin.card.vo.AdminCardCategoryVO;
import com.insurance.api.entity.CardCategory;
import com.insurance.api.mapper.CardCategoryMapper;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 管理员卡片分类Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminCardCategoryServiceImpl implements AdminCardCategoryService {

    private final CardCategoryMapper cardCategoryMapper;

    @Override
    public PageResult<AdminCardCategoryVO> listCategories(AdminCardCategoryQueryDTO queryDTO) {
        Page<CardCategory> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<CardCategory> wrapper = new LambdaQueryWrapper<>();

        if (queryDTO.getCategoryCode() != null && !queryDTO.getCategoryCode().isEmpty()) {
            wrapper.like(CardCategory::getCategoryCode, queryDTO.getCategoryCode());
        }
        if (queryDTO.getCategoryName() != null && !queryDTO.getCategoryName().isEmpty()) {
            wrapper.like(CardCategory::getCategoryName, queryDTO.getCategoryName());
        }
        if (queryDTO.getIsActive() != null) {
            wrapper.eq(CardCategory::getIsActive, queryDTO.getIsActive());
        }
        wrapper.orderByAsc(CardCategory::getSortOrder)
               .orderByDesc(CardCategory::getCreatedAt);

        Page<CardCategory> resultPage = cardCategoryMapper.selectPage(page, wrapper);
        List<AdminCardCategoryVO> list = resultPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public Long createCategory(AdminCardCategoryCreateDTO createDTO) {
        // 检查分类编码是否已存在
        LambdaQueryWrapper<CardCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CardCategory::getCategoryCode, createDTO.getCategoryCode());
        Long count = cardCategoryMapper.selectCount(wrapper);
        if (count != null && count > 0) {
            throw new BusinessException("分类编码已存在");
        }

        CardCategory category = new CardCategory();
        BeanUtils.copyProperties(createDTO, category);
        if (category.getSortOrder() == null) {
            category.setSortOrder(0);
        }
        if (category.getIsActive() == null) {
            category.setIsActive(1);
        }
        cardCategoryMapper.insert(category);
        return category.getCategoryId();
    }

    @Override
    public void updateCategory(Long categoryId, AdminCardCategoryUpdateDTO updateDTO) {
        CardCategory category = cardCategoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException("卡片分类不存在");
        }

        // 如果修改了分类编码，检查新编码是否已存在
        if (updateDTO.getCategoryCode() != null && !updateDTO.getCategoryCode().equals(category.getCategoryCode())) {
            LambdaQueryWrapper<CardCategory> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(CardCategory::getCategoryCode, updateDTO.getCategoryCode());
            Long count = cardCategoryMapper.selectCount(wrapper);
            if (count != null && count > 0) {
                throw new BusinessException("分类编码已存在");
            }
        }

        BeanUtils.copyProperties(updateDTO, category);
        cardCategoryMapper.updateById(category);
    }

    @Override
    public void deleteCategory(Long categoryId) {
        CardCategory category = cardCategoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException("卡片分类不存在");
        }
        cardCategoryMapper.deleteById(categoryId);
    }

    private AdminCardCategoryVO convertToVO(CardCategory category) {
        AdminCardCategoryVO vo = new AdminCardCategoryVO();
        BeanUtils.copyProperties(category, vo);
        return vo;
    }
}
