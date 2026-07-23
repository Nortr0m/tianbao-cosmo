package com.insurance.api.compare.controller;

import com.insurance.api.compare.dto.AnnuityCompareDTO;
import com.insurance.api.compare.dto.CriticalIllnessCompareDTO;
import com.insurance.api.compare.dto.WholeLifeCompareDTO;
import com.insurance.api.compare.service.CompareService;
import com.insurance.api.compare.vo.CompareResultVO;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 产品对比Controller
 */
@RestController
@RequestMapping("/api/v1/compare")
@RequiredArgsConstructor
public class CompareController {

    private final CompareService compareService;

    /**
     * 重疾险对比
     */
    @PostMapping("/critical-illness")
    public Result<CompareResultVO> compareCriticalIllness(@Validated @RequestBody CriticalIllnessCompareDTO dto) {
        return Result.success(compareService.compareCriticalIllness(dto));
    }

    /**
     * 增额终身寿险对比
     */
    @PostMapping("/whole-life")
    public Result<CompareResultVO> compareWholeLife(@Validated @RequestBody WholeLifeCompareDTO dto) {
        return Result.success(compareService.compareWholeLife(dto));
    }

    /**
     * 年金险对比
     */
    @PostMapping("/annuity")
    public Result<CompareResultVO> compareAnnuity(@Validated @RequestBody AnnuityCompareDTO dto) {
        return Result.success(compareService.compareAnnuity(dto));
    }
}
