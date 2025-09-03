-- Ödev 12 — dvdrental


-- 1) Ortalama film uzunluğundan (length) uzun kaç film vardır?
SELECT COUNT(*) AS count_length_above_avg
FROM film
WHERE length > (SELECT AVG(length) FROM film);


-- 2) En yüksek rental_rate değerine sahip kaç film vardır?
SELECT COUNT(*) AS count_with_max_rental_rate
FROM film
WHERE rental_rate = (SELECT MAX(rental_rate) FROM film);


-- 3) En düşük rental_rate **VE** en düşük replacement_cost değerlerine sahip filmler
-- Not: Eğer veri kümesinde aynı anda iki minimumu birden taşıyan film yoksa
-- bu sorgu 0 satır döndürebilir. O durumda aşağıdaki alternatifleri kullan.
SELECT film_id, title, rental_rate, replacement_cost
FROM film
WHERE rental_rate = (SELECT MIN(rental_rate) FROM film)
AND replacement_cost = (SELECT MIN(replacement_cost) FROM film)
ORDER BY title;


-- 3a) (Alternatif) En düşük rental_rate’e sahip filmler
-- SELECT film_id, title, rental_rate, replacement_cost
-- FROM film
-- WHERE rental_rate = (SELECT MIN(rental_rate) FROM film)
-- ORDER BY title;


-- 3b) (Alternatif) En düşük replacement_cost’a sahip filmler
-- SELECT film_id, title, rental_rate, replacement_cost
-- FROM film
-- WHERE replacement_cost = (SELECT MIN(replacement_cost) FROM film)
-- ORDER BY title;


-- 4) payment tablosunda en fazla sayıda alışveriş yapan müşteriler
-- 4a) Tüm müşterileri ödeme sayısına göre azalan sırala
SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS payment_count
FROM payment AS p
JOIN customer AS c ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY payment_count DESC, c.customer_id;


-- 4b) Sadece "en çok ödemeye sahip" müşteri/müşterileri getir
WITH pay_counts AS (
SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS payment_count
FROM payment AS p
JOIN customer AS c ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM pay_counts
WHERE payment_count = (SELECT MAX(payment_count) FROM pay_counts)
ORDER BY customer_id;
