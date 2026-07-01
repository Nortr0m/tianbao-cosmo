package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.CompanyRatingHistory;
import org.apache.ibatis.annotations.Mapper;

/**
 * 评级历史 Mapper接口
 */
@Mapper
public interface CompanyRatingHistoryMapper extends BaseMapper<CompanyRatingHistory> {
}
