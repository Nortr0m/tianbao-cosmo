package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.WholeLifeProduct;
import org.apache.ibatis.annotations.Mapper;

/**
 * 增额终身寿险子类 Mapper接口
 */
@Mapper
public interface WholeLifeProductMapper extends BaseMapper<WholeLifeProduct> {
}
