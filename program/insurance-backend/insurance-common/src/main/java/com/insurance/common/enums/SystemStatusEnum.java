package com.insurance.common.enums;

import lombok.Getter;

/**
 * 系统状态枚举
 */
@Getter
public enum SystemStatusEnum {

    ENABLE(1, "启用"),
    DISABLE(0, "禁用"),
    DELETED(-1, "已删除");

    private final int code;
    private final String desc;

    SystemStatusEnum(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static SystemStatusEnum getByCode(int code) {
        for (SystemStatusEnum value : values()) {
            if (value.getCode() == code) {
                return value;
            }
        }
        return null;
    }
}
