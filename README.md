# Tmoblie-Clone-Database-Project

## Introduction
This SQL project is designed as a simplified clone of a T-Mobile database, focusing on customer, device, and usage data management. The database is structured to meet specific querying needs while adhering to the 4th Normal Form, showcasing advanced database normalization techniques. Despite the complexity in data relationships, the project avoids the use of joins, favoring nested selects for data retrieval, and was fully developed in MySQL Workbench.

## Database Structure
The database includes several tables that collectively manage customer information, device details, activation records, call logs, text logs, web usage data, and invoicing. The structure is designed to simulate real-world operations of a mobile carrier, including customer management, device tracking, service usage (calls, texts, web browsing), and billing.

### Key Tables
- **CUSTOMER**: Stores detailed information about each customer, including name, address, DOB, and contact details.
- **TMOBILE_PRODUCT**: Catalogs available mobile devices with specifications such as brand, model, and capacity.
- **CUSTOMER_DEVICE**: Links customers to their devices, including phone numbers and SIM IDs.
- **ACTIVATION**: Tracks device activations and deactivations for each customer.
- **CALL_LOG** and **TEXT_LOG**: Record details of calls and texts made and received by customers, including timestamps and sender/receiver details.
- **CUSTOMER_WEB**: Logs web usage data for each device, tracking URLs accessed and data sent/received.
- **INVOICE**: Manages billing information for each customer, including costs and payment details.

The database design allows for comprehensive tracking of customer interactions and device usage, supporting detailed analysis and reporting.

## Queries
A series of specific queries were developed to extract useful information from the database, addressing needs such as identifying inactive customers, devices without associated phones, and detailed usage statistics. These queries showcase the ability to derive insights from complex data structures without relying on SQL joins, instead utilizing nested selects to navigate the relational database effectively.

### Examples of Query Functions
- **Customer Activity Analysis**: Identifies customers with no recent call or text activity and those without any registered devices.
- **Usage Statistics**: Aggregates web usage data to report on data consumption by customer and device, converting raw data into more comprehensible metrics like GB sent and received.
- **Device Popularity**: Determines the most popular devices among active customers, highlighting trends and preferences.
- **Communication Patterns**: Extracts detailed records of communications between specific customers and within certain parameters, like location and time.

## Project Reflections
This project was an exercise in applying advanced database design principles and querying techniques within a realistic business scenario. By adhering to the 4th Normal Form, the database ensures data integrity and reduces redundancy, while the use of nested selects over joins demonstrates an alternative approach to querying relational databases.

Future enhancements could explore the integration of more complex querying techniques, including joins, to improve efficiency and expand the range of analytical capabilities. Additionally, further normalization and the introduction of new tables could offer deeper insights into usage patterns and customer behavior.

## Conclusion
The T-Mobile Clone Database Project stands as a testament to the power of SQL in managing and analyzing complex datasets. It offers a solid foundation for understanding the intricacies of database design and manipulation, paving the way for more advanced exploration of data within the telecommunications domain.
