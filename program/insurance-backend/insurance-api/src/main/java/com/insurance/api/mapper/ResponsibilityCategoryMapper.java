package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.ResponsibilityCategory;
import org.apache.ibatis.annotations.Mapper;

/**
 * 一级分类 Mapper接口
 */
@Mapper
public interface ResponsibilityCategoryMapper extends BaseMapper<ResponsibilityCategory> {
}
