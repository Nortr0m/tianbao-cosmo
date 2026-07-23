package com.insurance.admin.card.service;

import com.insurance.admin.card.dto.AdminCardCategoryCreateDTO;
import com.insurance.admin.card.dto.AdminCardCategoryQueryDTO;
import com.insurance.admin.card.dto.AdminCardCategoryUpdateDTO;
import com.insurance.admin.card.vo.AdminCardCategoryVO;
import com.insurance.common.result.PageResult;

/**
 * 管理员卡片分类Service接口
 */
public interface AdminCardCategoryService {

    /**
     * 分页查询卡片分类列表
     */
    PageResult<AdminCardCategoryVO> listCategories(AdminCardCategoryQueryDTO queryDTO);

    /**
     * 创建卡片分类
     */
    Long createCategory(AdminCardCategoryCreateDTO createDTO);

    /**
     * 更新卡片分类
     */
    void updateCategory(Long categoryId, AdminCardCategoryUpdateDTO updateDTO);

    /**
     * 删除卡片分类
     */
    void deleteCategory(Long categoryId);
}
