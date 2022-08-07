/*
POSTGRES EXTENSION
* PostGIS: support for location queries
* PostPic: support for image queries
* fuzzystrmatch & pg_trgm: support for full text search capabilities by finding similarities between strings
*/

-- ----------
-- EXTENSIONS
-- ----------
-- available extensions
SELECT *
FROM pg_available_extensions;

-- installed extensions
SELECT *
FROM pg_extension;

-- use pg_trgm
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

SELECT 
  title, 
  description, 
  -- Calculate the similarity
  SIMILARITY(title, description) -- pg_trgm
FROM 
  film


-- Select the title and description columns
SELECT  
  title, 
  description, 
  -- Calculate the levenshtein distance
  levenshtein(title, 'JET NEIGHBOR') AS distance -- fuzzystrmatc'
  h
FROM 
  film
ORDER BY 3
