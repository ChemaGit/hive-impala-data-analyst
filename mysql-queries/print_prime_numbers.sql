/*
Write a query to print all prime numbers less than or equal to 1000. Print your result on a single line,
and use the ampersand (&) character as your separator (instead of a space).

For example, the output for all prime numbers <= 10 would be:

2&3&5&7
*/

CREATE FUNCTION isPrime(num INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE result TINYINT;
    DECLARE aux INT;
    DECLARE cont INT;
    SET cont = 3;
    IF num % 2 <> 0 THEN
        SET aux = FLOOR(SQRT(num));
        SET result = 1;
        WHILE (cont <= aux AND result = 1) DO
            IF num % cont = 0 THEN
                SET result = 0;
            END IF;
            SET cont = cont + 1;
        END WHILE;
    ELSEIF num = 2 THEN
        SET result = 1;
    ELSE
        SET result = 0;
    END IF;

    RETURN result;
END;


CREATE FUNCTION primeNumbers (offlimit INT)
RETURNS VARCHAR(2048) DETERMINISTIC
BEGIN
    DECLARE word VARCHAR(2048);
    DECLARE result VARCHAR(2048);
    DECLARE isPrime TINYINT;
    DECLARE cont INT;
    SET cont = 2;
    SET isPrime = 0;
    SET word = '&';
    SET result = '';

    WHILE cont < offlimit DO
        IF isPrime(cont) = 1 THEN
            IF LENGTH(result) = 0 THEN
                SET result = CONCAT(result,cont);
            ELSE
                SET result = CONCAT(result, word, cont);
            END IF;
        END IF;

        SET cont = cont + 1;
    END WHILE;
    RETURN result;
END;


SELECT primeNumbers(1000) AS prime_numbers;

/*
2&3&5&7&11&13&17&19&23&29&31&37&41&43&47&53&59&61&67&71&73&79&83&89&97&101&103&107&109&113&127&131&137&139&149&151&157&163&167&173&179&181&191&193&197&199&211&223&227&229&233&239&241&251&257&263&269&271&277&281&283&293&307&311&313&317&331&337&347&349&353&359&367&373&379&383&389&397&401&409&419&421&431&433&439&443&449&457&461&463&467&479&487&491&499&503&509&521&523&541&547&557&563&569&571&577&587&593&599&601&607&613&617&619&631&641&643&647&653&659&661&673&677&683&691&701&709&719&727&733&739&743&751&757&761&769&773&787&797&809&811&821&823&827&829&839&853&857&859&863&877&881&883&887&907&911&919&929&937&941&947&953&967&971&977&983&991&997
*/

SET @p_prime = 1;
SET @divd = 1;

SELECT GROUP_CONCAT(P_PRIME SEPARATOR '&') AS primes FROM
    (SELECT @p_prime := @p_prime + 1 AS P_PRIME FROM
    information_schema.tables t1,
    information_schema.tables t2
    LIMIT 1000) lst_primes
WHERE NOT EXISTS(
	SELECT * FROM
        (SELECT @divd := @divd + 1 AS DIVD FROM
	    information_schema.tables t4,
        information_schema.tables t5
	    LIMIT 1000) list_div
	WHERE P_PRIME % DIVD = 0 AND P_PRIME <> DIVD);

/*
2&3&5&7&11&13&17&19&23&29&31&37&41&43&47&53&59&61&67&71&73&79&83&89&97&101&103&107&109&113&127&131&137&139&149&151&157&163&167&173&179&181&191&193&197&199&211&223&227&229&233&239&241&251&257&263&269&271&277&281&283&293&307&311&313&317&331&337&347&349&353&359&367&373&379&383&389&397&401&409&419&421&431&433&439&443&449&457&461&463&467&479&487&491&499&503&509&521&523&541&547&557&563&569&571&577&587&593&599&601&607&613&617&619&631&641&643&647&653&659&661&673&677&683&691&701&709&719&727&733&739&743&751&757&761&769&773&787&797&809&811&821&823&827&829&839&853&857&859&863&877&881&883&887&907&911&919&929&937&941&947&953&967&971&977&983&991&997
*/