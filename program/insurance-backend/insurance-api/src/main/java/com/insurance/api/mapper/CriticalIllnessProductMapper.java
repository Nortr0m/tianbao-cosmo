package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.CriticalIllnessProduct;
import org.apache.ibatis.annotations.Mapper;

/**
 * 重疾险子类 Mapper接口
 */
@Mapper
public interface CriticalIllnessProductMapper extends BaseMapper<CriticalIllnessProduct> {
}
