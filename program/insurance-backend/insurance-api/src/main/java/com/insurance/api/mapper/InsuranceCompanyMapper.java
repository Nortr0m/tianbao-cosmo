package com.insurance.api.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insurance.api.company.vo.CompanyCosmosVO;
import com.insurance.api.entity.InsuranceCompany;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 保险公司 Mapper接口
 */
@Mapper
public interface InsuranceCompanyMapper extends BaseMapper<InsuranceCompany> {

    /**
     * 查询保险宇宙首页数据（公司+产品聚合统计）
     */
    @Select("SELECT " +
            "  c.company_id AS companyId, " +
            "  c.company_name AS companyName, " +
            "  c.company_short_name AS companyShortName, " +
            "  CASE c.company_type " +
            "    WHEN 1 THEN '央企' " +
            "    WHEN 2 THEN '国资' " +
            "    WHEN 3 THEN '合资' " +
            "    WHEN 4 THEN '外资' " +
            "    WHEN 5 THEN '民营' " +
            "    ELSE '其他' " +
            "  END AS nature, " +
            "  c.registered_capital AS capital, " +
            "  COUNT(p.product_id) AS productCount, " +
            "  GROUP_CONCAT(DISTINCT CASE p.product_type " +
            "    WHEN 1 THEN '重疾险' " +
            "    WHEN 2 THEN '增额终身寿' " +
            "    WHEN 3 THEN '年金险' " +
            "    ELSE NULL " +
            "  END) AS productTypes " +
            "FROM insurance_company c " +
            "LEFT JOIN product_base p ON c.company_id = p.company_id " +
            "  AND p.system_status = 1 AND p.maintenance_status = 2 AND p.is_deleted = 0 " +
            "WHERE c.cooperation_status = 1 " +
            "GROUP BY c.company_id, c.company_name, c.company_short_name, c.company_type, c.registered_capital " +
            "ORDER BY c.sort_order")
    List<CompanyCosmosVO> selectCosmosData();
}
