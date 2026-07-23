package com.insurance.api.compare.service;

import com.insurance.api.compare.dto.AnnuityCompareDTO;
import com.insurance.api.compare.dto.CriticalIllnessCompareDTO;
import com.insurance.api.compare.dto.WholeLifeCompareDTO;
import com.insurance.api.compare.vo.CompareResultVO;

/**
 * 产品对比Service接口
 */
public interface CompareService {

    /**
     * 重疾产品对比
     */
    CompareResultVO compareCriticalIllness(CriticalIllnessCompareDTO dto);

    /**
     * 终身寿险产品对比
     */
    CompareResultVO compareWholeLife(WholeLifeCompareDTO dto);

    /**
     * 年金产品对比
     */
    CompareResultVO compareAnnuity(AnnuityCompareDTO dto);
}
