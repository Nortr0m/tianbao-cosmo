package com.insurance.api.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * VIP权限VO
 */
@Data
public class VipPermissionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    private Long userId;

    /** 当前会员等级 */
    private Integer memberLevel;

    /** 权限列表 */
    private List<String> permissions;

    /** 功能列表 */
    private List<String> features;
}
