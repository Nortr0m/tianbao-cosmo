package com.insurance.common.enums;

import lombok.Getter;

/**
 * 会员等级枚举
 * 0=普通 1=VIP 2=SVIP
 */
@Getter
public enum MemberLevelEnum {

    NORMAL(0, "普通"),
    VIP(1, "VIP"),
    SVIP(2, "SVIP");

    private final int level;
    private final String desc;

    MemberLevelEnum(int level, String desc) {
        this.level = level;
        this.desc = desc;
    }

    public static MemberLevelEnum getByLevel(int level) {
        for (MemberLevelEnum value : values()) {
            if (value.getLevel() == level) {
                return value;
            }
        }
        return null;
    }
}
