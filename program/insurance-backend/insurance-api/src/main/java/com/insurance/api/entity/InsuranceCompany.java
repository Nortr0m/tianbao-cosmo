package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 保险公司实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("insurance_company")
public class InsuranceCompany extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 保险公司ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long companyId;

    /** 保险公司名称 */
    private String companyName;

    /** 保险公司简称 */
    private String companyShortName;

    /** 保险公司编码 */
    private String companyCode;

    /** Logo地址 */
    private String logoUrl;

    /** 官方网站 */
    private String officialWebsite;

    /** 客服电话 */
    private String servicePhone;

    /** 成立年份 */
    private Integer establishedYear;

    /** 注册资本（万元） */
    private BigDecimal registeredCapital;

    /** 总部所在地 */
    private String headquarters;

    /** 公司类型（1-国企，2-民营，3-外资，4-合资） */
    private Integer companyType;

    /** 信用评级 */
    private String creditRating;

    /** 偿付能力充足率 */
    private BigDecimal solvencyRatio;

    /** 公司简介 */
    private String introduction;

    /** 特色标签（JSON数组） */
    private String featureTags;

    /** 合作状态（0-终止，1-合作中） */
    private Integer cooperationStatus;

    /** 合作开始日期 */
    private LocalDate cooperationStartDate;

    /** 排序 */
    private Integer sortOrder;

    /** 是否热门（0-否，1-是） */
    private Integer isHot;

    /** 备注 */
    private String remark;
}
