package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.AnnuityProduct;
import org.apache.ibatis.annotations.Mapper;

/**
 * 年金险子类 Mapper接口
 */
@Mapper
public interface AnnuityProductMapper extends BaseMapper<AnnuityProduct> {
}
