/*
You have been given below table.
HadoopInt (value int, property string);

Calculate variance, for sample and entire population.
As well as 'standard_deviation' for decimal value 7,4
*/
-- Calculate Variance
SELECT VARIANCE(value) FROM HadoopInt;

-- Calculate Variance for Sample
SELECT VARIANCE_SAMP(value) FROM HadoopInt;

-- Calculate Variance for entire population
SELECT VARIANCE_POP(value) FROM HadoopInt;

-- Calculate Standard_deviation
SELECT STDDEV(value) FROM HadoopInt;

CREATE TABLE HadoopVar
AS SELECT CAST(STDDEV(value) AS decimal(7,4)) AS standard_deviation,
    CAST(VARIANCE(value) AS decimal(7,4)) AS variance,
    CAST(VARIANCE_SAMP(value) AS decimal(7,4)) AS variance_samp,
    CAST(VARIANCE_POP(value) AS decimal(7,4)) AS variance_pop
FROM HadoopInt;

SELECT *
FROM HadoopVar;