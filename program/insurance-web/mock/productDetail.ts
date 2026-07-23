import { companyShareholders, companyRelations } from './companyShareholders'

// 为产品详情中的公司信息补充股东和关联关系
function enrichCompanyData(companyId: number, baseCompany: any) {
  return {
    ...baseCompany,
    shareholders: companyShareholders[companyId]?.slice(0, 5) || [],
    relations: companyRelations[companyId] || []
  }
}

export const mockProductDetail: Record<number, any> = {
  2: {
    productId: 2, productName: '中意一生中意年金保险', productType: 3, subType: 1,
    companyId: 1, companyName: '中意人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, productCode: 'PROD_NJ_0089', productTypeDesc: '年金险-分红型',
    occupationClass: 1, monthlyRatio: 0.09, quarterlyRatio: 0.26, halfYearlyRatio: 0.52,
    saleStatus: 1, systemStatus: 1, yieldType: '分红型',
    hasTerms: true, hasBrochure: true, hasRules: true, hasRateTable: true, hasCashValue: true,
    terms: {
      insurancePeriod: '终身', hesitationPeriod: '15日', waitingPeriod: '无',
      liabilitySummary: '自首个年金领取日起，按合同约定向被保险人给付年金，直至被保险人身故或合同终止。',
      exclusionSummary: '因下列情形之一导致被保险人身故的，不承担给付身故保险金的责任：投保人对被保险人的故意杀害、故意伤害。',
      otherRights: '保单借款、减额缴清', saleRegion: '全国'
    },
    annuityExt: {
      annuityType: '养老年金', payoutRuleText: '年领/月领', isLifelong: true,
      minPremium: 5000, deathBenefitRule: '已交保费与现金价值较大者',
      universalAccountLinked: false, communityLinkage: false,
      returnFrequency: '每年', firstReturnTime: '60周岁'
    },
    subProductData: {
      startAgeFemale: [55, 60, 65, 70], startAgeMale: [60, 65, 70],
      supportMonthly: 1, monthlyCoefficient: 0.084,
      guaranteeOptions: [10, 15, 20], supportIncrease: 0, increaseRateOptions: [], increaseEndYear: 0
    },
    startAgeOptions: [55, 60, 65, 70], guaranteePeriodOptions: [{label: '10年', value: 10}, {label: '15年', value: 15}, {label: '20年', value: 20}],
    increaseOptions: [], bonusTypeOptions: [], bonusAgeOptions: [],
    company: enrichCompanyData(1, { foundedYear: 2002, registeredCapital: 37, hotline: '400-888-9888', website: 'www.generalichina.com', description: '中意人寿保险有限公司', companyTypeDesc: '合资', riskRating: 'A', solvencyRatio: 185.5 })
  },
  1: {
    productId: 1, productName: '中意一生保终身寿险（A款）', productType: 2, subType: 2,
    companyId: 1, companyName: '中意人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, productCode: 'PROD_ZES_0001', productTypeDesc: '增额终身寿险-固收型',
    occupationClass: 1, monthlyRatio: 0.09, quarterlyRatio: 0.26, halfYearlyRatio: 0.52,
    saleStatus: 1, systemStatus: 1, yieldType: '固收型',
    hasTerms: true, hasBrochure: true, hasRules: true, hasRateTable: true, hasCashValue: true,
    terms: {
      insurancePeriod: '终身', hesitationPeriod: '15日', waitingPeriod: '无',
      liabilitySummary: '身故保险金：被保险人身故，按以下两项较大者给付：1）已交保险费的一定比例；2）合同有效保险金额。',
      exclusionSummary: '因下列情形之一导致被保险人身故的，不承担给付身故保险金的责任：投保人对被保险人的故意杀害、故意伤害。',
      otherRights: '保单借款、减额缴清、减保', saleRegion: '全国'
    },
    wholeLifeExt: {
      deathPayoutRule: '18-40岁160%，41-60岁140%，61岁以上120%',
      reductionRuleText: '每个保单年度累计减保金额不得超过合同生效时基本保险金额的20%',
      addRuleText: '不支持', secondApplicantRule: '支持',
      crossGeneration: true, trustLinkage: false,
      minPremium: 5000, minSumAssured: 10000
    },
    subProductData: {
      reductionRuleType: 1, reductionStartYear: 5, reductionTimesLimit: 0,
      maxAddAge: 0, addPremiumRule: 0, addTimesLimit: 0, addRatioLimit: 0,
      loanRatio: 80, loanRate: 0.05, increaseRate: 3.5, increaseEndAge: 105,
      supportAgeList: '[0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,55,60,65,70]'
    },
    company: enrichCompanyData(1, { foundedYear: 2002, registeredCapital: 37, hotline: '400-888-9888', website: 'www.generalichina.com', description: '中意人寿保险有限公司', companyTypeDesc: '合资', riskRating: 'A', solvencyRatio: 185.5 })
  },
  3: {
    productId: 3, productName: '工银安盛御享欣生重大疾病保险（龙腾版）', productType: 1, subType: 2,
    companyId: 2, companyName: '工银安盛人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, productCode: 'PROD_ZJ_0001', productTypeDesc: '重大疾病保险',
    occupationClass: 1, monthlyRatio: null, quarterlyRatio: null, halfYearlyRatio: null,
    saleStatus: 1, systemStatus: 1,
    hasTerms: true, hasBrochure: true, hasRules: true, hasRateTable: true, hasCashValue: false,
    terms: {
      insurancePeriod: '终身', hesitationPeriod: '15日', waitingPeriod: '90天',
      liabilitySummary: '等待期后确诊合同约定的重大疾病，按基本保险金额给付重大疾病保险金。重疾、中症、轻症多重保障，覆盖人生各阶段风险。',
      exclusionSummary: '因下列情形之一导致被保险人发生疾病、达到疾病状态或进行手术的，不承担给付保险金的责任：\n1. 投保人对被保险人的故意杀害、故意伤害；\n2. 被保险人故意自伤、故意犯罪或者抗拒依法采取的刑事强制措施；\n3. 被保险人主动吸食或注射毒品；\n4. 被保险人酒后驾驶、无合法有效驾驶证驾驶，或驾驶无有效行驶证的机动车；\n5. 被保险人感染艾滋病病毒或患艾滋病（不包括经输血导致的艾滋病病毒感染）；\n6. 战争、军事冲突、暴乱或武装叛乱；\n7. 核爆炸、核辐射或核污染；\n8. 遗传性疾病，先天性畸形、变形或染色体异常。'
    },
    subProductData: {
      waitingPeriod: 90, waitingPeriodRule: 2,
      criticalCount: 120, criticalRatio: 100, criticalPayTimes: 1,
      mediumCount: 25, mediumRatio: 60, mediumPayTimes: 2,
      lightCount: 50, lightRatio: 30, lightPayTimes: 3,
      criticalMultiInterval: 0,
      cancerMultiInterval: 3, cancerPayTimes: 2, cancerRatio: 100,
      cvdMultiInterval: 3, cvdPayTimes: 2, cvdRatio: 100,
      diseaseCareAge: 60, diseaseCareCriticalRatio: 80, diseaseCareMediumRatio: 15, diseaseCareLightRatio: 10,
      deathBefore18: '已交保费', deathAfter18: 'max(已交保费,现金价值)',
      waiverPremium: true, waiverCondition: '轻症/中症/重疾豁免',
      premiumDoubleExemption: true
    },
    responsibilities: [
      { code: 'critical_illness', category: 'BASE', name: '重大疾病保险金', description: '120种重疾，分6组，每组赔付1次，每次100%基本保额，最多赔付6次', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'medium_illness', category: 'BASE', name: '中症疾病保险金', description: '25种中症，不分组，每次60%基本保额，最多赔付2次，无间隔期', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'light_illness', category: 'BASE', name: '轻症疾病保险金', description: '50种轻症，不分组，每次30%基本保额，最多赔付3次，无间隔期', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'death', category: 'DEATH', name: '身故保险金', description: '18周岁前赔付已交保费，18周岁后赔付max(已交保费,现金价值)', supported: true, optionType: 'radio', options: [{ label: '不附加', value: 'none' }, { label: '附加身故', value: 'included' }], defaultValue: 'included' },
      { code: 'total_disability', category: 'DEATH', name: '全残保险金', description: '被保险人全残，按基本保险金额给付全残保险金', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'terminal_illness', category: 'DEATH', name: '终末期保险金', description: '被保险人达到疾病终末期阶段，按基本保险金额给付', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'waiver_premium', category: 'WAIVER', name: '被保险人豁免', description: '被保险人确诊轻症/中症/重疾，豁免后续保费，合同继续有效', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'payer_waiver', category: 'WAIVER', name: '投保人豁免', description: '投保人身故/全残/重疾，豁免后续保费（需额外加费）', supported: true, optionType: 'switch', defaultValue: false },
      { code: 'cancer_multi', category: 'MULTI_PAY', name: '癌症多次赔付', description: '癌症额外赔付2次，每次100%基本保额，间隔期3年，含新发/复发/转移/持续', supported: true, optionType: 'switch', defaultValue: false },
      { code: 'cvd_multi', category: 'MULTI_PAY', name: '心脑血管多次赔付', description: '特定心脑血管疾病额外赔付2次，每次100%基本保额，间隔期3年', supported: true, optionType: 'switch', defaultValue: false },
      { code: 'disease_care', category: 'BONUS', name: '疾病关爱金', description: '60周岁前确诊重疾额外赔付80%，中症额外15%，轻症额外10%', supported: true, optionType: 'switch', defaultValue: true },
      { code: 'hospital_allowance', category: 'ALLOWANCE', name: '住院津贴', description: '重疾住院每日给付基本保额的0.1%，每年最多90天', supported: false, optionType: 'switch', defaultValue: false },
      { code: 'special_drugs', category: 'SPECIAL', name: '特定药品费用', description: '覆盖50种特定靶向药费用，最高赔付200万，0免赔额', supported: false, optionType: 'switch', defaultValue: false }
    ],
    benefits: [
      { name: '重大疾病保险金', description: '120种重大疾病，分6组最多赔6次，每次100%基本保额', value: '100%保额 × 6次' },
      { name: '中症疾病保险金', description: '25种中症疾病，不分组最多赔2次，每次60%基本保额', value: '60%保额 × 2次' },
      { name: '轻症疾病保险金', description: '50种轻症疾病，不分组最多赔3次，每次30%基本保额', value: '30%保额 × 3次' },
      { name: '疾病关爱金', description: '60周岁前确诊额外赔付，重疾+80%、中症+15%、轻症+10%', value: '最高+80%保额' },
      { name: '身故保险金', description: '18岁前已交保费，18岁后max(已交保费,现金价值)', value: '已交保费/现价' },
      { name: '保费豁免', description: '被保险人确诊轻症/中症/重疾，豁免后续所有保费', value: '豁免保费' },
      { name: '癌症多次赔付（可选）', description: '癌症新发/复发/转移/持续，额外赔2次，每次100%保额', value: '100%保额 × 2次' },
      { name: '心脑血管多次赔付（可选）', description: '特定心脑血管疾病额外赔2次，每次100%保额', value: '100%保额 × 2次' },
      { name: '投保人豁免（可选）', description: '投保人身故/全残/重疾，豁免被保险人后续保费', value: '豁免保费' }
    ],
    diseases: [
      // ========== 重大疾病（50种，含28种法定重疾） ==========
      // --- 恶性肿瘤 ---
      { name: '恶性肿瘤-重度', code: 'C01', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指恶性细胞不受控制的进行性增长和扩散，浸润和破坏周围正常组织，可以经血管、淋巴管和体腔扩散转移到身体其它部位的疾病。经病理学检查结果明确诊断，临床诊断属于世界卫生组织《疾病和有关健康问题的国际统计分类》（ICD-10）的恶性肿瘤范畴。' },
      { name: '严重非恶性颅内肿瘤', code: 'C09', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指起源于脑、脑神经、脑被膜的非恶性肿瘤，ICD-10肿瘤形态学编码属于D32（脑膜良性肿瘤）、D33（脑良性肿瘤）、D35.2-D35.4（垂体、颅咽管、松果体良性肿瘤），并已经引起颅内压升高或神经系统功能损害，出现视乳头水肿或视觉受损、听觉受损、面部或肢体瘫痪、癫痫等。' },
      { name: '淋巴瘤', code: 'C50', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指一组起源于淋巴造血系统的恶性肿瘤的总称，其主要临床表现为无痛性淋巴结肿大，肝脾肿大，全身各组织器官均可受累，伴发热、盗汗、消瘦、瘙痒等全身症状。' },
      { name: '白血病', code: 'C51', category: '血液免疫', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指一类造血干祖细胞的恶性克隆性疾病，因白血病细胞自我更新增强、增殖失控、分化障碍、凋亡受阻，而停滞在细胞发育的不同阶段。' },
      { name: '多发性骨髓瘤', code: 'C52', category: '血液免疫', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种恶性浆细胞病，其肿瘤细胞起源于骨髓中的浆细胞，而浆细胞是B淋巴细胞发育到最终功能阶段的细胞。' },
      { name: '骨髓增生异常综合征', code: 'C53', category: '血液免疫', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一组克隆性造血干细胞疾病，其特征为血细胞减少，髓系细胞一系或多系病态造血，无效造血及高风险向白血病转化。' },
      { name: '神经内分泌肿瘤', code: 'C54', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指起源于肽能神经元和神经内分泌细胞的异质性肿瘤，可发生于全身许多器官和组织，包括胃肠道、胰腺、支气管和肺等。' },
      { name: '骨恶性肿瘤', code: 'C55', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指发生于骨骼或其附属组织的恶性肿瘤，具有发展迅速、预后不佳、死亡率高的特点。' },
      { name: '鼻咽癌', code: 'C56', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生于鼻咽腔顶部和侧壁的恶性肿瘤，是我国高发恶性肿瘤之一，发病率为耳鼻咽喉恶性肿瘤之首。' },
      { name: '食管癌', code: 'C57', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指食管鳞状上皮或腺上皮的异常增生所形成的恶性病变，其发展一般经过上皮不典型增生、原位癌、浸润癌等阶段。' },
      { name: '胃癌', code: 'C58', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指起源于胃黏膜上皮的恶性肿瘤，在我国各种恶性肿瘤中发病率居首位，胃癌发病有明显的地域性差别。' },
      { name: '结直肠癌', code: 'C59', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生在结肠或直肠的恶性肿瘤，是常见的消化道恶性肿瘤之一，早期症状不明显，随着癌肿增大而表现为排便习惯改变、便血、腹泻等。' },
      { name: '肝癌', code: 'C60', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生于肝脏的恶性肿瘤，包括原发性肝癌和转移性肝癌两种，原发性肝癌是临床上最常见的恶性肿瘤之一。' },
      { name: '胰腺癌', code: 'C61', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指一种恶性程度很高，诊断和治疗都很困难的消化道恶性肿瘤，约90%为起源于腺管上皮的导管腺癌。' },
      { name: '肺癌', code: 'C62', category: '呼吸系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指起源于支气管黏膜或腺体的恶性肿瘤，是发病率和死亡率增长最快，对人群健康和生命威胁最大的恶性肿瘤之一。' },
      { name: '乳腺癌', code: 'C63', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生在乳腺腺上皮组织的恶性肿瘤，是女性最常见的恶性肿瘤之一，男性乳腺癌较为罕见。' },
      { name: '宫颈癌', code: 'C64', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生在子宫阴道部及宫颈管的恶性肿瘤，是最常见的妇科恶性肿瘤，高危型HPV持续感染是宫颈癌的主要危险因素。' },
      { name: '卵巢癌', code: 'C65', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指发生在卵巢的恶性肿瘤，其中以上皮癌最多见，其次是恶性生殖细胞肿瘤。' },
      { name: '前列腺癌', code: 'C66', category: '恶性肿瘤', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生在前列腺的上皮性恶性肿瘤，是男性泌尿生殖系统最常见的恶性肿瘤之一。' },
      { name: '甲状腺癌', code: 'C67', category: '内分泌代谢', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指发生在甲状腺的恶性肿瘤，是最常见的甲状腺恶性肿瘤，约占全身恶性肿瘤的1%。' },
      { name: '膀胱癌', code: 'C68', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指发生在膀胱黏膜上的恶性肿瘤，是泌尿系统最常见的恶性肿瘤，也是全身十大常见肿瘤之一。' },
      { name: '肾癌', code: 'C69', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指起源于肾实质泌尿小管上皮系统的恶性肿瘤，又称肾细胞癌，简称为肾癌。' },

      // --- 心脑血管 ---
      { name: '较重急性心肌梗死', code: 'C02', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指因冠状动脉阻塞导致的相应区域供血不足造成部分心肌坏死。须满足下列至少三项条件：典型临床表现，例如急性胸痛等；新近的心电图改变提示急性心肌梗死；心肌酶或肌钙蛋白有诊断意义的升高，或呈符合急性心肌梗死的动态变化；发病90天后，经检查证实左心室功能降低，如左心室射血分数低于50%。' },
      { name: '严重脑中风后遗症', code: 'C03', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指因脑血管的突发病变引起脑血管出血、栓塞或梗塞，并导致神经系统永久性的功能障碍。神经系统永久性的功能障碍，指疾病确诊180天后，仍遗留下列一种或一种以上障碍：一肢或一肢以上肢体肌力2级或2级以下；语言能力或咀嚼吞咽能力完全丧失；自主生活能力完全丧失，无法独立完成六项基本日常生活活动中的三项或三项以上。' },
      { name: '冠状动脉搭桥术', code: 'C05', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指为治疗严重的冠心病，实际实施了开胸进行的冠状动脉血管旁路移植的手术。冠状动脉支架植入术、心导管球囊扩张术、激光射频技术及其它非开胸的介入手术、腔镜手术不在保障范围内。' },
      { name: '心脏瓣膜手术', code: 'C16', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指为治疗心脏瓣膜疾病，实际实施了开胸进行的心脏瓣膜置换或修复的手术。' },
      { name: '主动脉手术', code: 'C25', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指为治疗主动脉疾病，实际实施了开胸或开腹进行的切除、置换、修补病损主动脉血管的手术。主动脉指胸主动脉和腹主动脉，不包括胸主动脉和腹主动脉的分支血管。' },
      { name: '严重特发性肺动脉高压', code: 'C21', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指不明原因的肺动脉压力持续性增高，进行性发展而导致的慢性疾病，已经造成永久不可逆性的体力活动能力受限，达到美国纽约心脏病学会心功能状态分级IV级，且静息状态下肺动脉平均压超过30mmHg。' },
      { name: '严重冠心病', code: 'C70', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指经冠状动脉造影检查明确诊断为主要血管严重狭窄性病变，须满足下列至少一项条件：左冠状动脉主干和右冠状动脉中，一支血管管腔堵塞75%以上，另一支血管管腔堵塞60%以上；左前降支、左旋支和右冠状动脉中，至少一支血管管腔堵塞75%以上，其他两支血管管腔堵塞60%以上。' },
      { name: '严重心肌病', code: 'C71', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一组异质性心肌疾病，由不同病因引起的心肌病变导致心肌机械和/或心电功能障碍，常表现为心室肥厚或扩张。' },
      { name: '严重感染性心内膜炎', code: 'C72', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因感染性微生物造成心脏内膜发炎，并符合下列所有条件：血液培养测试结果为阳性；心内膜炎导致瓣膜损害；已实施开胸手术进行瓣膜置换或修复。' },
      { name: '严重肺源性心脏病', code: 'C73', category: '呼吸系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因肺部疾病导致心脏结构和功能损害，经心脏超声检查证实右心室肥厚和右心功能衰竭，达到美国纽约心脏病学会心功能状态分级IV级。' },
      { name: '艾森曼格综合征', code: 'C74', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因心脏病导致的肺动脉高压，使得血液从右到左分流，出现紫绀等症状，已经造成永久不可逆性的体力活动能力受限，达到美国纽约心脏病学会心功能状态分级III级及以上。' },
      { name: '严重大动脉炎', code: 'C75', category: '心脑血管', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指累及主动脉及其主要分支的慢性非特异性炎症引起的不同部位动脉狭窄或闭塞，出现相应部位缺血表现。' },

      // --- 神经系统 ---
      { name: '严重阿尔茨海默病', code: 'C17', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指因大脑进行性、不可逆性改变导致智能严重衰退或丧失，临床表现为明显的认知能力障碍、行为异常和社交能力减退，其日常生活必须持续受到他人监护。须由头颅断层扫描（CT）、核磁共振检查（MRI）或正电子发射断层扫描（PET）等影像学检查证实，且自主生活能力完全丧失，无法独立完成六项基本日常生活活动中的三项或三项以上。' },
      { name: '严重脑损伤', code: 'C18', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因头部遭受机械性外力，引起脑重要部位损伤，导致神经系统永久性的功能障碍。须由头颅断层扫描（CT）、核磁共振检查（MRI）或正电子发射断层扫描（PET）等影像学检查证实。神经系统永久性的功能障碍，指脑损伤180天后，仍遗留下列一种或一种以上障碍。' },
      { name: '严重原发性帕金森病', code: 'C19', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指一种中枢神经系统的退行性疾病，临床表现为震颤麻痹、共济失调等。须满足下列全部条件：药物治疗无法控制病情；自主生活能力完全丧失，无法独立完成六项基本日常生活活动中的三项或三项以上。' },
      { name: '严重运动神经元病', code: 'C22', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指一组中枢神经系统运动神经元的进行性变性疾病，包括进行性脊肌萎缩症、进行性延髓麻痹症、原发性侧索硬化症、肌萎缩性侧索硬化症。须满足自主生活能力完全丧失，无法独立完成六项基本日常生活活动中的三项或三项以上的条件。' },
      { name: '深度昏迷', code: 'C12', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因疾病或意外伤害导致意识丧失，对外界刺激和体内需求均无反应，昏迷程度按照格拉斯哥昏迷分级（Glasgow coma scale）结果为5分或5分以下，且已经持续使用呼吸机及其它生命维持系统96小时以上。' },
      { name: '瘫痪', code: 'C15', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因疾病或意外伤害导致两肢或两肢以上肢体机能永久完全丧失。肢体机能永久完全丧失，指疾病确诊180天后或意外伤害发生180天后，每肢三大关节中的两大关节仍然完全僵硬，或不能随意识活动。' },
      { name: '严重脑炎后遗症或严重脑膜炎后遗症', code: 'C11', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因患脑炎或脑膜炎导致的神经系统永久性的功能障碍。神经系统永久性的功能障碍，指疾病确诊180天后，仍遗留下列一种或一种以上障碍：一肢或一肢以上肢体肌力2级或2级以下；语言能力或咀嚼吞咽能力完全丧失；自主生活能力完全丧失，无法独立完成六项基本日常生活活动中的三项或三项以上。' },
      { name: '语言能力丧失', code: 'C23', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因疾病或意外伤害导致完全丧失语言能力，经过积极治疗至少12个月（声带完全切除不受此时间限制），仍无法通过现有医疗手段恢复。' },
      { name: '多发性硬化', code: 'C76', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种中枢神经系统脱髓鞘疾病，造成身体部位功能障碍，临床表现为反复发作的神经功能障碍。' },
      { name: '重症肌无力', code: 'C77', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种神经与肌肉接头部位传递障碍的自身免疫性疾病，临床特征是局部或全身横纹肌于活动时易于疲劳无力，须经自主生活能力完全丧失，无法独立完成六项基本日常生活活动中的三项或三项以上。' },
      { name: '严重癫痫', code: 'C78', category: '神经系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种反复发作的异常脑电活动引起的慢性脑部疾病，出现意识改变和/或惊厥发作，经药物治疗两年以上仍无法控制。' },

      // --- 器官移植 ---
      { name: '重大器官移植术或造血干细胞移植术', code: 'C04', category: '器官移植', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '重大器官移植术，指因相应器官功能衰竭，已经实施了肾脏、肝脏、心脏、肺脏的异体移植手术。造血干细胞移植术，指因造血功能损害或造血系统恶性肿瘤，已经实施了造血干细胞（包括骨髓造血干细胞、外周血造血干细胞和脐血造血干细胞）的异体移植手术。' },

      // --- 消化系统 ---
      { name: '急性重症肝炎或亚急性重症肝炎', code: 'C08', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因肝炎病毒感染引起肝脏组织弥漫性坏死，导致急性肝功能衰竭，且经血清学或病毒学检查证实，并须满足下列全部条件：重度黄疸或黄疸迅速加重；肝性脑病；B超或其它影像学检查显示肝脏体积急速萎缩；肝功能指标进行性恶化。' },
      { name: '严重慢性肝衰竭', code: 'C10', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因慢性肝脏疾病导致肝功能衰竭。须满足下列全部条件：持续性黄疸；腹水；肝性脑病；充血性脾肿大伴脾功能亢进或食管胃底静脉曲张。因酗酒或药物滥用导致的肝功能衰竭不在保障范围内。' },
      { name: '严重慢性肾衰竭', code: 'C06', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指双肾功能慢性不可逆性衰竭，达到尿毒症期，经诊断后已经进行了至少90天的规律性透析治疗或实施了肾脏移植手术。' },
      { name: '严重克罗恩病', code: 'C27', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指一种慢性肉芽肿性肠炎，具有特征性的克隆病病理组织学变化。诊断必须由病理检查结果证实。被保险人所患的克隆病必须已经造成瘘管形成并伴有肠梗阻或肠穿孔。' },
      { name: '严重溃疡性结肠炎', code: 'C28', category: '消化系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指伴有致命性电解质紊乱的急性暴发性溃疡性结肠炎，病变累及全结肠，表现为严重的血便和系统性症状体征，须已经实施了全结肠切除手术，或者经病理组织学检查明确诊断。' },

      // --- 其他 ---
      { name: '多个肢体缺失', code: 'C07', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因疾病或意外伤害导致两个或两个以上肢体自腕关节或踝关节近端（靠近躯干端）以上完全性断离。' },
      { name: '双耳失聪', code: 'C13', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因疾病或意外伤害导致双耳听力永久不可逆性丧失，在500赫兹、1000赫兹和2000赫兹语音频率下，平均听阈大于91分贝，且经纯音听力测试、声导抗检测或听觉诱发电位检测等证实。' },
      { name: '双目失明', code: 'C14', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因疾病或意外伤害导致双眼视力永久不可逆性丧失，双眼中较好眼须满足下列至少一项条件：眼球缺失或摘除；矫正视力低于0.02（采用国际标准视力表，如果使用其它视力表应进行换算）；视野半径小于5度。' },
      { name: '严重Ⅲ度烧伤', code: 'C20', category: '其他', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指烧伤程度为Ⅲ度，且Ⅲ度烧伤的面积达到全身体表面积的20%或20%以上。体表面积根据《中国新九分法》计算。' },
      { name: '重型再生障碍性贫血', code: 'C24', category: '血液免疫', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因骨髓造血功能慢性持续性衰竭导致的贫血、中性粒细胞减少及血小板减少。须满足下列全部条件：骨髓穿刺检查或骨髓活检结果支持诊断；外周血象须具备以下三项条件：中性粒细胞绝对值≤0.5×10^9/L；网织红细胞<1%；血小板绝对值≤20×10^9/L。' },
      { name: '严重慢性呼吸衰竭', code: 'C26', category: '呼吸系统', type: 'critical', compensation: '100%', waitingPeriod: '90天', isHighRisk: false, isStatutory: true, definition: '指因慢性呼吸系统疾病导致永久不可逆性的呼吸衰竭，经过积极治疗180天后满足以下所有条件：静息时出现呼吸困难；肺功能检查提示一秒钟用力呼气容积（FEV1）占预计值百分比<30%。' },

      // ========== 中症疾病（25种） ==========
      { name: '中度脑损伤', code: 'M01', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因头部遭受机械性外力，引起脑重要部位损伤，导致神经系统永久性的功能障碍。须由头颅断层扫描（CT）或核磁共振检查（MRI）等影像学检查证实，且脑损伤180天后仍遗留神经系统功能障碍，但未达到重疾标准。' },
      { name: '中度阿尔茨海默病', code: 'M02', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因大脑进行性、不可逆性改变导致智能严重衰退或丧失，经影像学检查证实，且自主生活能力部分丧失，无法独立完成六项基本日常生活活动中的二项。' },
      { name: '中度帕金森病', code: 'M03', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种中枢神经系统的退行性疾病，临床表现为震颤麻痹、共济失调等。药物治疗能够部分控制病情，但已出现明显日常生活能力障碍。' },
      { name: '中度运动神经元病', code: 'M04', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一组中枢神经系统运动神经元的进行性变性疾病，自主生活能力部分丧失，无法独立完成六项基本日常生活活动中的二项。' },
      { name: '中度多发性硬化', code: 'M05', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种中枢神经系统脱髓鞘疾病，造成身体部位功能障碍，临床表现为神经功能障碍反复发作，但未达到重疾标准。' },
      { name: '中度重症肌无力', code: 'M06', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种神经与肌肉接头部位传递障碍的自身免疫性疾病，已出现明显的肌肉无力症状，影响日常生活能力，但未达到重疾标准。' },
      { name: '中度脑炎或脑膜炎后遗症', code: 'M07', category: '神经系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因患脑炎或脑膜炎导致的神经系统功能障碍，疾病确诊180天后仍遗留神经功能障碍，但未达到重疾标准。' },
      { name: '中度脑中风后遗症', code: 'M08', category: '心脑血管', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指因脑血管的突发病变引起脑血管出血、栓塞或梗塞，并导致神经系统永久性的功能障碍。神经系统永久性的功能障碍，指疾病确诊180天后，仍遗留一肢或一肢以上肢体肌力3级或3级以下的运动功能障碍。' },
      { name: '中度心肌梗死', code: 'M09', category: '心脑血管', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指被临床诊断为急性心肌梗塞并接受了急性心肌梗塞治疗，虽然未达到重疾"较重急性心肌梗死"的给付标准，但仍需满足特定的临床诊断条件。' },
      { name: '心脏瓣膜介入手术', code: 'M10', category: '心脑血管', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗心脏瓣膜疾病，实际实施了经导管进行的心脏瓣膜置换或修复的介入手术。' },
      { name: '主动脉内手术', code: 'M11', category: '心脑血管', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗主动脉疾病，实际实施了经皮经导管进行的主动脉内手术，主动脉指胸主动脉和腹主动脉。' },
      { name: '中度肺动脉高压', code: 'M12', category: '心脑血管', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指不明原因的肺动脉压力持续性增高，已经造成永久不可逆性的体力活动能力受限，达到美国纽约心脏病学会心功能状态分级III级。' },
      { name: '中度心肌病', code: 'M13', category: '心脑血管', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一组异质性心肌疾病，已经造成永久不可逆性的体力活动能力受限，达到美国纽约心脏病学会心功能状态分级III级。' },
      { name: '中度慢性呼吸衰竭', code: 'M14', category: '呼吸系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因慢性呼吸系统疾病导致呼吸功能障碍，经过积极治疗180天后，肺功能检查提示一秒钟用力呼气容积（FEV1）占预计值百分比<50%。' },
      { name: '中度克隆病', code: 'M15', category: '消化系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种慢性肉芽肿性肠炎，具有特征性的克隆病病理组织学变化，已经造成瘘管形成，但未达到重疾标准。' },
      { name: '中度溃疡性结肠炎', code: 'M16', category: '消化系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指伴有血性腹泻的溃疡性结肠炎，病变累及大部分结肠，经病理组织学检查明确诊断，但未达到重疾标准。' },
      { name: '中度慢性肝衰竭', code: 'M17', category: '消化系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因慢性肝脏疾病导致肝功能损害，须满足下列至少二项条件：持续性黄疸；腹水；脾功能亢进。' },
      { name: '慢性肾功能衰竭', code: 'M18', category: '其他', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指双肾功能慢性不可逆性衰竭，已经达到慢性肾脏病4期，肾小球滤过率（GFR）<30ml/min/1.73m^2，且持续至少90天。' },
      { name: '单侧肺脏切除', code: 'M19', category: '呼吸系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致单侧肺脏切除手术，用于治疗肺部疾病。' },
      { name: '单侧肝脏切除', code: 'M20', category: '消化系统', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致至少一整叶肝脏切除手术。' },
      { name: '单侧肾脏切除', code: 'M21', category: '其他', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致单侧肾脏切除手术。' },
      { name: '中度再生障碍性贫血', code: 'M22', category: '血液免疫', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因骨髓造血功能衰竭导致的贫血、中性粒细胞减少及血小板减少，须满足骨髓穿刺检查结果支持诊断，且外周血象具备至少二项条件。' },
      { name: '系统性红斑狼疮', code: 'M23', category: '血液免疫', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种自身免疫性结缔组织病，可累及多系统多器官，经血清学检查证实，且造成肾脏损害。' },
      { name: '类风湿性关节炎', code: 'M24', category: '血液免疫', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种以关节滑膜炎为特征的慢性全身性自身免疫性疾病，已造成关节畸形或功能障碍，达到美国风湿病学会III级及以上。' },
      { name: '中度Ⅲ度烧伤', code: 'M25', category: '其他', type: 'medium', compensation: '60%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指烧伤程度为Ⅲ度，且Ⅲ度烧伤的面积达到全身体表面积的10%或10%以上，但未达到20%。体表面积根据《中国新九分法》计算。' },

      // ========== 轻症疾病（30种，含3种法定轻症） ==========
      { name: '恶性肿瘤-轻度', code: 'L01', category: '恶性肿瘤', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指恶性细胞不受控制的进行性增长和扩散，浸润和破坏周围正常组织，经病理学检查结果明确诊断，但未达到重疾"恶性肿瘤-重度"的标准。包括：原位癌；相当于Binet分期方案A期程度的慢性淋巴细胞白血病；相当于Ann Arbor分期方案I期程度的何杰金氏病；皮肤癌（不包括恶性黑色素瘤及已发生转移的皮肤癌）；TNM分期为T1N0M0期或更轻分期的前列腺癌。' },
      { name: '较轻急性心肌梗死', code: 'L02', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指被临床诊断为急性心肌梗死并接受了急性心肌梗死治疗，虽然未达到重疾"较重急性心肌梗死"的给付标准，但仍需满足下列所有条件：心肌酶或肌钙蛋白有诊断意义的升高，或呈符合急性心肌梗死的动态变化；发病90天后，经检查证实左心室功能未降低，如左心室射血分数不低于50%。' },
      { name: '轻度脑中风后遗症', code: 'L03', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: true, definition: '指因脑血管的突发病变引起脑血管出血、栓塞或梗塞，并导致神经系统永久性的功能障碍。神经系统永久性的功能障碍，指疾病确诊180天后，仍遗留下列一种或一种以上障碍，但未达到重疾标准：一肢或一肢以上肢体肌力4级或4级以下。' },
      { name: '极早期恶性肿瘤或恶性病变', code: 'L04', category: '恶性肿瘤', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指经组织病理学检查被明确诊断为下列恶性病变，并且接受了相应的治疗：原位癌；相当于Binet分期方案A期程度的慢性淋巴细胞白血病；相当于Ann Arbor分期方案I期程度的何杰金氏病；皮肤癌（不包括恶性黑色素瘤及已发生转移的皮肤癌）。' },
      { name: '不典型的急性心肌梗塞', code: 'L05', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指被临床诊断为急性心肌梗塞并接受了急性心肌梗塞治疗，虽然未达到重大疾病"急性心肌梗塞"的给付标准，但满足下列至少二项条件：典型临床表现，例如急性胸痛等；新近的心电图改变提示急性心肌梗塞；心肌酶或肌钙蛋白有诊断意义的升高。' },
      { name: '轻微脑中风', code: 'L06', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指因脑血管的突发病变引起脑血管出血、栓塞或梗塞，导致神经系统功能障碍，但未达到中症或重疾标准。' },
      { name: '冠状动脉介入手术', code: 'L07', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指为治疗明显的冠状动脉狭窄性疾病，首次实际实施了冠状动脉球囊扩张成形术、冠状动脉支架植入术、冠状动脉粥样斑块切除术或激光冠状动脉成形术。' },
      { name: '微创冠状动脉搭桥术', code: 'L08', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗严重的冠心病，实际实施了微创的冠状动脉血管旁路移植的手术，包括胸腔镜辅助下的冠状动脉搭桥手术。' },
      { name: '心脏瓣膜介入手术', code: 'L09', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗心脏瓣膜疾病，实际实施了经皮经导管进行的心脏瓣膜置换或修复的介入手术。' },
      { name: '主动脉内手术', code: 'L10', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗主动脉疾病，实际实施了经皮经导管进行的主动脉内手术，如主动脉瘤支架植入等。' },
      { name: '轻度面部烧伤', code: 'L11', category: '其他', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指烧伤程度为Ⅲ度，且Ⅲ度烧伤的面积达到面部表面积的30%或30%以上。' },
      { name: '单耳失聪', code: 'L12', category: '其他', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致单耳听力永久不可逆性丧失，在500赫兹、1000赫兹和2000赫兹语音频率下，平均听阈大于91分贝。' },
      { name: '单眼失明', code: 'L13', category: '其他', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致单眼视力永久不可逆性丧失，该眼须满足下列至少一项条件：眼球缺失或摘除；矫正视力低于0.02；视野半径小于5度。' },
      { name: '单侧肺脏切除', code: 'L14', category: '呼吸系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致单侧肺脏切除手术，用于治疗肺部疾病，但未达到中症标准。' },
      { name: '单侧肝脏切除', code: 'L15', category: '消化系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致部分肝脏切除手术，但未达到中症标准。' },
      { name: '单侧肾脏切除', code: 'L16', category: '其他', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因疾病或意外伤害导致单侧肾脏切除手术，但未达到中症标准。' },
      { name: '早期肝硬化', code: 'L17', category: '消化系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指肝硬化早期，肝脏组织病理学检查显示有肝硬化改变，肝脏功能尚在代偿期。' },
      { name: '慢性肾功能不全', code: 'L18', category: '其他', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指双肾功能慢性损害，已经达到慢性肾脏病3期，肾小球滤过率（GFR）<60ml/min/1.73m^2，且持续至少90天。' },
      { name: '轻度慢性呼吸衰竭', code: 'L19', category: '呼吸系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因慢性呼吸系统疾病导致呼吸功能障碍，经过积极治疗180天后，肺功能检查提示一秒钟用力呼气容积（FEV1）占预计值百分比<70%。' },
      { name: '糖尿病并发症', code: 'L20', category: '内分泌代谢', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: true, isStatutory: false, definition: '指因糖尿病导致的并发症，包括糖尿病视网膜病变、糖尿病肾病或糖尿病足等，经专科医生明确诊断。' },
      { name: '轻度帕金森病', code: 'L21', category: '神经系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指一种中枢神经系统的退行性疾病，临床表现为震颤麻痹，药物治疗能够控制病情，日常生活能力轻度受损。' },
      { name: '轻度阿尔茨海默病', code: 'L22', category: '神经系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因大脑进行性改变导致智能衰退，经影像学检查证实，出现轻度认知能力障碍，日常生活能力轻度受损。' },
      { name: '脑垂体瘤', code: 'L23', category: '神经系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指发生在垂体的良性肿瘤，已经引起内分泌功能紊乱或神经系统症状，需要手术治疗或放射治疗。' },
      { name: '轻度脑损伤', code: 'L24', category: '神经系统', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因头部遭受机械性外力，引起脑损伤，导致轻度神经系统功能障碍，但未达到中症标准。' },
      { name: '植入腔静脉滤器', code: 'L25', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因静脉血栓形成，实际实施了腔静脉滤器植入手术。' },
      { name: '植入心脏起搏器', code: 'L26', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因严重心律失常，实际实施了永久性心脏起搏器植入手术。' },
      { name: '植入除颤器', code: 'L27', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因严重心律失常，实际实施了心脏复律除颤器（ICD）植入手术。' },
      { name: '激光心肌血运重建术', code: 'L28', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗顽固性心绞痛，实际实施了激光心肌血运重建术。' },
      { name: '心包膜切除术', code: 'L29', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指为治疗心包膜疾病，实际实施了心包膜切除术。' },
      { name: '风湿性心脏病', code: 'L30', category: '心脑血管', type: 'light', compensation: '30%', waitingPeriod: '90天', isHighRisk: false, isStatutory: false, definition: '指因风湿热活动，累及心脏瓣膜而造成的心脏瓣膜病变，已出现心功能不全症状，达到美国纽约心脏病学会心功能状态分级II级及以上。' }
    ],
    company: enrichCompanyData(2, { foundedYear: 1999, registeredCapital: 27.7, hotline: '400-600-8899', website: 'www.icbc-axa.com.cn', description: '工银安盛人寿保险有限公司是由中国工商银行、法国安盛集团和中国五矿集团公司共同发起组建的合资保险公司。', companyTypeDesc: '合资', riskRating: 'A', solvencyRatio: 172.3 })
  }
}
