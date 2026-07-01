package com.insurance.api.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 保险宇宙首页保险公司数据VO
 */
@Data
public class CompanyCosmosVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 保险公司ID */
    private Long companyId;

    /** 保险公司名称 */
    private String companyName;

    /** 保险公司简称 */
    private String companyShortName;

    /** 公司性质（央企/国资/合资/外资/民营） */
    private String nature;

    /** 注册资本（万元） */
    private BigDecimal capital;

    /** 产品数量 */
    private Integer productCount;

    /** 产品类型分布 */
    private List<String> productTypes;
}
