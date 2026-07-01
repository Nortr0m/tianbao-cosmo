package com.insurance.common.enums;

import lombok.Getter;

/**
 * 缴费期限枚举
 */
@Getter
public enum PaymentPeriodEnum {

    ONE_YEAR("ONE_YEAR", "趸交", 1),
    THREE_YEAR("THREE_YEAR", "3年交", 3),
    FIVE_YEAR("FIVE_YEAR", "5年交", 5),
    TEN_YEAR("TEN_YEAR", "10年交", 10),
    FIFTEEN_YEAR("FIFTEEN_YEAR", "15年交", 15),
    TWENTY_YEAR("TWENTY_YEAR", "20年交", 20),
    THIRTY_YEAR("THIRTY_YEAR", "30年交", 30),
    TO_60("TO_60", "交至60岁", 0),
    TO_65("TO_65", "交至65岁", 0),
    TO_70("TO_70", "交至70岁", 0);

    private final String code;
    private final String desc;
    private final int years;

    PaymentPeriodEnum(String code, String desc, int years) {
        this.code = code;
        this.desc = desc;
        this.years = years;
    }

    public static PaymentPeriodEnum getByCode(String code) {
        for (PaymentPeriodEnum value : values()) {
            if (value.getCode().equals(code)) {
                return value;
            }
        }
        return null;
    }
}
