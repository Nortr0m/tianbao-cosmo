package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.CardRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * 卡片生成记录 Mapper接口
 */
@Mapper
public interface CardRecordMapper extends BaseMapper<CardRecord> {
}
