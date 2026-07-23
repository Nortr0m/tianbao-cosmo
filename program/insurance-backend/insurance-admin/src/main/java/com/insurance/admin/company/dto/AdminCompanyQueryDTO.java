package com.insurance.admin.company.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员保险公司查询DTO
 */
@Data
public class AdminCompanyQueryDTO implements Serializable {

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
}
