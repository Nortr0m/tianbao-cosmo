package com.insurance.common.enums;

import lombok.Getter;

/**
 * 产品维护状态枚举
 */
@Getter
public enum MaintenanceStatusEnum {

    PARSING(0, "解析中"),
    PENDING_CONFIRM(1, "待人工确认"),
    CONFIRMED(2, "已确认"),
    OFFLINE(3, "下线");

    private final Integer code;
    private final String desc;

    MaintenanceStatusEnum(Integer code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static MaintenanceStatusEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (MaintenanceStatusEnum value : values()) {
            if (value.getCode().equals(code)) {
                return value;
            }
        }
        return null;
    }

    public static String getDescByCode(Integer code) {
        MaintenanceStatusEnum enumValue = getByCode(code);
        return enumValue == null ? "" : enumValue.getDesc();
    }
}
