package com.insurance.admin.product.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.insurance.admin.product.dto.AdminProductCreateDTO;
import com.insurance.admin.product.dto.AdminProductQueryDTO;
import com.insurance.admin.product.dto.AdminProductUpdateDTO;
import com.insurance.admin.product.dto.AnnuityRateImportDTO;
import com.insurance.admin.product.dto.PremiumRateImportDTO;
import com.insurance.admin.product.dto.WholeLifeRateImportDTO;
import com.insurance.admin.product.service.AdminProductService;
import com.insurance.admin.product.vo.AdminProductVO;
import com.insurance.admin.product.vo.AnnuityRateImportResultVO;
import com.insurance.admin.product.vo.PremiumRateImportResultVO;
import com.insurance.admin.product.vo.WholeLifeRateImportResultVO;
import com.insurance.api.entity.AnnuityProduct;
import com.insurance.api.entity.AnnuityRate;
import com.insurance.api.entity.InsuranceCompany;
import com.insurance.api.entity.PremiumRate;
import com.insurance.api.entity.ProductBase;
import com.insurance.api.entity.WholeLifeProduct;
import com.insurance.api.entity.WholeLifeRate;
import com.insurance.api.mapper.AnnuityProductMapper;
import com.insurance.api.mapper.AnnuityRateMapper;
import com.insurance.api.mapper.InsuranceCompanyMapper;
import com.insurance.api.mapper.PremiumRateMapper;
import com.insurance.api.mapper.ProductBaseMapper;
import com.insurance.api.mapper.WholeLifeProductMapper;
import com.insurance.api.mapper.WholeLifeRateMapper;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 管理员产品Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminProductServiceImpl implements AdminProductService {

    private final ProductBaseMapper productBaseMapper;
    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final WholeLifeProductMapper wholeLifeProductMapper;
    private final WholeLifeRateMapper wholeLifeRateMapper;
    private final AnnuityProductMapper annuityProductMapper;
    private final AnnuityRateMapper annuityRateMapper;
    private final PremiumRateMapper premiumRateMapper;

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Override
    public PageResult<AdminProductVO> listProducts(AdminProductQueryDTO queryDTO) {
        Page<ProductBase> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<ProductBase> wrapper = new LambdaQueryWrapper<>();

        if (queryDTO.getKeyword() != null && !queryDTO.getKeyword().isEmpty()) {
            wrapper.like(ProductBase::getProductName, queryDTO.getKeyword());
        }
        if (queryDTO.getCompanyId() != null) {
            wrapper.eq(ProductBase::getCompanyId, queryDTO.getCompanyId());
        }
        if (queryDTO.getProductType() != null) {
            wrapper.eq(ProductBase::getProductType, queryDTO.getProductType());
        }
        if (queryDTO.getSystemStatus() != null) {
            wrapper.eq(ProductBase::getSystemStatus, queryDTO.getSystemStatus());
        }
        if (queryDTO.getSaleStatus() != null) {
            wrapper.eq(ProductBase::getSaleStatus, queryDTO.getSaleStatus());
        }
        // maintenanceStatus 暂用 product_name 模糊匹配作为前端展示用
        // 如需真正维护状态字段，需在数据库中添加对应列
        if (queryDTO.getMaintenanceStatus() != null) {
            // 维护状态筛选：0=解析中, 1=待人工确认, 2=已确认, 3=已下线
            // 暂映射到 systemStatus: 解析中->0(未上架), 待确认->0, 已确认->1(已上架), 已下线->0+停售
            if (queryDTO.getMaintenanceStatus() == 2) {
                wrapper.eq(ProductBase::getSystemStatus, 1);
            } else if (queryDTO.getMaintenanceStatus() == 3) {
                wrapper.eq(ProductBase::getSaleStatus, 0);
            }
            // 0和1(解析中/待确认)暂不额外过滤，因为所有产品都可能属于这两个状态
        }
        wrapper.orderByDesc(ProductBase::getCreatedAt);

        Page<ProductBase> resultPage = productBaseMapper.selectPage(page, wrapper);
        List<Long> companyIds = resultPage.getRecords().stream()
                .map(ProductBase::getCompanyId)
                .filter(id -> id != null)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, String> companyNameMap = companyIds.isEmpty() ? new java.util.HashMap<>()
                : insuranceCompanyMapper.selectBatchIds(companyIds).stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));

        List<AdminProductVO> list = resultPage.getRecords().stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId())))
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createProduct(AdminProductCreateDTO createDTO) {
        ProductBase product = new ProductBase();
        BeanUtils.copyProperties(createDTO, product);
        productBaseMapper.insert(product);
        
        // 增额终身寿险子类数据
        if (createDTO.getProductType() != null && createDTO.getProductType() == 2) {
            WholeLifeProduct subProduct = new WholeLifeProduct();
            subProduct.setProductId(product.getProductId());
            subProduct.setReductionRuleType(createDTO.getReductionRuleType());
            subProduct.setReductionStartYear(createDTO.getReductionStartYear());
            subProduct.setReductionTimesLimit(createDTO.getReductionTimesLimit());
            subProduct.setMaxAddAge(createDTO.getMaxAddAge());
            subProduct.setAddPremiumRule(createDTO.getAddPremiumRule());
            subProduct.setAddTimesLimit(createDTO.getAddTimesLimit());
            subProduct.setAddRatioLimit(createDTO.getAddRatioLimit());
            subProduct.setLoanRatio(createDTO.getLoanRatio());
            subProduct.setLoanRate(createDTO.getLoanRate());
            subProduct.setIncreaseRate(createDTO.getIncreaseRate());
            subProduct.setIncreaseEndAge(createDTO.getIncreaseEndAge());
            subProduct.setSupportAgeList(createDTO.getSupportAgeList());
            wholeLifeProductMapper.insert(subProduct);
        }
        
        // 年金险子类数据
        if (createDTO.getProductType() != null && createDTO.getProductType() == 3) {
            AnnuityProduct subProduct = new AnnuityProduct();
            subProduct.setProductId(product.getProductId());
            annuityProductMapper.insert(subProduct);
        }
        
        return product.getProductId();
    }

    @Override
    public void updateProduct(Long productId, AdminProductUpdateDTO updateDTO) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        BeanUtils.copyProperties(updateDTO, product);
        productBaseMapper.updateById(product);
        
        // 增额终身寿险子类数据更新
        if (product.getProductType() != null && product.getProductType() == 2) {
            WholeLifeProduct existing = wholeLifeProductMapper.selectOne(
                new LambdaQueryWrapper<WholeLifeProduct>().eq(WholeLifeProduct::getProductId, productId));
            if (existing != null) {
                if (updateDTO.getReductionRuleType() != null) existing.setReductionRuleType(updateDTO.getReductionRuleType());
                if (updateDTO.getReductionStartYear() != null) existing.setReductionStartYear(updateDTO.getReductionStartYear());
                if (updateDTO.getReductionTimesLimit() != null) existing.setReductionTimesLimit(updateDTO.getReductionTimesLimit());
                if (updateDTO.getMaxAddAge() != null) existing.setMaxAddAge(updateDTO.getMaxAddAge());
                if (updateDTO.getAddPremiumRule() != null) existing.setAddPremiumRule(updateDTO.getAddPremiumRule());
                if (updateDTO.getAddTimesLimit() != null) existing.setAddTimesLimit(updateDTO.getAddTimesLimit());
                if (updateDTO.getAddRatioLimit() != null) existing.setAddRatioLimit(updateDTO.getAddRatioLimit());
                if (updateDTO.getLoanRatio() != null) existing.setLoanRatio(updateDTO.getLoanRatio());
                if (updateDTO.getLoanRate() != null) existing.setLoanRate(updateDTO.getLoanRate());
                if (updateDTO.getIncreaseRate() != null) existing.setIncreaseRate(updateDTO.getIncreaseRate());
                if (updateDTO.getIncreaseEndAge() != null) existing.setIncreaseEndAge(updateDTO.getIncreaseEndAge());
                if (updateDTO.getSupportAgeList() != null) existing.setSupportAgeList(updateDTO.getSupportAgeList());
                wholeLifeProductMapper.updateById(existing);
            } else {
                WholeLifeProduct subProduct = new WholeLifeProduct();
                subProduct.setProductId(productId);
                subProduct.setReductionRuleType(updateDTO.getReductionRuleType());
                subProduct.setReductionStartYear(updateDTO.getReductionStartYear());
                subProduct.setReductionTimesLimit(updateDTO.getReductionTimesLimit());
                subProduct.setMaxAddAge(updateDTO.getMaxAddAge());
                subProduct.setAddPremiumRule(updateDTO.getAddPremiumRule());
                subProduct.setAddTimesLimit(updateDTO.getAddTimesLimit());
                subProduct.setAddRatioLimit(updateDTO.getAddRatioLimit());
                subProduct.setLoanRatio(updateDTO.getLoanRatio());
                subProduct.setLoanRate(updateDTO.getLoanRate());
                subProduct.setIncreaseRate(updateDTO.getIncreaseRate());
                subProduct.setIncreaseEndAge(updateDTO.getIncreaseEndAge());
                subProduct.setSupportAgeList(updateDTO.getSupportAgeList());
                wholeLifeProductMapper.insert(subProduct);
            }
        }
    }

    @Override
    public void updateSystemStatus(Long productId, Integer systemStatus) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        product.setSystemStatus(systemStatus);
        productBaseMapper.updateById(product);
    }

    @Override
    public void updateSaleStatus(Long productId, Integer saleStatus) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        product.setSaleStatus(saleStatus);
        productBaseMapper.updateById(product);
    }

    @Override
    public AdminProductVO getProductDetail(Long productId) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        InsuranceCompany company = insuranceCompanyMapper.selectById(product.getCompanyId());
        return convertToVO(product, company != null ? company.getCompanyName() : null);
    }

    private AdminProductVO convertToVO(ProductBase product, String companyName) {
        AdminProductVO vo = new AdminProductVO();
        BeanUtils.copyProperties(product, vo);
        vo.setCompanyName(companyName);
        switch (product.getProductType()) {
            case 1:
                vo.setProductTypeDesc("重疾险");
                break;
            case 2:
                vo.setProductTypeDesc("增额终身寿险");
                break;
            case 3:
                vo.setProductTypeDesc("年金险");
                break;
            default:
                vo.setProductTypeDesc("未知类型");
                break;
        }
        return vo;
    }

    @Override
    public WholeLifeRateImportResultVO importWholeLifeRates(Long productId, MultipartFile file) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 2) {
            throw new BusinessException("该产品不是增额终身寿险，无法导入增额寿费率");
        }

        WholeLifeRateImportResultVO result = new WholeLifeRateImportResultVO();
        int totalCount = 0;
        int successCount = 0;
        int failCount = 0;

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new BusinessException("文件名为空");
        }
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();

        try {
            List<WholeLifeRateImportDTO> rows;
            if ("pdf".equals(ext)) {
                rows = parsePdfToWholeLifeRates(file);
            } else if ("xlsx".equals(ext) || "xls".equals(ext)) {
                rows = parseExcelToWholeLifeRates(file);
            } else {
                throw new BusinessException("不支持的文件格式: " + ext);
            }

            for (WholeLifeRateImportDTO dto : rows) {
                try {
                    if (dto.getGender() == null || dto.getAge() == null || dto.getPaymentYear() == null
                            || dto.getPolicyYear() == null || dto.getCashValue() == null) {
                        failCount++;
                        continue;
                    }

                    WholeLifeRate rate = new WholeLifeRate();
                    rate.setProductId(productId);
                    rate.setGender(dto.getGender());
                    rate.setAge(dto.getAge());
                    rate.setPaymentYear(dto.getPaymentYear());
                    rate.setPolicyYear(dto.getPolicyYear());
                    rate.setCashValue(dto.getCashValue());
                    rate.setDeathBenefit(dto.getDeathBenefit());
                    wholeLifeRateMapper.insert(rate);
                    successCount++;
                } catch (Exception e) {
                    log.warn("导入失败: {}", e.getMessage());
                    failCount++;
                }
                totalCount++;
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("文件解析失败: " + e.getMessage());
        }

        result.setTotalCount(totalCount);
        result.setSuccessCount(successCount);
        result.setFailCount(failCount);
        result.setMessage(failCount > 0
                ? "导入完成：成功" + successCount + "条，失败" + failCount + "条"
                : "导入完成：成功" + successCount + "条");
        return result;
    }

    private List<WholeLifeRateImportDTO> parseExcelToWholeLifeRates(MultipartFile file) throws Exception {
        List<WholeLifeRateImportDTO> rows = new ArrayList<>();
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            if (sheet == null) {
                throw new BusinessException("Excel文件为空");
            }

            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                throw new BusinessException("Excel文件没有表头");
            }

            // 列名映射
            Map<String, Integer> colMap = new HashMap<>();
            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String header = normalizeHeader(getStringCellValue(headerRow.getCell(c)));
                if (header != null && !header.isEmpty()) {
                    colMap.put(header, c);
                }
            }

            // 宽表检测：表头中包含多个纯数字（保单年度）
            List<Integer> yearHeaderCols = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : colMap.entrySet()) {
                try {
                    int year = Integer.parseInt(entry.getKey());
                    if (year > 0) {
                        yearHeaderCols.add(entry.getValue());
                    }
                } catch (NumberFormatException e) {
                    // 非数字表头，忽略
                }
            }
            Collections.sort(yearHeaderCols);

            boolean isWideTable = yearHeaderCols.size() >= 2;

            if (isWideTable) {
                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) continue;

                    Integer gender = getColValue(row, colMap, "gender");
                    Integer age = getColValue(row, colMap, "age");
                    Integer paymentYear = getColValue(row, colMap, "paymentYear");

                    for (int colIdx : yearHeaderCols) {
                        Integer policyYear = Integer.parseInt(getStringCellValue(headerRow.getCell(colIdx)).trim());
                        BigDecimal cashValue = getBigDecimalCellValue(row.getCell(colIdx));

                        WholeLifeRateImportDTO dto = new WholeLifeRateImportDTO();
                        dto.setGender(gender);
                        dto.setAge(age);
                        dto.setPaymentYear(paymentYear);
                        dto.setPolicyYear(policyYear);
                        dto.setCashValue(cashValue);
                        rows.add(dto);
                    }
                }
            } else {
                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) continue;

                    WholeLifeRateImportDTO dto = new WholeLifeRateImportDTO();
                    dto.setGender(getColValue(row, colMap, "gender"));
                    dto.setAge(getColValue(row, colMap, "age"));
                    dto.setPaymentYear(getColValue(row, colMap, "paymentYear"));
                    dto.setPolicyYear(getColValue(row, colMap, "policyYear"));
                    dto.setCashValue(getBigDecimalColValue(row, colMap, "cashValue"));
                    dto.setDeathBenefit(getBigDecimalColValue(row, colMap, "deathBenefit"));
                    rows.add(dto);
                }
            }
        }
        return rows;
    }

    private List<WholeLifeRateImportDTO> parsePdfToWholeLifeRates(MultipartFile file) throws Exception {
        File tempPdf = File.createTempFile("upload_", ".pdf");
        File tempJson = File.createTempFile("output_", ".json");
        try {
            file.transferTo(tempPdf);

            ProcessBuilder pb = new ProcessBuilder(
                    "python",
                    "c:\\Users\\Administrator\\.trae-cn\\work\\6a32467fb130998a25f03b4d\\insurance_table_parser.py",
                    tempPdf.getAbsolutePath(),
                    tempJson.getAbsolutePath()
            );
            pb.redirectErrorStream(true);
            Process process = pb.start();
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                throw new BusinessException("PDF解析脚本执行失败");
            }

            String jsonContent = new String(Files.readAllBytes(tempJson.toPath()));
            JsonNode jsonNode = OBJECT_MAPPER.readTree(jsonContent);
            if (!jsonNode.has("success") || !jsonNode.get("success").asBoolean()) {
                throw new BusinessException("PDF解析失败");
            }

            List<WholeLifeRateImportDTO> rows = new ArrayList<>();
            JsonNode rowsNode = jsonNode.get("rows");
            if (rowsNode != null && rowsNode.isArray()) {
                for (JsonNode rowNode : rowsNode) {
                    WholeLifeRateImportDTO dto = new WholeLifeRateImportDTO();
                    dto.setGender(rowNode.has("gender") ? rowNode.get("gender").asInt() : null);
                    dto.setAge(rowNode.has("age") ? rowNode.get("age").asInt() : null);
                    dto.setPaymentYear(rowNode.has("paymentYear") ? rowNode.get("paymentYear").asInt() : null);
                    dto.setPolicyYear(rowNode.has("policyYear") ? rowNode.get("policyYear").asInt() : null);
                    dto.setCashValue(rowNode.has("cashValue") ? new BigDecimal(rowNode.get("cashValue").asText()) : null);
                    dto.setDeathBenefit(rowNode.has("deathBenefit") ? new BigDecimal(rowNode.get("deathBenefit").asText()) : null);
                    rows.add(dto);
                }
            }
            return rows;
        } finally {
            tempPdf.delete();
            tempJson.delete();
        }
    }

    @Override
    public AnnuityRateImportResultVO importAnnuityRates(Long productId, MultipartFile file) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 3) {
            throw new BusinessException("该产品不是年金险，无法导入年金险费率");
        }

        AnnuityRateImportResultVO result = new AnnuityRateImportResultVO();
        int totalCount = 0;
        int successCount = 0;
        int failCount = 0;

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new BusinessException("文件名为空");
        }
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();

        try {
            List<AnnuityRateImportDTO> rows;
            if ("pdf".equals(ext)) {
                rows = parsePdfToAnnuityRates(file);
            } else if ("xlsx".equals(ext) || "xls".equals(ext)) {
                rows = parseExcelToAnnuityRates(file);
            } else {
                throw new BusinessException("不支持的文件格式: " + ext);
            }

            for (AnnuityRateImportDTO dto : rows) {
                try {
                    if (dto.getGender() == null || dto.getAge() == null || dto.getPaymentYear() == null
                            || dto.getPolicyYear() == null || dto.getCashValue() == null) {
                        failCount++;
                        continue;
                    }

                    AnnuityRate rate = new AnnuityRate();
                    rate.setProductId(productId);
                    rate.setGender(dto.getGender());
                    rate.setAge(dto.getAge());
                    rate.setPaymentYear(dto.getPaymentYear());
                    rate.setStartAge(dto.getStartAge());
                    rate.setPlanId(dto.getPlanId());
                    rate.setPolicyYear(dto.getPolicyYear());
                    rate.setAnnualPayout(dto.getAnnualPayout());
                    rate.setCashValue(dto.getCashValue());
                    rate.setDeathBenefit(dto.getDeathBenefit());
                    annuityRateMapper.insert(rate);
                    successCount++;
                } catch (Exception e) {
                    log.warn("导入失败: {}", e.getMessage());
                    failCount++;
                }
                totalCount++;
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("文件解析失败: " + e.getMessage());
        }

        result.setTotalCount(totalCount);
        result.setSuccessCount(successCount);
        result.setFailCount(failCount);
        result.setMessage(failCount > 0
                ? "导入完成：成功" + successCount + "条，失败" + failCount + "条"
                : "导入完成：成功" + successCount + "条");
        return result;
    }

    private List<AnnuityRateImportDTO> parseExcelToAnnuityRates(MultipartFile file) throws Exception {
        List<AnnuityRateImportDTO> rows = new ArrayList<>();
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            if (sheet == null) {
                throw new BusinessException("Excel文件为空");
            }

            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                throw new BusinessException("Excel文件没有表头");
            }

            // 列名映射（中文/英文 -> 列索引）
            Map<String, Integer> colMap = new HashMap<>();
            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String header = normalizeHeader(getStringCellValue(headerRow.getCell(c)));
                if (header != null && !header.isEmpty()) {
                    colMap.put(header, c);
                }
            }

            // 宽表检测：表头中包含多个纯数字（保单年度）
            List<Integer> yearHeaderCols = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : colMap.entrySet()) {
                try {
                    int year = Integer.parseInt(entry.getKey());
                    if (year > 0) {
                        yearHeaderCols.add(entry.getValue());
                    }
                } catch (NumberFormatException e) {
                    // 非数字表头，忽略
                }
            }
            Collections.sort(yearHeaderCols);

            boolean isWideTable = yearHeaderCols.size() >= 2;

            if (isWideTable) {
                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) continue;

                    Integer gender = getColValue(row, colMap, "gender");
                    Integer age = getColValue(row, colMap, "age");
                    Integer paymentYear = getColValue(row, colMap, "paymentYear");
                    Integer startAge = getColValue(row, colMap, "startAge");
                    String planId = getStringColValue(row, colMap, "planId");

                    for (int colIdx : yearHeaderCols) {
                        Integer policyYear = Integer.parseInt(getStringCellValue(headerRow.getCell(colIdx)).trim());
                        BigDecimal cashValue = getBigDecimalCellValue(row.getCell(colIdx));

                        AnnuityRateImportDTO dto = new AnnuityRateImportDTO();
                        dto.setGender(gender);
                        dto.setAge(age);
                        dto.setPaymentYear(paymentYear);
                        dto.setStartAge(startAge);
                        dto.setPlanId(planId);
                        dto.setPolicyYear(policyYear);
                        dto.setCashValue(cashValue);
                        rows.add(dto);
                    }
                }
            } else {
                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) continue;

                    AnnuityRateImportDTO dto = new AnnuityRateImportDTO();
                    dto.setGender(getColValue(row, colMap, "gender"));
                    dto.setAge(getColValue(row, colMap, "age"));
                    dto.setPaymentYear(getColValue(row, colMap, "paymentYear"));
                    dto.setStartAge(getColValue(row, colMap, "startAge"));
                    dto.setPlanId(getStringColValue(row, colMap, "planId"));
                    dto.setPolicyYear(getColValue(row, colMap, "policyYear"));
                    dto.setAnnualPayout(getBigDecimalColValue(row, colMap, "annualPayout"));
                    dto.setCashValue(getBigDecimalColValue(row, colMap, "cashValue"));
                    dto.setDeathBenefit(getBigDecimalColValue(row, colMap, "deathBenefit"));
                    rows.add(dto);
                }
            }
        }
        return rows;
    }

    // 列名映射表（支持多种列名写法）
    private static final Map<String, List<String>> HEADER_ALIASES;
    static {
        Map<String, List<String>> map = new HashMap<>();
        map.put("gender", List.of("性别", "gender", "性別"));
        map.put("age", List.of("年龄", "投保年龄", "age", "年齡"));
        map.put("paymentYear", List.of("交费期间", "缴费年限", "缴费期间", "交费年限", "保险期间", "paymentYear"));
        map.put("startAge", List.of("起领年龄", "领取年龄", "开始领取年龄", "起始年龄", "起始领取年龄", "startAge"));
        map.put("planId", List.of("产品计划", "计划", "plan", "planId", "保障计划"));
        map.put("policyYear", List.of("保单年度", "policyYear"));
        map.put("annualPayout", List.of("年领取金额", "年领金额", "annualPayout", "年金", "生存保险金", "养老金"));
        map.put("cashValue", List.of("现金价值", "cashValue", "現金價值"));
        map.put("deathBenefit", List.of("身故保险金", "deathBenefit", "身故給付"));
        map.put("comboCode", List.of("组合编码", "comboCode", "组合代码", "计划编码"));
        map.put("premiumPerK", List.of("每千元保费", "千元保费", "premiumPerK", "费率", "保费", "每千元保额保费"));
        map.put("healthStatus", List.of("健康状态", "healthStatus", "体况", "健康分类"));
        HEADER_ALIASES = Collections.unmodifiableMap(map);
    }

    private String normalizeHeader(String header) {
        if (header == null) return "";
        String h = header.trim();
        // 去掉小数（如"1.0" -> "1"）
        if (h.matches("^\\d+\\.0+$")) {
            h = String.valueOf((int) Double.parseDouble(h));
        }
        return h;
    }

    private Integer getColValue(Row row, Map<String, Integer> colMap, String field) {
        List<String> aliases = HEADER_ALIASES.get(field);
        if (aliases == null) return null;
        for (String alias : aliases) {
            Integer colIdx = colMap.get(alias);
            if (colIdx != null) {
                return getIntCellValue(row.getCell(colIdx));
            }
        }
        return null;
    }

    private String getStringColValue(Row row, Map<String, Integer> colMap, String field) {
        List<String> aliases = HEADER_ALIASES.get(field);
        if (aliases == null) return null;
        for (String alias : aliases) {
            Integer colIdx = colMap.get(alias);
            if (colIdx != null) {
                return getStringCellValue(row.getCell(colIdx));
            }
        }
        return null;
    }

    private BigDecimal getBigDecimalColValue(Row row, Map<String, Integer> colMap, String field) {
        List<String> aliases = HEADER_ALIASES.get(field);
        if (aliases == null) return null;
        for (String alias : aliases) {
            Integer colIdx = colMap.get(alias);
            if (colIdx != null) {
                return getBigDecimalCellValue(row.getCell(colIdx));
            }
        }
        return null;
    }

    private List<AnnuityRateImportDTO> parsePdfToAnnuityRates(MultipartFile file) throws Exception {
        File tempPdf = File.createTempFile("upload_", ".pdf");
        File tempJson = File.createTempFile("output_", ".json");
        try {
            file.transferTo(tempPdf);

            ProcessBuilder pb = new ProcessBuilder(
                    "python",
                    "c:\\Users\\Administrator\\.trae-cn\\work\\6a32467fb130998a25f03b4d\\insurance_table_parser.py",
                    tempPdf.getAbsolutePath(),
                    tempJson.getAbsolutePath()
            );
            pb.redirectErrorStream(true);
            Process process = pb.start();
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                throw new BusinessException("PDF解析脚本执行失败");
            }

            String jsonContent = new String(Files.readAllBytes(tempJson.toPath()));
            JsonNode jsonNode = OBJECT_MAPPER.readTree(jsonContent);
            if (!jsonNode.has("success") || !jsonNode.get("success").asBoolean()) {
                throw new BusinessException("PDF解析失败");
            }

            List<AnnuityRateImportDTO> rows = new ArrayList<>();
            JsonNode rowsNode = jsonNode.get("rows");
            if (rowsNode != null && rowsNode.isArray()) {
                for (JsonNode rowNode : rowsNode) {
                    AnnuityRateImportDTO dto = new AnnuityRateImportDTO();
                    dto.setGender(rowNode.has("gender") ? rowNode.get("gender").asInt() : null);
                    dto.setAge(rowNode.has("age") ? rowNode.get("age").asInt() : null);
                    dto.setPaymentYear(rowNode.has("paymentYear") ? rowNode.get("paymentYear").asInt() : null);
                    dto.setStartAge(rowNode.has("startAge") ? rowNode.get("startAge").asInt() : null);
                    dto.setPlanId(rowNode.has("planId") ? rowNode.get("planId").asText() : null);
                    dto.setPolicyYear(rowNode.has("policyYear") ? rowNode.get("policyYear").asInt() : null);
                    dto.setAnnualPayout(rowNode.has("annualPayout") ? new BigDecimal(rowNode.get("annualPayout").asText()) : null);
                    dto.setCashValue(rowNode.has("cashValue") ? new BigDecimal(rowNode.get("cashValue").asText()) : null);
                    dto.setDeathBenefit(rowNode.has("deathBenefit") ? new BigDecimal(rowNode.get("deathBenefit").asText()) : null);
                    rows.add(dto);
                }
            }
            return rows;
        } finally {
            tempPdf.delete();
            tempJson.delete();
        }
    }

    private Integer getIntCellValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case NUMERIC: return (int) cell.getNumericCellValue();
            case STRING: {
                try { return Integer.parseInt(cell.getStringCellValue().trim()); }
                catch (NumberFormatException e) { return null; }
            }
            default: return null;
        }
    }

    private BigDecimal getBigDecimalCellValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case NUMERIC: return BigDecimal.valueOf(cell.getNumericCellValue());
            case STRING: {
                try { return new BigDecimal(cell.getStringCellValue().trim()); }
                catch (NumberFormatException e) { return null; }
            }
            default: return null;
        }
    }

    private String getStringCellValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC: return String.valueOf((int) cell.getNumericCellValue());
            default: return null;
        }
    }

    @Override
    public PremiumRateImportResultVO importPremiumRates(Long productId, MultipartFile file) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 1) {
            throw new BusinessException("该产品不是重疾险，无法导入重疾险费率");
        }

        PremiumRateImportResultVO result = new PremiumRateImportResultVO();
        int totalCount = 0;
        int successCount = 0;
        int failCount = 0;

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new BusinessException("文件名为空");
        }
        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();

        try {
            List<PremiumRateImportDTO> rows;
            if ("pdf".equals(ext)) {
                rows = parsePdfToPremiumRates(file);
            } else if ("xlsx".equals(ext) || "xls".equals(ext)) {
                rows = parseExcelToPremiumRates(file);
            } else {
                throw new BusinessException("不支持的文件格式: " + ext);
            }

            for (PremiumRateImportDTO dto : rows) {
                try {
                    if (dto.getGender() == null || dto.getAge() == null || dto.getPaymentYear() == null
                            || dto.getPremiumPerK() == null) {
                        failCount++;
                        continue;
                    }

                    PremiumRate rate = new PremiumRate();
                    rate.setProductId(productId);
                    rate.setComboCode(dto.getComboCode() != null ? dto.getComboCode() : 0);
                    rate.setGender(dto.getGender());
                    rate.setAge(dto.getAge());
                    rate.setPaymentYear(dto.getPaymentYear());
                    rate.setPremiumPerK(dto.getPremiumPerK());
                    rate.setHealthStatus(dto.getHealthStatus() != null ? dto.getHealthStatus() : 0);
                    premiumRateMapper.insert(rate);
                    successCount++;
                } catch (Exception e) {
                    log.warn("导入失败: {}", e.getMessage());
                    failCount++;
                }
                totalCount++;
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("文件解析失败: " + e.getMessage());
        }

        result.setTotalCount(totalCount);
        result.setSuccessCount(successCount);
        result.setFailCount(failCount);
        result.setMessage(failCount > 0
                ? "导入完成：成功" + successCount + "条，失败" + failCount + "条"
                : "导入完成：成功" + successCount + "条");
        return result;
    }

    private List<PremiumRateImportDTO> parseExcelToPremiumRates(MultipartFile file) throws Exception {
        List<PremiumRateImportDTO> rows = new ArrayList<>();
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            if (sheet == null) {
                throw new BusinessException("Excel文件为空");
            }

            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                throw new BusinessException("Excel文件没有表头");
            }

            Map<String, Integer> colMap = new HashMap<>();
            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String header = normalizeHeader(getStringCellValue(headerRow.getCell(c)));
                if (header != null && !header.isEmpty()) {
                    colMap.put(header, c);
                }
            }

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                PremiumRateImportDTO dto = new PremiumRateImportDTO();
                dto.setComboCode(getColValue(row, colMap, "comboCode"));
                dto.setGender(getColValue(row, colMap, "gender"));
                dto.setAge(getColValue(row, colMap, "age"));
                dto.setPaymentYear(getColValue(row, colMap, "paymentYear"));
                dto.setPremiumPerK(getBigDecimalColValue(row, colMap, "premiumPerK"));
                dto.setHealthStatus(getColValue(row, colMap, "healthStatus"));
                rows.add(dto);
            }
        }
        return rows;
    }

    private List<PremiumRateImportDTO> parsePdfToPremiumRates(MultipartFile file) throws Exception {
        File tempPdf = File.createTempFile("upload_", ".pdf");
        File tempJson = File.createTempFile("output_", ".json");
        try {
            file.transferTo(tempPdf);

            ProcessBuilder pb = new ProcessBuilder(
                    "python",
                    "c:\\Users\\Administrator\\.trae-cn\\work\\6a32467fb130998a25f03b4d\\insurance_table_parser.py",
                    tempPdf.getAbsolutePath(),
                    tempJson.getAbsolutePath()
            );
            pb.redirectErrorStream(true);
            Process process = pb.start();
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                throw new BusinessException("PDF解析脚本执行失败");
            }

            String jsonContent = new String(Files.readAllBytes(tempJson.toPath()));
            JsonNode jsonNode = OBJECT_MAPPER.readTree(jsonContent);
            if (!jsonNode.has("success") || !jsonNode.get("success").asBoolean()) {
                throw new BusinessException("PDF解析失败");
            }

            List<PremiumRateImportDTO> rows = new ArrayList<>();
            JsonNode rowsNode = jsonNode.get("rows");
            if (rowsNode != null && rowsNode.isArray()) {
                for (JsonNode rowNode : rowsNode) {
                    PremiumRateImportDTO dto = new PremiumRateImportDTO();
                    dto.setComboCode(rowNode.has("comboCode") ? rowNode.get("comboCode").asInt() : 0);
                    dto.setGender(rowNode.has("gender") ? rowNode.get("gender").asInt() : null);
                    dto.setAge(rowNode.has("age") ? rowNode.get("age").asInt() : null);
                    dto.setPaymentYear(rowNode.has("paymentYear") ? rowNode.get("paymentYear").asInt() : null);
                    dto.setPremiumPerK(rowNode.has("premiumPerK") ? new BigDecimal(rowNode.get("premiumPerK").asText()) : null);
                    dto.setHealthStatus(rowNode.has("healthStatus") ? rowNode.get("healthStatus").asInt() : 0);
                    rows.add(dto);
                }
            }
            return rows;
        } finally {
            tempPdf.delete();
            tempJson.delete();
        }
    }
}
