   SELECT a.days_to_class_start AS days_to_term_start,
          a.is_enrolled,
          a.student_id,
          a.term_id,
          a.year,
          a.season,
          a.student_type_desc AS student_type,
          a.date AS enrollment_date,
          p.college_abbrv AS college,
          p.department_id AS department,
          b.primary_program_id AS program,
          c.gender_code AS gender,
          c.ipeds_race_ethnicity AS race_ethnicity,
          CASE
             WHEN b.institutional_cumulative_gpa < 2.0 THEN '0_to_2'
             WHEN b.institutional_cumulative_gpa >= 2.0
              AND b.institutional_cumulative_gpa < 2.5 THEN '2_to_2.5'
             WHEN b.institutional_cumulative_gpa >= 2.5
              AND b.institutional_cumulative_gpa < 3.0 THEN '2.5_to_3'
             WHEN b.institutional_cumulative_gpa >= 3.0
              AND b.institutional_cumulative_gpa <= 4.0 THEN '3_to_4'
          END AS gpa_band
     FROM export.daily_enrollment a
LEFT JOIN export.student_term_level b
       ON a.student_id = b.student_id
      AND a.term_id = b.term_id
      AND b.is_primary_level
LEFT JOIN export.student c
       ON c.student_id = a.student_id
LEFT JOIN export.academic_programs p
       ON p.program_id = b.primary_program_id
    WHERE a.term_id IN ('202240', '202340')
      AND a.is_enrolled