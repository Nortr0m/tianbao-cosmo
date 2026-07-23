package com.insurance.admin.card.controller;

import com.insurance.admin.card.dto.AdminCardCategoryCreateDTO;
import com.insurance.admin.card.dto.AdminCardCategoryQueryDTO;
import com.insurance.admin.card.dto.AdminCardCategoryUpdateDTO;
import com.insurance.admin.card.service.AdminCardCategoryService;
import com.insurance.admin.card.vo.AdminCardCategoryVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员卡片分类Controller
 */
@RestController
@RequestMapping("/api/v1/admin/card-category")
@RequiredArgsConstructor
public class AdminCardCategoryController {

    private final AdminCardCategoryService adminCardCategoryService;

    /**
     * 分页查询卡片分类列表
     */
    @GetMapping("/list")
    public Result<PageResult<AdminCardCategoryVO>> listCategories(@Validated AdminCardCategoryQueryDTO queryDTO) {
        return Result.success(adminCardCategoryService.listCategories(queryDTO));
    }

    /**
     * 创建卡片分类
     */
    @PostMapping
    public Result<Long> createCategory(@Validated @RequestBody AdminCardCategoryCreateDTO createDTO) {
        return Result.success(adminCardCategoryService.createCategory(createDTO));
    }

    /**
     * 更新卡片分类
     */
    @PutMapping("/{categoryId}")
    public Result<Void> updateCategory(@PathVariable Long categoryId,
                                        @RequestBody AdminCardCategoryUpdateDTO updateDTO) {
        adminCardCategoryService.updateCategory(categoryId, updateDTO);
        return Result.success();
    }

    /**
     * 删除卡片分类
     */
    @DeleteMapping("/{categoryId}")
    public Result<Void> deleteCategory(@PathVariable Long categoryId) {
        adminCardCategoryService.deleteCategory(categoryId);
        return Result.success();
    }
}
