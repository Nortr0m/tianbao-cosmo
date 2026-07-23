package com.insurance.admin.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 权限实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("admin_permission")
public class AdminPermission extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 权限ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long permissionId;

    /** 权限编码 */
    private String permissionCode;

    /** 权限名称 */
    private String permissionName;

    /** 父权限ID */
    private Long parentId;

    /** 权限类型（1-菜单，2-按钮，3-接口） */
    private Integer permissionType;

    /** 路由路径 */
    private String path;

    /** 排序 */
    private Integer sortOrder;

    /** 状态（0-禁用，1-正常） */
    private Integer status;
}
