package com.insurance.common.enums;

import lombok.Getter;

/**
 * 股东类型枚举
 * 1=企业法人, 2=自然人, 3=政府机构, 4=央企, 5=地方国资, 6=外资, 7=其他
 */
@Getter
public enum ShareholderTypeEnum {

    ENTERPRISE(1, "企业法人"),
    NATURAL_PERSON(2, "自然人"),
    GOVERNMENT(3, "政府机构"),
    CENTRAL_SOE(4, "央企"),
    LOCAL_SOE(5, "地方国资"),
    FOREIGN(6, "外资"),
    OTHER(7, "其他");

    private final int code;
    private final String desc;

    ShareholderTypeEnum(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static ShareholderTypeEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (ShareholderTypeEnum value : values()) {
            if (value.getCode() == code) {
                return value;
            }
        }
        return null;
    }
}
