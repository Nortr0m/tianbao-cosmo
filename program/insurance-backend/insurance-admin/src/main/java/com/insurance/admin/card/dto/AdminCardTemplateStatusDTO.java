package com.insurance.admin.card.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 卡片模板状态更新DTO
 */
@Data
public class AdminCardTemplateStatusDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;
}