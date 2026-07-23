package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.entity.Disease;
import org.apache.ibatis.annotations.Mapper;

/**
 * 疾病字典 Mapper接口
 */
@Mapper
public interface DiseaseMapper extends BaseMapper<Disease> {
}
