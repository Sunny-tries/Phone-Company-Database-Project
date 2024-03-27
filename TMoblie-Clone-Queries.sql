-- Identify customers with no text and phone call activity last month. Display the customer name and device model.
SELECT CUSTOMER.CUSTOMER_FIRST, CUSTOMER.CUSTOMER_LAST,
(
        SELECT MODEL
        FROM TMOBLIE_PRODUCT
        WHERE DEVICEID = (
            SELECT DEVICEID
            FROM CUSTOMER_DEVICE
            WHERE CUSTOMERID = CUSTOMER.CUSTOMERID
            ORDER BY IMEI DESC
            LIMIT 1
        ))
FROM CUSTOMER
WHERE CUSTOMER.CUSTOMERID NOT IN (SELECT CALL_LOG.CUSTOMERID FROM CALL_LOG) AND CUSTOMER.CUSTOMERID NOT IN (SELECT TEXT_LOG.CUSTOMERID FROM TEXT_LOG);

-- Identify customers without phones. Display the customer name and email.
SELECT CUSTOMER.CUSTOMER_FIRST, CUSTOMER.CUSTOMER_LAST, CUSTOMER.EMAIL
FROM CUSTOMER
WHERE CUSTOMER.CUSTOMERID NOT IN (SELECT CUSTOMERID FROM CUSTOMER_DEVICE);

-- Identify bytes sent and received by customers last month. Display 6 columns: Customer first, Customer last, Device model, total bytes sent, total bytes received, total bytes (sent and received). Display the bytes as GB. Display 1 row for each distinct customer.
SELECT
    CUSTOMER_FIRST,
    CUSTOMER_LAST,
    (
        SELECT MODEL
        FROM TMOBLIE_PRODUCT
        WHERE DEVICEID = (
            SELECT DEVICEID
            FROM CUSTOMER_DEVICE
            WHERE CUSTOMERID = CUSTOMER.CUSTOMERID
            ORDER BY IMEI DESC
            LIMIT 1
        )
    ) AS DEVICE_MODEL,
(
	SELECT SUM(BYTES_SENT)
    FROM CUSTOMER_WEB
    WHERE CUSTOMER.CUSTOMERID = CUSTOMER_WEB.CUSTOMERID
    LIMIT 1

)AS GB_SENT,
(
	SELECT SUM(BYTES_RECEIVED)
    FROM CUSTOMER_WEB
    WHERE CUSTOMER.CUSTOMERID = CUSTOMER_WEB.CUSTOMERID
    LIMIT 1

)AS GB_RECEIVED
        
    FROM CUSTOMER;

-- Identify the most popular phone number called last year in NYC. Display 2 columns: Phone number called and number of calls. Display the most popular phone number called first. Display 1 row for each distinct phone number called.
SELECT PHONENUMBER, (
	SELECT COUNT(ISSENT)
	FROM CALL_LOG
	WHERE IMEI = CUSTOMER_DEVICE.IMEI
    ) AS NUM_CALLS
    FROM CUSTOMER_DEVICE
    WHERE CUSTOMER_DEVICE.IMEI IN (
		SELECT IMEI
        FROM CALL_LOG
        WHERE ISSENT = TRUE)
        ORDER BY NUM_CALLS DESC;

-- Identify customers who sent or received calls from 202-456-1111 last year. Display the customer name, date of call and length of call.
SELECT
    C.CUSTOMER_FIRST,
    C.CUSTOMER_LAST,
    CL.DATE_CALL,
    CL.LENGTH_OF_CALL
FROM
    CUSTOMER C,
    CALL_LOG CL,
    CUSTOMER_DEVICE CD
WHERE
    (CD.PHONENUMBER = '6465178133' AND (CL.CALL_TO = CD.IMEI OR CL.IMEI = CD.IMEI))
    AND C.CUSTOMERID = CL.CUSTOMERID
    AND MONTH(CL.DATE_CALL) = 11
ORDER BY
    C.CUSTOMER_FIRST,
    C.CUSTOMER_LAST,
    CL.DATE_CALL;

-- Identify customers who included hostile words in text messages last month. Display the customer name, date of text and text message.
SELECT DISTINCT CUSTOMER.CUSTOMER_FIRST, TEXT_MESSAGE, DATE_TEXT
FROM TEXT_LOG, CUSTOMER
WHERE ((TEXT_MESSAGE LIKE '%bad%') OR (TEXT_MESSAGE LIKE '%mad%')) AND
(CUSTOMER.CUSTOMERID IN (
		SELECT DISTINCT TEXT_LOG.CUSTOMERID
		FROM TEXT_LOG
        WHERE (TEXT_MESSAGE LIKE '%bad%') OR (TEXT_MESSAGE LIKE '%mad%')));

--Identify the most popular device model for NJ active customers this year. Display 4 columns: Customer first, customer last, device model, number of devices. Display the most popular device first. Display 1 distinct row for each customer.
SELECT
    CUSTOMER_FIRST,
    CUSTOMER_LAST,
    (
        SELECT MODEL
        FROM TMOBLIE_PRODUCT
        WHERE DEVICEID = (
            SELECT DEVICEID
            FROM CUSTOMER_DEVICE
            WHERE CUSTOMERID = CUSTOMER.CUSTOMERID
            ORDER BY IMEI DESC
            LIMIT 1
        )
    ) AS DEVICE_MODEL,
    (
        SELECT COUNT(DISTINCT DEVICEID)
        FROM CUSTOMER_DEVICE
        WHERE CUSTOMERID = CUSTOMER.CUSTOMERID
    ) AS NUMBER_OF_DEVICES
FROM
    CUSTOMER
WHERE
    STATE = 'NY' AND CUSTOMERID IN (
        SELECT DISTINCT CUSTOMERID
        FROM ACTIVATION
        WHERE MONTH(DATE_OF_ACTIVATION) = 11
    )
ORDER BY
    NUMBER_OF_DEVICES DESC;

-- Identify text messages exchanged between Bob and Sally this month. Display the date of text, sender, receiver and text message. Display the messages in chronological order
SELECT DATE_TEXT, TEXT_FROM AS SENDER, TEXT_TO AS RECEIVER, TEXT_MESSAGE
FROM TEXT_LOG
WHERE (TEXT_FROM = '865075050229646' AND TEXT_TO = NULL)
   OR (TEXT_FROM = null AND TEXT_TO = '357211095271526')
   AND DATE_TEXT BETWEEN '2023-10-01' AND '2023-10-30'
ORDER BY DATE_TEXT, TIME_TEXT;

-- Identify text messages exchanged near Queens College on October 5 between 9 and 10 am. Display the date of text, sender, receiver and text message. Display the messages in chronological order.
SELECT TEXT_MESSAGE, DATE_TEXT,(
	SELECT CUSTOMER_FIRST
    FROM CUSTOMER
    WHERE CUSTOMERID IN (
		SELECT CUSTOMERID
        FROM TEXT_LOG
        WHERE (TIME_TEXT >= '3:00:00' AND TIME_TEXT <= '5:00:00') AND (TEXT_FROM IS NOT NULL)
))AS MESSAGE_TO, (
		SELECT CUSTOMER_FIRST
    FROM CUSTOMER
    WHERE CUSTOMERID IN (
		SELECT CUSTOMERID
        FROM TEXT_LOG
        WHERE (TIME_TEXT >= '3:00:00' AND TIME_TEXT <= '5:00:00')AND (TEXT_TO IS NOT NULL)
		
	) )AS SENT_FROM
FROM TEXT_LOG
WHERE (RECEIVER_ZIP = 11367 OR SENDER_ZIP = 11367) AND DATE_TEXT = '20231001' AND (TIME_TEXT >= '3:00:00' AND TIME_TEXT <= '05:00:00');

-- Identify customers with more than 1 phone. Display the customer name and number of phones. Display 1 distinct row for each customer.
SELECT CUSTOMER.CUSTOMER_FIRST, CUSTOMER.CUSTOMER_LAST,
	(SELECT COUNT(CUSTOMERID)
    FROM CUSTOMER_DEVICE
    WHERE CUSTOMERID = CUSTOMER.CUSTOMERID
    ) AS NUMBER_OF_PHONES
FROM CUSTOMER
WHERE (SELECT COUNT(CUSTOMERID)
    FROM CUSTOMER_DEVICE
    WHERE CUSTOMERID = CUSTOMER.CUSTOMERID) > 1;

