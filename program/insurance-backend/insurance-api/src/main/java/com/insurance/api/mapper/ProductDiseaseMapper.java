package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.ProductDisease;
import org.apache.ibatis.annotations.Mapper;

/**
 * 产品-疾病关联 Mapper接口
 */
@Mapper
public interface ProductDiseaseMapper extends BaseMapper<ProductDisease> {
}
