package com.insurance.api.card.controller;

import com.insurance.api.card.dto.CardTemplateQueryDTO;
import com.insurance.api.card.service.CardTemplateService;
import com.insurance.api.card.vo.CardTemplateUseVO;
import com.insurance.api.card.vo.CardTemplateVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 卡片模板Controller
 */
@RestController
@RequestMapping("/api/v1/card-template")
@RequiredArgsConstructor
public class CardTemplateController {

    private final CardTemplateService cardTemplateService;

    /**
     * 分页查询卡片模板列表
     */
    @GetMapping("/list")
    public Result<PageResult<CardTemplateVO>> listCardTemplates(@Validated CardTemplateQueryDTO queryDTO) {
        return Result.success(cardTemplateService.listCardTemplates(queryDTO));
    }

    /**
     * 获取卡片模板详情
     */
    @GetMapping("/{templateId}")
    public Result<CardTemplateVO> getCardTemplateDetail(@PathVariable Long templateId) {
        return Result.success(cardTemplateService.getCardTemplateDetail(templateId));
    }

    /**
     * 使用卡片模板
     */
    @PostMapping("/{templateId}/use")
    public Result<CardTemplateUseVO> useCardTemplate(@PathVariable Long templateId) {
        return Result.success(cardTemplateService.useCardTemplate(templateId));
    }
}
