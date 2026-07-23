package com.insurance.api.card.controller;

import com.insurance.api.card.dto.CardGenerateDTO;
import com.insurance.api.card.dto.CardRecordQueryDTO;
import com.insurance.api.card.service.CardRecordService;
import com.insurance.api.card.vo.CardGenerateResultVO;
import com.insurance.api.card.vo.CardRecordVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 卡片记录Controller
 */
@RestController
@RequestMapping("/api/v1/card")
@RequiredArgsConstructor
public class CardRecordController {

    private final CardRecordService cardRecordService;

    /**
     * 生成卡片
     */
    @PostMapping("/generate")
    public Result<CardGenerateResultVO> generateCard(@Validated @RequestBody CardGenerateDTO dto) {
        return Result.success(cardRecordService.generateCard(dto));
    }

    /**
     * 获取历史记录
     */
    @GetMapping("/history")
    public Result<PageResult<CardRecordVO>> getCardHistory(@Validated CardRecordQueryDTO queryDTO) {
        return Result.success(cardRecordService.getCardHistory(queryDTO));
    }

    /**
     * 删除卡片记录
     */
    @DeleteMapping("/{recordId}")
    public Result<Void> deleteCard(@PathVariable Long recordId) {
        cardRecordService.deleteCard(recordId);
        return Result.success();
    }
}
