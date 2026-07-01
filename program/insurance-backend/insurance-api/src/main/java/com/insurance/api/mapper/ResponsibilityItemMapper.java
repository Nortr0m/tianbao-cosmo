package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.ResponsibilityItem;
import org.apache.ibatis.annotations.Mapper;

/**
 * 二级责任项 Mapper接口
 */
@Mapper
public interface ResponsibilityItemMapper extends BaseMapper<ResponsibilityItem> {
}
