package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.ProductResponsibility;
import org.apache.ibatis.annotations.Mapper;

/**
 * 产品-责任关联 Mapper接口
 */
@Mapper
public interface ProductResponsibilityMapper extends BaseMapper<ProductResponsibility> {
}
