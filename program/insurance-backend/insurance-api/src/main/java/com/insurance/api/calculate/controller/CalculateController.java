package com.insurance.api.calculate.controller;

import com.insurance.api.calculate.dto.AnnuityProjectionDTO;
import com.insurance.api.calculate.dto.CriticalPremiumDTO;
import com.insurance.api.calculate.dto.WholeLifeProjectionDTO;
import com.insurance.api.calculate.service.CalculateService;
import com.insurance.api.calculate.vo.AnnuityProjectionVO;
import com.insurance.api.calculate.vo.CriticalPremiumVO;
import com.insurance.api.calculate.vo.WholeLifeProjectionVO;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 费率计算Controller
 */
@RestController
@RequestMapping("/api/v1/calculate")
@RequiredArgsConstructor
public class CalculateController {

    private final CalculateService calculateService;

    /**
     * 计算重疾险保费
     */
    @PostMapping("/critical-premium")
    public Result<CriticalPremiumVO> calculateCriticalPremium(@Validated @RequestBody CriticalPremiumDTO dto) {
        return Result.success(calculateService.calculateCriticalPremium(dto));
    }

    /**
     * 增额终身寿险收益测算
     */
    @PostMapping("/whole-life-projection")
    public Result<WholeLifeProjectionVO> calculateWholeLifeProjection(@Validated @RequestBody WholeLifeProjectionDTO dto) {
        return Result.success(calculateService.calculateWholeLifeProjection(dto));
    }

    /**
     * 年金险收益测算
     */
    @PostMapping("/annuity-projection")
    public Result<AnnuityProjectionVO> calculateAnnuityProjection(@Validated @RequestBody AnnuityProjectionDTO dto) {
        return Result.success(calculateService.calculateAnnuityProjection(dto));
    }
}
