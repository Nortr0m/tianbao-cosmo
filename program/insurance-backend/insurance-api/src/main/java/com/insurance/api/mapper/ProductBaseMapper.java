package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.ProductBase;
import org.apache.ibatis.annotations.Mapper;

/**
 * 产品父类 Mapper接口
 */
@Mapper
public interface ProductBaseMapper extends BaseMapper<ProductBase> {
}
