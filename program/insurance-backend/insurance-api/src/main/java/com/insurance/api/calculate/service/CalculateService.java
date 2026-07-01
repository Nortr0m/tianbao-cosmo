package com.insurance.api.calculate.service;

import com.insurance.api.calculate.dto.AnnuityProjectionDTO;
import com.insurance.api.calculate.dto.CriticalPremiumDTO;
import com.insurance.api.calculate.dto.WholeLifeProjectionDTO;
import com.insurance.api.calculate.vo.AnnuityProjectionVO;
import com.insurance.api.calculate.vo.CriticalPremiumVO;
import com.insurance.api.calculate.vo.WholeLifeProjectionVO;

/**
 * 费率计算Service接口
 */
public interface CalculateService {

    /**
     * 计算重疾险保费
     *
     * @param dto 计算参数
     * @return 计算结果
     */
    CriticalPremiumVO calculateCriticalPremium(CriticalPremiumDTO dto);

    /**
     * 增额终身寿险收益测算
     *
     * @param dto 测算参数
     * @return 测算结果
     */
    WholeLifeProjectionVO calculateWholeLifeProjection(WholeLifeProjectionDTO dto);

    /**
     * 年金险收益测算
     *
     * @param dto 测算参数
     * @return 测算结果
     */
    AnnuityProjectionVO calculateAnnuityProjection(AnnuityProjectionDTO dto);
}
