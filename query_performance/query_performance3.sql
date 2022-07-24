/*
여러가지 Statement보다는 하나의 LIST를 쓰는 것이 성능상 좋음
1. OR 보다는 IN을 사용하는 것이 좋음
2. LIKE OR을 사용하기보다는 ANY(ARRAY[])를 사용하는 것이 성능상 좋음

TEXT보다는 NUMERIC 한 것을 사용하는 것이 성능상 좋음
왜냐하면 NUMERIC이 결국 저장 공간이 작기에(비트로 표현했을 때 길이가 짧음)
*/

-- 지양
SELECT COUNT(*)
FROM athletes_wint 
WHERE age = 11
OR age = 12;

-- 지향 (가능하다면 IN으로)
SELECT *
FROM athletes_wint 
WHERE age IN (11,12);


-- 지양
SELECT games
  , name
  , age
FROM athletes_wint
WHERE games IN ('1960 Winter', '2010 Winter')
ORDER BY games;

-- 지향 (가능하다면 숫자로)
SELECT games
  , name
  , age
FROM athletes_wint
WHERE year IN (1960,2010)
ORDER BY games;

-- 지양
SELECT
    *
FROM
    mimic_hosp.prescriptions
WHERE
    LOWER(drug) LIKE '%atorvastatin%'
    OR LOWER(drug) LIKE '%pitavastatin%'
    OR LOWER(drug) LIKE '%lovastatin%'
    OR LOWER(drug) LIKE '%simvastatin%'

-- 지향
-- postgresql에서 REGEX를 쓰는것보다 시간적 효율은 높은 것으로 나타남, 단 자원은 더 소모하는 것으로 나타남
SELECT
    *
FROM
    mimic_hosp.prescriptions
WHERE
    LOWER(drug) LIKE ANY(
        ARRAY [ 
        '%atorvastatin%',
        '%pitavastatin%',
        '%lovastatin%',
        '%simvastatin%' 
        ]
    )
