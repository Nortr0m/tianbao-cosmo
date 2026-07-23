package com.insurance.common.enums;

import lombok.Getter;

/**
 * 公司关联类型枚举
 * 1=同一集团, 2=同一股东, 3=母子公司, 4=参股投资, 5=接管重组
 */
@Getter
public enum CompanyRelationTypeEnum {

    SAME_GROUP(1, "同一集团"),
    SAME_SHAREHOLDER(2, "同一股东"),
    PARENT_CHILD(3, "母子公司"),
    EQUITY_INVESTMENT(4, "参股投资"),
    TAKEOVER_RESTRUCTURE(5, "接管重组");

    private final int code;
    private final String desc;

    CompanyRelationTypeEnum(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static CompanyRelationTypeEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (CompanyRelationTypeEnum value : values()) {
            if (value.getCode() == code) {
                return value;
            }
        }
        return null;
    }
}
