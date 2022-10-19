WITH distinct_correct_A AS
(
	SELECT DISTINCT
		A.dimension_1,
		MAP.correct_dimension_2 AS dimension_2,
		A.dimension_3,
		A.measure_1
	FROM
		[test].[dbo].[A]
		JOIN [test].[dbo].[MAP] ON MAP.dimension_1 = A.dimension_1
),

distinct_correct_B AS

(
	SELECT DISTINCT
		B.dimension_1,
		MAP.correct_dimension_2 AS dimension_2,
		B.measure_2
	FROM
		[test].[dbo].[B]
		JOIN [test].[dbo].[MAP] ON MAP.dimension_1 = B.dimension_1
),

distinct_correct_reduced_A AS

(
	SELECT
		dca.dimension_1,
		dca.dimension_2,
		SUM(dca.measure_1) AS measure_1
	FROM
		distinct_correct_A dca
	GROUP BY
		dca.dimension_1,
		dca.dimension_2
),

distinct_correct_reduced_B AS

(
	SELECT
		dcb.dimension_1,
		dcb.dimension_2,
		SUM(dcb.measure_2) AS measure_2
	FROM
		distinct_correct_B dcb
	GROUP BY
		dcb.dimension_1,
		dcb.dimension_2
)

SELECT
	ISNULL(dcra.dimension_1, dcrb.dimension_1) AS dimension_1,
	ISNULL(dcra.dimension_2, dcrb.dimension_2) AS dimension_2,
	ISNULL(SUM(dcra.measure_1), 0) AS measure_1,
	ISNULL(SUM(dcrb.measure_2), 0) AS measure_2
FROM
	distinct_correct_reduced_A dcra
	FULL OUTER JOIN distinct_correct_reduced_B dcrb ON dcrb.dimension_1 = dcra.dimension_1 AND dcrb.dimension_1 = dcra.dimension_1
GROUP BY
	dcra.dimension_1,
	dcrb.dimension_1,
	dcra.dimension_2,
	dcrb.dimension_2
ORDER BY
	dimension_1
	
	

