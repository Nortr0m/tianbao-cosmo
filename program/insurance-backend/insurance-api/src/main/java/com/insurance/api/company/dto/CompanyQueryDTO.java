package com.insurance.api.company.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 保险公司查询DTO
 */
@Data
public class CompanyQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 保险公司名称 */
    private String companyName;

    /** 公司类型 */
    private Integer companyType;

    /** 合作状态 */
    private Integer cooperationStatus;

    /** 是否热门 */
    private Integer isHot;
}
