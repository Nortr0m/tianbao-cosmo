package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.CardCategory;
import org.apache.ibatis.annotations.Mapper;

/**
 * 卡片分类 Mapper接口
 */
@Mapper
public interface CardCategoryMapper extends BaseMapper<CardCategory> {
}
