-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2025 at 08:07 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `authis_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `api_clients`
--

CREATE TABLE `api_clients` (
  `id` int(10) UNSIGNED NOT NULL,
  `institution_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `api_key` varchar(255) NOT NULL,
  `secret_key` varchar(255) NOT NULL,
  `allowed_ip_ranges` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`allowed_ip_ranges`)),
  `allowed_origins` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`allowed_origins`)),
  `rate_limit_per_minute` int(10) UNSIGNED DEFAULT 60,
  `webhook_url` varchar(500) DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`permissions`)),
  `status` enum('ACTIVE','SUSPENDED','PENDING_APPROVAL','DEACTIVATED') DEFAULT 'PENDING_APPROVAL',
  `last_used_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `api_logs`
--

CREATE TABLE `api_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `api_client_id` int(10) UNSIGNED NOT NULL,
  `endpoint` varchar(500) NOT NULL,
  `http_method` enum('GET','POST','PUT','DELETE','PATCH','OPTIONS','HEAD') NOT NULL,
  `request_headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`request_headers`)),
  `request_payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`request_payload`)),
  `request_ip` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `response_status_code` int(10) UNSIGNED NOT NULL,
  `response_headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response_headers`)),
  `response_payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response_payload`)),
  `processing_time_ms` int(10) UNSIGNED DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `request_size_bytes` int(10) UNSIGNED DEFAULT NULL,
  `response_size_bytes` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(10) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `request_method` enum('GET','POST','PUT','DELETE','PATCH') DEFAULT NULL,
  `endpoint` varchar(500) DEFAULT NULL,
  `status_code` int(10) UNSIGNED DEFAULT NULL,
  `details_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details_json`)),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `certificates` (
  `id` int(10) UNSIGNED NOT NULL,
  `student_id` int(10) UNSIGNED NOT NULL,
  `institution_id` int(10) UNSIGNED NOT NULL,
  `programme_id` int(10) UNSIGNED DEFAULT NULL,
  `certificate_number` varchar(100) NOT NULL,
  `qualification_name` varchar(255) NOT NULL,
  `award_class` varchar(50) DEFAULT NULL,
  `grade_point_average` decimal(3,2) DEFAULT NULL,
  `date_of_award` date NOT NULL,
  `issue_date` date NOT NULL,
  `status` enum('ISSUED','REVOKED','PENDING_BLOCKCHAIN','ON_CHAIN') DEFAULT 'PENDING_BLOCKCHAIN',
  `qr_code_value` varchar(500) NOT NULL,
  `plain_data_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`plain_data_json`)),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `certificate_blockchain_records`
--

CREATE TABLE `certificate_blockchain_records` (
  `id` int(10) UNSIGNED NOT NULL,
  `certificate_id` int(10) UNSIGNED NOT NULL,
  `blockchain_network` enum('ETH_TESTNET','BSC_TESTNET','POLYGON','ETH_MAINNET') DEFAULT 'ETH_TESTNET',
  `smart_contract_address` varchar(255) NOT NULL,
  `transaction_hash` varchar(255) NOT NULL,
  `on_chain_hash` varchar(255) NOT NULL,
  `block_number` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('PENDING','CONFIRMED','FAILED') DEFAULT 'PENDING',
  `submitted_at` datetime DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `certificate_documents`
--

CREATE TABLE `certificate_documents` (
  `id` int(10) UNSIGNED NOT NULL,
  `certificate_id` int(10) UNSIGNED NOT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `file_url` varchar(500) DEFAULT NULL,
  `file_type` enum('PDF','IMAGE_PNG','IMAGE_JPEG') DEFAULT 'PDF',
  `storage_provider` enum('LOCAL','S3','CLOUD_STORAGE') DEFAULT 'LOCAL',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `institutions`
--

CREATE TABLE `institutions` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'INSTITUTION FULL NAME',
  `institution_type_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO INSTITUTION TYPES',
  `registration_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ZIMCHE REGISTRATION NUMBER',
  `address_line1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'PRIMARY  ADDRESS LINE',
  `address_line2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SECONDARY ADDRESS LINE',
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'CITY LOCATION',
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'COUNTRY',
  `contact_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'PRIMARY CONTACT EMAIL',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'PRIMARY CONTACT PHONE',
  `website_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'INSTITUTION WEBSITE',
  `status` enum('PENDING_APPROVAL','APPROVED','SUSPENDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'INSTITUTION STATUS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD CREATION TIME',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD LAST UPDATE TIME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `institution_types`
--

CREATE TABLE `institution_types` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `code` enum('UNIVERSITY','COLLEGE','EXAM_BOARD','EMPLOYER','REGULATOR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'INSTITUTION TYPE CODE',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'INSTITUTION TYPE NAME',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'TYPE DESCRIPTION'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `institution_users`
--

CREATE TABLE `institution_users` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `institution_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO INSTITUONS TABLE',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO USERS TABLE',
  `position_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'USERS POSITION AT INSTITUTION',
  `is_primary_contact` tinyint(1) NOT NULL COMMENT 'IS THIS THE MAIN CONTACT OF THEE PERSON?',
  `status` enum('ACTIVE','INACTIVE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'USER-INSTITUTION RELATIONSHIP STATUS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD CREATION TIME',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'LAST UPDATE TIME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(10) UNSIGNED NOT NULL,
  `invoice_number` varchar(100) NOT NULL,
  `payer_institution_id` int(10) UNSIGNED DEFAULT NULL,
  `payer_user_id` int(10) UNSIGNED DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `currency` enum('USD','ZWL','ZAR','GBP','EUR') DEFAULT 'USD',
  `status` enum('DRAFT','ISSUED','PAID','OVERDUE','CANCELLED') DEFAULT 'DRAFT',
  `due_date` date DEFAULT NULL,
  `issued_at` datetime DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `notification_type` enum('SYSTEM','PAYMENT','VERIFICATION_RESULT','CERTIFICATE_ISSUED','SECURITY_ALERT','INSTITUTION_APPROVAL','PAYMENT_REMINDER','COMPLIANCE_UPDATE') NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM',
  `is_read` tinyint(1) DEFAULT 0,
  `action_url` varchar(500) DEFAULT NULL,
  `related_entity_type` varchar(50) DEFAULT NULL,
  `related_entity_id` int(10) UNSIGNED DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `payer_user_id` int(10) UNSIGNED NOT NULL,
  `payer_institution_id` int(10) UNSIGNED DEFAULT NULL,
  `verification_request_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` enum('USD','ZWL','ZAR','GBP','EUR') DEFAULT 'USD',
  `payment_method_id` int(10) UNSIGNED NOT NULL,
  `provider_reference` varchar(255) DEFAULT NULL,
  `status` enum('PENDING','SUCCESS','FAILED','REFUNDED','CANCELLED') DEFAULT 'PENDING',
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` enum('MOBILE_MONEY','CARD','BANK_TRANSFER','WALLET','CASH') NOT NULL,
  `name` varchar(100) NOT NULL,
  `provider_name` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `programmes`
--

CREATE TABLE `programmes` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `institution_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO INSTITUTION TABLE',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'PROGRAMME CODE',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'PROGRAMME FULL NAME',
  `level` enum('Certificate','Diploma','Bachelor','Masters','PhD') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ACADEMIC LEVEL',
  `znqf_level` int(11) DEFAULT NULL COMMENT 'ZNQF QUALIFICATION LEVEL',
  `duration_years` int(11) DEFAULT NULL COMMENT 'PROGRAMME DURATION IN YEARS',
  `status` enum('ACTIVE','DISCONTINUED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'PROGRAMME STATUS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD CREATION TIME',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD LAST UPDATE TIME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `regulator_reviews`
--

CREATE TABLE `regulator_reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `institution_id` int(10) UNSIGNED NOT NULL,
  `reviewed_by_user_id` int(10) UNSIGNED NOT NULL,
  `review_type` enum('INSTITUTION_APPROVAL','PROGRAMME_APPROVAL','AUDIT_CERTIFICATES','COMPLIANCE_CHECK','RENEWAL_ASSESSMENT') NOT NULL,
  `result` enum('APPROVED','CONDITIONALLY_APPROVED','REJECTED','PENDING_REVIEW','REQUIRES_ACTION') NOT NULL,
  `review_date` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `code` enum('STUDENT','INSTITUTION_ADMIN','ISSUER','EMPLOYER','VERIFIER','REGULATOR','SUPER_ADMIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ROLE CODE IDENTIFIER',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ROLE DISPLAY NAME',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ROLE DESCRIPTION'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO USERS TABLE',
  `student_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'UNIQUE STUDENT IDENTIFIER',
  `date_of_birth` date DEFAULT NULL COMMENT 'STUDENT''S DATE OF BIRTH',
  `gender` enum('Male','Female','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'STUDENT''S GENDER',
  `primary_institution_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO MAIN INSTITUTION',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD''S CREATION TIME',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'LAST UPDATE TIME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_programme_enrolments`
--

CREATE TABLE `student_programme_enrolments` (
  `ID` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `student_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO STUDENTS TABLE',
  `programme_id` int(10) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO PROGRAMMES TABLE',
  `enrolment_year` year(4) NOT NULL COMMENT 'YEAR STUDENT ENROLLED',
  `status` enum('ENROLLED','COMPLETED','WITHDRAWN','SUSPENDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ENROLMENT STATUS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD CREATION TIME',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD LAST UPDATE TIME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_number` varchar(50) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `institution_id` int(10) UNSIGNED DEFAULT NULL,
  `category` enum('TECHNICAL_ISSUE','CERTIFICATE_ISSUE','VERIFICATION_PROBLEM','PAYMENT_ISSUE','ACCOUNT_ISSUE','COMPLAINT','FEATURE_REQUEST','GENERAL_INQUIRY') NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM',
  `subject` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` enum('OPEN','IN_PROGRESS','AWAITING_RESPONSE','RESOLVED','CLOSED','REOPENED') DEFAULT 'OPEN',
  `assigned_to_user_id` int(10) UNSIGNED DEFAULT NULL,
  `related_entity_type` varchar(50) DEFAULT NULL,
  `related_entity_id` int(10) UNSIGNED DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resolved_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'USER EMAIL ADDRESS',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'HASH PASSWORD',
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'USER FIRST NAME',
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'USER LAST NAME',
  `national_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'NATIONAL IDENTIFICTION',
  `phone_number` int(20) DEFAULT NULL COMMENT 'CONTACT PHONE NUMBER',
  `status` enum('Active','Pending','Suspended','Deactivated') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending' COMMENT 'USER ACCOUNT STATUS',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT 'LAST LOGIN TIMESTAMP',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'RECORD CREATION TIME',
  `updated_at` timestamp NULL DEFAULT current_timestamp() COMMENT 'LAST UPDATE TIME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `id` int(11) UNSIGNED NOT NULL COMMENT 'PRIMARY KEY IDENTIFIER',
  `user_id` int(11) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO USERS TABLE',
  `role_id` int(11) UNSIGNED NOT NULL COMMENT 'FOREIGN KEY TO ROLES TABLE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'CURRENT_TIMESTAMP'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `verification_requests`
--

CREATE TABLE `verification_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_reference` varchar(100) NOT NULL,
  `verifier_id` int(10) UNSIGNED NOT NULL,
  `certificate_id` int(10) UNSIGNED DEFAULT NULL,
  `student_id` int(10) UNSIGNED DEFAULT NULL,
  `input_payload_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`input_payload_json`)),
  `verification_channel` enum('QR_SCAN','MANUAL_FORM','API') NOT NULL,
  `status` enum('PENDING','IN_PROGRESS','COMPLETED','FAILED','REJECTED') DEFAULT 'PENDING',
  `requires_manual_review` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Table structure for table `verification_results`
--

CREATE TABLE `verification_results` (
  `id` int(10) UNSIGNED NOT NULL,
  `verification_request_id` int(10) UNSIGNED NOT NULL,
  `is_valid` tinyint(1) NOT NULL,
  `reason_code` enum('MATCHED_ON_CHAIN','NO_RECORD','MISMATCHED_DATA','REVOKED_CERTIFICATE','PENDING_VERIFICATION','EXPIRED_CERTIFICATE','ISSUER_NOT_VERIFIED') NOT NULL,
  `details` text DEFAULT NULL,
  `blockchain_verification_status` enum('MATCHED','NOT_MATCHED','NOT_AVAILABLE','PENDING_CONFIRMATION') DEFAULT 'NOT_AVAILABLE',
  `verified_by_user_id` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `verifiers`
--

CREATE TABLE `verifiers` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `organisation_name` varchar(255) DEFAULT NULL,
  `institution_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `znqf_levels`
--

CREATE TABLE `znqf_levels` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `api_clients`
--
ALTER TABLE `api_clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `api_key` (`api_key`),
  ADD UNIQUE KEY `secret_key` (`secret_key`),
  ADD KEY `institution_id` (`institution_id`),
  ADD KEY `status` (`status`),
  ADD KEY `last_used_at` (`last_used_at`),
  ADD KEY `expires_at` (`expires_at`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_active_clients` (`status`,`expires_at`);

--
-- Indexes for table `api_logs`
--
ALTER TABLE `api_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_client_id` (`api_client_id`),
  ADD KEY `endpoint` (`endpoint`),
  ADD KEY `http_method` (`http_method`),
  ADD KEY `request_ip` (`request_ip`),
  ADD KEY `response_status_code` (`response_status_code`),
  ADD KEY `processing_time_ms` (`processing_time_ms`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_client_endpoint` (`api_client_id`,`endpoint`),
  ADD KEY `idx_status_time` (`response_status_code`,`processing_time_ms`),
  ADD KEY `idx_timestamp_client` (`created_at`,`api_client_id`),
  ADD KEY `idx_performance` (`processing_time_ms`,`response_status_code`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `action` (`action`),
  ADD KEY `entity_type` (`entity_type`),
  ADD KEY `entity_id` (`entity_id`),
  ADD KEY `ip_address` (`ip_address`),
  ADD KEY `request_method` (`request_method`),
  ADD KEY `status_code` (`status_code`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_entity_composite` (`entity_type`,`entity_id`),
  ADD KEY `idx_user_action` (`user_id`,`action`),
  ADD KEY `idx_timestamp_entity` (`created_at`,`entity_type`);

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `certificate_number` (`certificate_number`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `institution_id` (`institution_id`),
  ADD KEY `programme_id` (`programme_id`);

--
-- Indexes for table `certificate_blockchain_records`
--
ALTER TABLE `certificate_blockchain_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `certificate_id` (`certificate_id`),
  ADD UNIQUE KEY `transaction_hash` (`transaction_hash`),
  ADD UNIQUE KEY `on_chain_hash` (`on_chain_hash`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `certificate_documents`
--
ALTER TABLE `certificate_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `certificate_id` (`certificate_id`);

--
-- Indexes for table `institutions`
--
ALTER TABLE `institutions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `institution_type_id` (`institution_type_id`);

--
-- Indexes for table `institution_types`
--
ALTER TABLE `institution_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQUE` (`code`);

--
-- Indexes for table `institution_users`
--
ALTER TABLE `institution_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `institutions_id INDEX` (`institution_id`),
  ADD KEY `user_id INDEX` (`user_id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `payer_institution_id` (`payer_institution_id`),
  ADD KEY `payer_user_id` (`payer_user_id`),
  ADD KEY `status` (`status`),
  ADD KEY `due_date` (`due_date`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `notification_type` (`notification_type`),
  ADD KEY `priority` (`priority`),
  ADD KEY `is_read` (`is_read`),
  ADD KEY `related_entity_type` (`related_entity_type`),
  ADD KEY `related_entity_id` (`related_entity_id`),
  ADD KEY `scheduled_at` (`scheduled_at`),
  ADD KEY `expires_at` (`expires_at`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `idx_user_unread` (`user_id`,`is_read`),
  ADD KEY `idx_entity_relation` (`related_entity_type`,`related_entity_id`),
  ADD KEY `idx_scheduled_delivery` (`scheduled_at`,`user_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `verification_request_id` (`verification_request_id`),
  ADD UNIQUE KEY `provider_reference` (`provider_reference`),
  ADD KEY `payer_user_id` (`payer_user_id`),
  ADD KEY `payer_institution_id` (`payer_institution_id`),
  ADD KEY `payment_method_id` (`payment_method_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `is_active` (`is_active`);

--
-- Indexes for table `programmes`
--
ALTER TABLE `programmes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `institution_id INDEX` (`institution_id`);

--
-- Indexes for table `regulator_reviews`
--
ALTER TABLE `regulator_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `institution_id` (`institution_id`),
  ADD KEY `reviewed_by_user_id` (`reviewed_by_user_id`),
  ADD KEY `review_type` (`review_type`),
  ADD KEY `result` (`result`),
  ADD KEY `review_date` (`review_date`),
  ADD KEY `valid_until` (`valid_until`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id INDEX` (`user_id`),
  ADD UNIQUE KEY `student_number` (`student_number`),
  ADD KEY `institution_id INDEX` (`primary_institution_id`);

--
-- Indexes for table `student_programme_enrolments`
--
ALTER TABLE `student_programme_enrolments`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `students_id INDEX` (`student_id`),
  ADD KEY `programmes_id INDEX` (`programme_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket_number` (`ticket_number`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `institution_id` (`institution_id`),
  ADD KEY `category` (`category`),
  ADD KEY `priority` (`priority`),
  ADD KEY `status` (`status`),
  ADD KEY `assigned_to_user_id` (`assigned_to_user_id`),
  ADD KEY `related_entity_type` (`related_entity_type`),
  ADD KEY `related_entity_id` (`related_entity_id`),
  ADD KEY `created_at` (`created_at`),
  ADD KEY `resolved_at` (`resolved_at`),
  ADD KEY `closed_at` (`closed_at`),
  ADD KEY `idx_agent_workload` (`assigned_to_user_id`,`status`),
  ADD KEY `idx_entity_relation` (`related_entity_type`,`related_entity_id`),
  ADD KEY `idx_ticket_status_priority` (`status`,`priority`,`created_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id_index` (`user_id`),
  ADD KEY `role_id_index` (`role_id`);

--
-- Indexes for table `verification_requests`
--
ALTER TABLE `verification_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_reference` (`request_reference`),
  ADD KEY `verifier_id` (`verifier_id`),
  ADD KEY `certificate_id` (`certificate_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `verification_channel` (`verification_channel`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `verification_results`
--
ALTER TABLE `verification_results`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `verification_request_id` (`verification_request_id`),
  ADD KEY `is_valid` (`is_valid`),
  ADD KEY `reason_code` (`reason_code`),
  ADD KEY `blockchain_verification_status` (`blockchain_verification_status`),
  ADD KEY `verified_by_user_id` (`verified_by_user_id`);

--
-- Indexes for table `verifiers`
--
ALTER TABLE `verifiers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `institution_id` (`institution_id`);

--
-- Indexes for table `znqf_levels`
--
ALTER TABLE `znqf_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `api_clients`
--
ALTER TABLE `api_clients`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `api_logs`
--
ALTER TABLE `api_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `certificate_blockchain_records`
--
ALTER TABLE `certificate_blockchain_records`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `certificate_documents`
--
ALTER TABLE `certificate_documents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `institutions`
--
ALTER TABLE `institutions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `institution_types`
--
ALTER TABLE `institution_types`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `institution_users`
--
ALTER TABLE `institution_users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `programmes`
--
ALTER TABLE `programmes`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `regulator_reviews`
--
ALTER TABLE `regulator_reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `student_programme_enrolments`
--
ALTER TABLE `student_programme_enrolments`
  MODIFY `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `user_roles`
--
ALTER TABLE `user_roles`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PRIMARY KEY IDENTIFIER';

--
-- AUTO_INCREMENT for table `verification_requests`
--
ALTER TABLE `verification_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `verification_results`
--
ALTER TABLE `verification_results`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `verifiers`
--
ALTER TABLE `verifiers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `znqf_levels`
--
ALTER TABLE `znqf_levels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `api_clients`
--
ALTER TABLE `api_clients`
  ADD CONSTRAINT `api_clients_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `api_clients_ibfk_2` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `api_logs`
--
ALTER TABLE `api_logs`
  ADD CONSTRAINT `api_logs_ibfk_1` FOREIGN KEY (`api_client_id`) REFERENCES `api_clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `api_logs_ibfk_2` FOREIGN KEY (`api_client_id`) REFERENCES `api_clients` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `audit_logs_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `certificates`
--
ALTER TABLE `certificates`
  ADD CONSTRAINT `certificates_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `certificates_ibfk_10` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `certificates_ibfk_11` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `certificates_ibfk_12` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  ADD CONSTRAINT `certificates_ibfk_2` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `certificates_ibfk_3` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  ADD CONSTRAINT `certificates_ibfk_4` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `certificates_ibfk_5` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `certificates_ibfk_6` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  ADD CONSTRAINT `certificates_ibfk_7` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `certificates_ibfk_8` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `certificates_ibfk_9` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`);

--
-- Constraints for table `certificate_blockchain_records`
--
ALTER TABLE `certificate_blockchain_records`
  ADD CONSTRAINT `certificate_blockchain_records_ibfk_1` FOREIGN KEY (`certificate_id`) REFERENCES `certificates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `certificate_documents`
--
ALTER TABLE `certificate_documents`
  ADD CONSTRAINT `certificate_documents_ibfk_1` FOREIGN KEY (`certificate_id`) REFERENCES `certificates` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `certificate_documents_ibfk_2` FOREIGN KEY (`certificate_id`) REFERENCES `certificates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `institutions`
--
ALTER TABLE `institutions`
  ADD CONSTRAINT `institutions_ibfk_1` FOREIGN KEY (`institution_type_id`) REFERENCES `institution_types` (`id`),
  ADD CONSTRAINT `institutions_ibfk_2` FOREIGN KEY (`institution_type_id`) REFERENCES `institution_types` (`id`),
  ADD CONSTRAINT `institutions_ibfk_3` FOREIGN KEY (`institution_type_id`) REFERENCES `institution_types` (`id`),
  ADD CONSTRAINT `institutions_ibfk_4` FOREIGN KEY (`institution_type_id`) REFERENCES `institution_types` (`id`);

--
-- Constraints for table `institution_users`
--
ALTER TABLE `institution_users`
  ADD CONSTRAINT `institution_users_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_3` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_5` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_7` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_users_ibfk_8` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`payer_institution_id`) REFERENCES `institutions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`payer_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `invoices_ibfk_3` FOREIGN KEY (`payer_institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `invoices_ibfk_4` FOREIGN KEY (`payer_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`payer_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`payer_institution_id`) REFERENCES `institutions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`verification_request_id`) REFERENCES `verification_requests` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `payments_ibfk_4` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`),
  ADD CONSTRAINT `payments_ibfk_5` FOREIGN KEY (`payer_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payments_ibfk_6` FOREIGN KEY (`payer_institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `payments_ibfk_7` FOREIGN KEY (`verification_request_id`) REFERENCES `verification_requests` (`id`),
  ADD CONSTRAINT `payments_ibfk_8` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`);

--
-- Constraints for table `programmes`
--
ALTER TABLE `programmes`
  ADD CONSTRAINT `programmes_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `programmes_ibfk_2` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `programmes_ibfk_3` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `programmes_ibfk_4` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`);

--
-- Constraints for table `regulator_reviews`
--
ALTER TABLE `regulator_reviews`
  ADD CONSTRAINT `regulator_reviews_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `regulator_reviews_ibfk_2` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `regulator_reviews_ibfk_3` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `regulator_reviews_ibfk_4` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `students_ibfk_2` FOREIGN KEY (`primary_institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `students_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `students_ibfk_4` FOREIGN KEY (`primary_institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `students_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `students_ibfk_6` FOREIGN KEY (`primary_institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `students_ibfk_7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `students_ibfk_8` FOREIGN KEY (`primary_institution_id`) REFERENCES `institutions` (`id`);

--
-- Constraints for table `student_programme_enrolments`
--
ALTER TABLE `student_programme_enrolments`
  ADD CONSTRAINT `student_programme_enrolments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_2` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_3` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_4` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_5` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_6` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_7` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_programme_enrolments_ibfk_8` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `support_tickets_ibfk_3` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `support_tickets_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_4` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_6` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_8` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `verification_requests`
--
ALTER TABLE `verification_requests`
  ADD CONSTRAINT `verification_requests_ibfk_1` FOREIGN KEY (`verifier_id`) REFERENCES `verifiers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `verification_requests_ibfk_2` FOREIGN KEY (`certificate_id`) REFERENCES `certificates` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `verification_requests_ibfk_3` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `verification_requests_ibfk_4` FOREIGN KEY (`verifier_id`) REFERENCES `verifiers` (`id`),
  ADD CONSTRAINT `verification_requests_ibfk_5` FOREIGN KEY (`certificate_id`) REFERENCES `certificates` (`id`),
  ADD CONSTRAINT `verification_requests_ibfk_6` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`);

--
-- Constraints for table `verification_results`
--
ALTER TABLE `verification_results`
  ADD CONSTRAINT `verification_results_ibfk_1` FOREIGN KEY (`verification_request_id`) REFERENCES `verification_requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `verification_results_ibfk_2` FOREIGN KEY (`verified_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `verification_results_ibfk_3` FOREIGN KEY (`verification_request_id`) REFERENCES `verification_requests` (`id`),
  ADD CONSTRAINT `verification_results_ibfk_4` FOREIGN KEY (`verified_by_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `verifiers`
--
ALTER TABLE `verifiers`
  ADD CONSTRAINT `verifiers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `verifiers_ibfk_2` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
