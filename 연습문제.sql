#3-1번문제
# 멕시코(Mexico)보다 인구가 많은 나라이름과 인구수를 조회하시고 인구수 순으로 내림차순하세요.
SELECT NAME, population
FROM country
WHERE population >
	(SELECT population 
		FROM country
		WHERE name = "Mexico")
ORDER BY population DESC

# 3-2번 문제
# 국가별 몇개의 도시가 있는지 조회하고 도시수 순으로 10위까지 내림차순 하세요
SELECT country.code, count(country.name), count(city.name)AS count
FROM country
JOIN city
ON country.code = city.CountryCode
GROUP BY country.code
ORDER BY COUNT DESC
LIMIT 10

# 3-3번 문제
# 언어별 사용인구를 출력하고 언어 사용인구 순으로 10위까지 내림차순하세요.
SELECT count(countrylanguage.CountryCode), countrylanguage.language, sum(((countrylanguage.percentage)*(country.population))/100) AS total
FROM countrylanguage
LEFT JOIN country
ON countrylanguage.CountryCode = country.code
GROUP BY countrylanguage.language 
ORDER BY total DESC
LIMIT 10

# 3-4번 문제
# 나라 전체 인구의 10%이상인 도시에서 도시인구가 500만이 넘는 도시를 아래와 같이 조회 하세요.
SELECT city.name, city.countrycode, country.name, round(((city.population/country.population)*100),2) AS percentage
FROM city
JOIN country
ON country.code = city.CountryCode
WHERE city.population > (country.population/10) AND city.population > 5000000
ORDER BY percentage DESC




#3-5번 문제
# 5. 면적이 10000km^2 이상인 국가의 인구밀도(1km^2 당 인구수)를 구하고 인구밀도가 200이상인 국가들의 사용하고 있는 언어수가 5가지 이상인 나라를 조회 하세요.
SELECT country.name, COUNT(countrylanguage.language) AS language_count
FROM (
SELECT CODE, NAME, round(population/surfacearea,0) AS density 
FROM country
WHERE surfacearea > 10000 AND (population/surfacearea) > 200

ORDER BY density DESC 
) AS country
JOIN countrylanguage
ON countrylanguage.CountryCode = country.code
GROUP BY country.name
HAVING language_count >5
ORDER BY language_count DESC


#3-6번 문제
#6. 사용하는 언어가 3가지 이하인 국가중 도시인구가 300만 이상인 도시를 아래와 같이 조회하세요.
#* GROUP_CONCAT(LANGUAGE) 을 사용하면 group by 할때 문자열을 합쳐서 볼수 있습니다.
#* VIEW를 이용해서 query를 깔끔하게 수정하세요.
create VIEW city_language AS 
SELECT B.countrycode, B.name, B.population, country.name, B.language_count, B.languages
from
(SELECT city.countrycode, city.name, city.population, L.language_count, L.languages
FROM 
(SELECT countrycode, GROUP_CONCAT(LANGUAGE)AS LANGUAGEs , COUNT(LANGUAGE) AS language_count 
FROM countrylanguage
GROUP BY countrycode
HAVING COUNT(LANGUAGE) <= 3) AS L
JOIN city
ON L.countrycode = city.countrycode
HAVING city.population > 3000000) AS B
JOIN country
ON country.code = B.countrycode
ORDER BY B.population desc