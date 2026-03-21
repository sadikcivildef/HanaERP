CREATE TYPE "public"."address_type" AS ENUM('present', 'permanent', 'mailing', 'emergency');--> statement-breakpoint
CREATE TYPE "public"."application_status" AS ENUM('draft', 'submitted', 'reviewing', 'shortlisted', 'interviewed', 'offered', 'hired', 'rejected');--> statement-breakpoint
CREATE TYPE "public"."asset_status" AS ENUM('available', 'assigned', 'maintenance', 'damaged', 'retired');--> statement-breakpoint
CREATE TYPE "public"."attendance_source" AS ENUM('biometric', 'manual', 'api', 'mobile', 'web');--> statement-breakpoint
CREATE TYPE "public"."attendance_status" AS ENUM('present', 'absent', 'late', 'half_day', 'leave');--> statement-breakpoint
CREATE TYPE "public"."audit_action" AS ENUM('INSERT', 'UPDATE', 'DELETE', 'SOFT_DELETE', 'RESTORE');--> statement-breakpoint
CREATE TYPE "public"."blood_group" AS ENUM('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-');--> statement-breakpoint
CREATE TYPE "public"."clearance_status" AS ENUM('pending', 'cleared', 'rejected');--> statement-breakpoint
CREATE TYPE "public"."contract_type" AS ENUM('permanent', 'contractual', 'intern', 'probation', 'consultant');--> statement-breakpoint
CREATE TYPE "public"."document_type" AS ENUM('nid', 'passport', 'cv', 'certificate', 'photo', 'contract', 'offer_letter', 'other');--> statement-breakpoint
CREATE TYPE "public"."gender" AS ENUM('male', 'female', 'other');--> statement-breakpoint
CREATE TYPE "public"."interview_status" AS ENUM('scheduled', 'completed', 'cancelled', 'no_show', 'rescheduled');--> statement-breakpoint
CREATE TYPE "public"."interview_type" AS ENUM('phone', 'video', 'onsite', 'technical', 'hr');--> statement-breakpoint
CREATE TYPE "public"."leave_status" AS ENUM('pending', 'approved', 'rejected', 'cancelled');--> statement-breakpoint
CREATE TYPE "public"."leave_type_enum" AS ENUM('annual', 'sick', 'maternity', 'paternity', 'casual', 'unpaid', 'bereavement', 'study');--> statement-breakpoint
CREATE TYPE "public"."marital_status" AS ENUM('single', 'married', 'divorced', 'widowed');--> statement-breakpoint
CREATE TYPE "public"."payroll_status" AS ENUM('pending', 'processing', 'paid', 'failed', 'cancelled');--> statement-breakpoint
CREATE TYPE "public"."priority_level" AS ENUM('low', 'normal', 'high', 'urgent');--> statement-breakpoint
CREATE TYPE "public"."resignation_status" AS ENUM('pending', 'approved', 'rejected', 'cancelled', 'withdrawn');--> statement-breakpoint
CREATE TYPE "public"."review_status" AS ENUM('pending', 'in_progress', 'completed', 'cancelled');--> statement-breakpoint
CREATE TYPE "public"."training_status" AS ENUM('scheduled', 'ongoing', 'completed', 'cancelled');--> statement-breakpoint
CREATE TABLE "account" (
	"id" text PRIMARY KEY NOT NULL,
	"account_id" text NOT NULL,
	"provider_id" text NOT NULL,
	"user_id" text NOT NULL,
	"access_token" text,
	"refresh_token" text,
	"id_token" text,
	"access_token_expires_at" timestamp,
	"refresh_token_expires_at" timestamp,
	"scope" text,
	"password" text,
	"created_at" timestamp NOT NULL,
	"updated_at" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "address" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"type" "address_type" DEFAULT 'present' NOT NULL,
	"street" text NOT NULL,
	"city" text NOT NULL,
	"police_station" text,
	"post_office" text,
	"state" text,
	"postal_code" text,
	"country" text DEFAULT 'Bangladesh' NOT NULL,
	"is_primary" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "allowance_type" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"description" text,
	"is_fixed" boolean DEFAULT true,
	"is_taxable" boolean DEFAULT true,
	"calculation_type" text,
	"calculation_value" numeric,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "allowance_company_code" UNIQUE("company_id","code")
);
--> statement-breakpoint
CREATE TABLE "applicant" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"job_post_id" integer,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"phone" text,
	"resume_path" text,
	"cover_letter" text,
	"expected_salary" numeric(12, 2),
	"current_company" text,
	"experience_years" integer,
	"status" "application_status" DEFAULT 'draft',
	"applied_at" timestamp DEFAULT now(),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "asset" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"asset_code" text NOT NULL,
	"name" text NOT NULL,
	"type" text NOT NULL,
	"model" text,
	"serial_no" text,
	"purchase_date" date,
	"purchase_price" numeric(12, 2),
	"warranty_expiry" date,
	"status" "asset_status" DEFAULT 'available',
	"assigned_to" integer,
	"assigned_at" timestamp,
	"notes" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "asset_company_code" UNIQUE("company_id","asset_code")
);
--> statement-breakpoint
CREATE TABLE "attendance" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"date" date NOT NULL,
	"shift_id" integer,
	"status" "attendance_status" NOT NULL,
	"check_in" timestamp,
	"check_out" timestamp,
	"check_in_location" json,
	"check_out_location" json,
	"check_in_device" text,
	"check_out_device" text,
	"source" "attendance_source" DEFAULT 'manual',
	"working_hours" integer,
	"overtime_hours" integer,
	"late_minutes" integer DEFAULT 0,
	"early_exit_minutes" integer DEFAULT 0,
	"remarks" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "attendance_emp_date_unique" UNIQUE("employee_id","date")
);
--> statement-breakpoint
CREATE TABLE "audit_log" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer,
	"table_name" text NOT NULL,
	"record_id" integer NOT NULL,
	"action" "audit_action" NOT NULL,
	"old_data" json,
	"new_data" json,
	"changed_by" integer,
	"ip_address" text,
	"user_agent" text,
	"changed_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "bank_info" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"bank_name" text NOT NULL,
	"account_no" text NOT NULL,
	"account_name" text,
	"branch_name" text,
	"routing_no" text,
	"swift_code" text,
	"is_primary" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "bank_account_unique" UNIQUE("employee_id","account_no")
);
--> statement-breakpoint
CREATE TABLE "company" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"registration_no" text,
	"tax_id" text,
	"email" text,
	"phone" text,
	"address" text,
	"city" text,
	"state" text,
	"country" text DEFAULT 'Bangladesh',
	"postal_code" text,
	"website" text,
	"logo" text,
	"fiscal_year_start" date,
	"fiscal_year_end" date,
	"timezone" text DEFAULT 'Asia/Dhaka',
	"is_active" boolean DEFAULT true,
	"deleted_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "company_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "contract" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"contract_type" "contract_type" NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date,
	"probation_period" integer,
	"notice_period" integer,
	"salary" integer,
	"document_path" text,
	"is_active" boolean DEFAULT true,
	"signed_by" integer,
	"signed_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "deduction_type" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"description" text,
	"is_mandatory" boolean DEFAULT false,
	"is_taxable" boolean DEFAULT false,
	"calculation_type" text,
	"calculation_value" numeric,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "deduction_company_code" UNIQUE("company_id","code")
);
--> statement-breakpoint
CREATE TABLE "department" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"description" text,
	"location" text,
	"manager_id" integer,
	"parent_department_id" integer,
	"is_active" boolean DEFAULT true NOT NULL,
	"deleted_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "dept_company_code" UNIQUE("company_id","code")
);
--> statement-breakpoint
CREATE TABLE "document" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"document_type" "document_type" NOT NULL,
	"document_path" text NOT NULL,
	"file_name" text NOT NULL,
	"file_size" integer,
	"mime_type" text,
	"description" text,
	"uploaded_by" integer,
	"is_verified" boolean DEFAULT false,
	"verified_by" integer,
	"verified_at" timestamp,
	"expires_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "education" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"institution" text NOT NULL,
	"degree" text NOT NULL,
	"field_of_study" text,
	"result" text,
	"start_date" date NOT NULL,
	"end_date" date,
	"is_highest" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "emergency_contact" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"name" text NOT NULL,
	"relationship" text NOT NULL,
	"contact_no" text NOT NULL,
	"alternate_contact_no" text,
	"email" text,
	"address" text,
	"priority" integer DEFAULT 1,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "employee" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"employee_code" text NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"personal_email" text,
	"id_no" text NOT NULL,
	"passport_no" text,
	"position_id" integer NOT NULL,
	"department_id" integer,
	"reporting_manager_id" integer,
	"joining_date" date NOT NULL,
	"confirmation_date" date,
	"date_of_birth" date NOT NULL,
	"gender" "gender",
	"religion" text,
	"nationality" text NOT NULL,
	"contact_no" text NOT NULL,
	"alternate_contact_no" text,
	"blood_group" "blood_group",
	"marital_status" "marital_status",
	"father_name" text,
	"mother_name" text,
	"spouse_name" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"deleted_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "employee_company_code" UNIQUE("company_id","employee_code"),
	CONSTRAINT "employee_company_email" UNIQUE("company_id","email"),
	CONSTRAINT "employee_company_id_no" UNIQUE("company_id","id_no")
);
--> statement-breakpoint
CREATE TABLE "employee_allowance" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"allowance_type_id" integer NOT NULL,
	"amount" numeric(12, 2) NOT NULL,
	"effective_from" date NOT NULL,
	"effective_to" date,
	"is_recurring" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "employee_deduction" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"deduction_type_id" integer NOT NULL,
	"amount" numeric(12, 2) NOT NULL,
	"effective_from" date NOT NULL,
	"effective_to" date,
	"is_recurring" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "employee_kpi" (
	"id" serial PRIMARY KEY NOT NULL,
	"review_id" integer NOT NULL,
	"kpi_id" integer NOT NULL,
	"score" numeric(10, 2),
	"achieved_value" text,
	"comments" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "review_kpi_unique" UNIQUE("review_id","kpi_id")
);
--> statement-breakpoint
CREATE TABLE "employee_shift" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"shift_id" integer NOT NULL,
	"date" date NOT NULL,
	"assigned_by" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "employee_shift_date" UNIQUE("employee_id","date")
);
--> statement-breakpoint
CREATE TABLE "exit_clearance" (
	"id" serial PRIMARY KEY NOT NULL,
	"resignation_id" integer NOT NULL,
	"department" text NOT NULL,
	"cleared_by" integer,
	"cleared_at" timestamp,
	"remarks" text,
	"is_cleared" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "experience" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"company" text NOT NULL,
	"position" text NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date,
	"is_current" boolean DEFAULT false,
	"description" text,
	"responsibilities" json,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "interview" (
	"id" serial PRIMARY KEY NOT NULL,
	"applicant_id" integer NOT NULL,
	"interviewer_id" integer,
	"interview_type" "interview_type" NOT NULL,
	"scheduled_at" timestamp NOT NULL,
	"duration" integer,
	"location" text,
	"meeting_link" text,
	"feedback" text,
	"rating" integer,
	"status" text DEFAULT 'scheduled',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "job_post" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"title" text NOT NULL,
	"department_id" integer,
	"position_id" integer,
	"description" text,
	"requirements" json,
	"responsibilities" json,
	"location" text,
	"employment_type" text,
	"experience_required" text,
	"salary_range" json,
	"posted_by" integer,
	"posted_at" timestamp DEFAULT now(),
	"expires_at" timestamp,
	"is_active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "kpi" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"category" text,
	"unit" text,
	"target" json,
	"weight" integer DEFAULT 100,
	"is_active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "leave" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"employee_id" integer NOT NULL,
	"leave_type_id" integer NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"days" numeric(4, 1) NOT NULL,
	"reason" text,
	"status" "leave_status" DEFAULT 'pending' NOT NULL,
	"approved_by_id" integer,
	"approved_at" timestamp,
	"rejection_reason" text,
	"attachments" json,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "leave_balance" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"leave_type_id" integer NOT NULL,
	"year" integer NOT NULL,
	"total_days" numeric(5, 1) NOT NULL,
	"used_days" numeric(5, 1) DEFAULT '0' NOT NULL,
	"pending_days" numeric(5, 1) DEFAULT '0' NOT NULL,
	"carried_over_days" numeric(5, 1) DEFAULT '0',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "leave_balance_emp_year_type" UNIQUE("employee_id","year","leave_type_id")
);
--> statement-breakpoint
CREATE TABLE "leave_type" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" "leave_type_enum" NOT NULL,
	"max_days_per_year" integer,
	"is_paid" boolean DEFAULT true,
	"requires_approval" boolean DEFAULT true,
	"carry_forward" boolean DEFAULT false,
	"max_carry_forward_days" integer,
	"applicable_gender" "gender",
	"min_service_months" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "leave_type_company_name" UNIQUE("company_id","name")
);
--> statement-breakpoint
CREATE TABLE "notification" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"employee_id" integer NOT NULL,
	"title" text NOT NULL,
	"message" text NOT NULL,
	"type" text NOT NULL,
	"priority" text DEFAULT 'normal',
	"is_read" boolean DEFAULT false,
	"read_at" timestamp,
	"link" text,
	"metadata" json,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "payroll" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"employee_id" integer NOT NULL,
	"month" integer NOT NULL,
	"year" integer NOT NULL,
	"basic_salary" numeric(12, 2) NOT NULL,
	"total_allowances" numeric(12, 2) DEFAULT '0' NOT NULL,
	"total_deductions" numeric(12, 2) DEFAULT '0' NOT NULL,
	"net_salary" numeric(12, 2) NOT NULL,
	"bonus" numeric(12, 2) DEFAULT '0',
	"overtime_pay" numeric(12, 2) DEFAULT '0',
	"tax_amount" numeric(12, 2) DEFAULT '0',
	"payment_date" date,
	"payment_method" text,
	"transaction_id" text,
	"status" "payroll_status" DEFAULT 'pending' NOT NULL,
	"processed_by" integer,
	"processed_at" timestamp,
	"remarks" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "payroll_emp_month_year" UNIQUE("employee_id","month","year")
);
--> statement-breakpoint
CREATE TABLE "payroll_item" (
	"id" serial PRIMARY KEY NOT NULL,
	"payroll_id" integer NOT NULL,
	"type" text NOT NULL,
	"reference_id" integer,
	"name" text NOT NULL,
	"amount" numeric(12, 2) NOT NULL,
	"is_taxable" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "performance_review" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"employee_id" integer NOT NULL,
	"reviewer_id" integer NOT NULL,
	"review_period" text NOT NULL,
	"review_date" date NOT NULL,
	"overall_rating" numeric(3, 1),
	"strengths" text,
	"areas_of_improvement" text,
	"goals" json,
	"comments" text,
	"status" text DEFAULT 'pending',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "permission" (
	"id" serial PRIMARY KEY NOT NULL,
	"resource" text NOT NULL,
	"action" text NOT NULL,
	"description" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "permission_resource_action" UNIQUE("resource","action")
);
--> statement-breakpoint
CREATE TABLE "position" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"department_id" integer NOT NULL,
	"title" text NOT NULL,
	"code" text NOT NULL,
	"level" text,
	"min_salary" integer,
	"max_salary" integer,
	"responsibilities" json,
	"requirements" json,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "position_company_code" UNIQUE("company_id","code")
);
--> statement-breakpoint
CREATE TABLE "position_history" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"position_id" integer NOT NULL,
	"department_id" integer,
	"changed_at" timestamp DEFAULT now() NOT NULL,
	"changed_by_id" integer,
	"reason" text,
	"effective_date" date NOT NULL
);
--> statement-breakpoint
CREATE TABLE "resignation" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"resignation_date" date NOT NULL,
	"last_working_day" date NOT NULL,
	"reason" text,
	"status" "resignation_status" DEFAULT 'pending',
	"approved_by_id" integer,
	"approved_at" timestamp,
	"counter_offer" text,
	"exit_interview_date" date,
	"exit_interview_feedback" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "role" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"is_system" boolean DEFAULT false,
	"level" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "role_company_name" UNIQUE("company_id","name")
);
--> statement-breakpoint
CREATE TABLE "role_permission" (
	"id" serial PRIMARY KEY NOT NULL,
	"role_id" integer NOT NULL,
	"permission_id" integer NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "role_permission_unique" UNIQUE("role_id","permission_id")
);
--> statement-breakpoint
CREATE TABLE "salary_history" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"old_salary" numeric(12, 2),
	"new_salary" numeric(12, 2) NOT NULL,
	"effective_from" date NOT NULL,
	"changed_at" timestamp DEFAULT now() NOT NULL,
	"changed_by_id" integer,
	"reason" text,
	"approval_status" text DEFAULT 'approved'
);
--> statement-breakpoint
CREATE TABLE "salary_structure" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"basic_salary" numeric(12, 2) NOT NULL,
	"effective_from" date NOT NULL,
	"effective_to" date,
	"is_current" boolean DEFAULT false,
	"approved_by_id" integer,
	"approved_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "session" (
	"id" text PRIMARY KEY NOT NULL,
	"expires_at" timestamp NOT NULL,
	"token" text NOT NULL,
	"created_at" timestamp NOT NULL,
	"updated_at" timestamp NOT NULL,
	"ip_address" text,
	"user_agent" text,
	"user_id" text NOT NULL,
	CONSTRAINT "session_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "shift" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"name" text NOT NULL,
	"code" text NOT NULL,
	"start_time" text NOT NULL,
	"end_time" text NOT NULL,
	"grace_period" integer,
	"break_time" integer,
	"working_hours" integer,
	"is_night_shift" boolean DEFAULT false,
	"is_active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "shift_company_code" UNIQUE("company_id","code")
);
--> statement-breakpoint
CREATE TABLE "task" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"priority" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "training" (
	"id" serial PRIMARY KEY NOT NULL,
	"company_id" integer NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"type" text,
	"start_date" date,
	"end_date" date,
	"location" text,
	"trainer" text,
	"max_participants" integer,
	"cost" numeric(12, 2),
	"status" "training_status" DEFAULT 'scheduled',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "training_participant" (
	"id" serial PRIMARY KEY NOT NULL,
	"training_id" integer NOT NULL,
	"employee_id" integer NOT NULL,
	"completion_status" boolean DEFAULT false,
	"completion_date" date,
	"feedback" text,
	"rating" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "training_participant_unique" UNIQUE("training_id","employee_id")
);
--> statement-breakpoint
CREATE TABLE "user" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"email_verified" boolean DEFAULT false NOT NULL,
	"image" text,
	"created_at" timestamp NOT NULL,
	"updated_at" timestamp NOT NULL,
	CONSTRAINT "user_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "user_role" (
	"id" serial PRIMARY KEY NOT NULL,
	"employee_id" integer NOT NULL,
	"role_id" integer NOT NULL,
	"assigned_by" integer,
	"assigned_at" timestamp DEFAULT now() NOT NULL,
	"is_active" boolean DEFAULT true,
	CONSTRAINT "user_role_unique" UNIQUE("employee_id","role_id")
);
--> statement-breakpoint
CREATE TABLE "verification" (
	"id" text PRIMARY KEY NOT NULL,
	"identifier" text NOT NULL,
	"value" text NOT NULL,
	"expires_at" timestamp NOT NULL,
	"created_at" timestamp NOT NULL,
	"updated_at" timestamp NOT NULL
);
--> statement-breakpoint
ALTER TABLE "account" ADD CONSTRAINT "account_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "address" ADD CONSTRAINT "address_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "allowance_type" ADD CONSTRAINT "allowance_type_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "applicant" ADD CONSTRAINT "applicant_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "applicant" ADD CONSTRAINT "applicant_job_post_id_job_post_id_fk" FOREIGN KEY ("job_post_id") REFERENCES "public"."job_post"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "asset" ADD CONSTRAINT "asset_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "asset" ADD CONSTRAINT "asset_assigned_to_employee_id_fk" FOREIGN KEY ("assigned_to") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_shift_id_shift_id_fk" FOREIGN KEY ("shift_id") REFERENCES "public"."shift"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_changed_by_employee_id_fk" FOREIGN KEY ("changed_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bank_info" ADD CONSTRAINT "bank_info_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contract" ADD CONSTRAINT "contract_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contract" ADD CONSTRAINT "contract_signed_by_employee_id_fk" FOREIGN KEY ("signed_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "deduction_type" ADD CONSTRAINT "deduction_type_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "department" ADD CONSTRAINT "department_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "document" ADD CONSTRAINT "document_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "document" ADD CONSTRAINT "document_uploaded_by_employee_id_fk" FOREIGN KEY ("uploaded_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "document" ADD CONSTRAINT "document_verified_by_employee_id_fk" FOREIGN KEY ("verified_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "education" ADD CONSTRAINT "education_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "emergency_contact" ADD CONSTRAINT "emergency_contact_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee" ADD CONSTRAINT "employee_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee" ADD CONSTRAINT "employee_position_id_position_id_fk" FOREIGN KEY ("position_id") REFERENCES "public"."position"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee" ADD CONSTRAINT "employee_department_id_department_id_fk" FOREIGN KEY ("department_id") REFERENCES "public"."department"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_allowance" ADD CONSTRAINT "employee_allowance_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_allowance" ADD CONSTRAINT "employee_allowance_allowance_type_id_allowance_type_id_fk" FOREIGN KEY ("allowance_type_id") REFERENCES "public"."allowance_type"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_deduction" ADD CONSTRAINT "employee_deduction_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_deduction" ADD CONSTRAINT "employee_deduction_deduction_type_id_deduction_type_id_fk" FOREIGN KEY ("deduction_type_id") REFERENCES "public"."deduction_type"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_kpi" ADD CONSTRAINT "employee_kpi_review_id_performance_review_id_fk" FOREIGN KEY ("review_id") REFERENCES "public"."performance_review"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_kpi" ADD CONSTRAINT "employee_kpi_kpi_id_kpi_id_fk" FOREIGN KEY ("kpi_id") REFERENCES "public"."kpi"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_shift" ADD CONSTRAINT "employee_shift_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_shift" ADD CONSTRAINT "employee_shift_shift_id_shift_id_fk" FOREIGN KEY ("shift_id") REFERENCES "public"."shift"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "employee_shift" ADD CONSTRAINT "employee_shift_assigned_by_employee_id_fk" FOREIGN KEY ("assigned_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "exit_clearance" ADD CONSTRAINT "exit_clearance_resignation_id_resignation_id_fk" FOREIGN KEY ("resignation_id") REFERENCES "public"."resignation"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "exit_clearance" ADD CONSTRAINT "exit_clearance_cleared_by_employee_id_fk" FOREIGN KEY ("cleared_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "experience" ADD CONSTRAINT "experience_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "interview" ADD CONSTRAINT "interview_applicant_id_applicant_id_fk" FOREIGN KEY ("applicant_id") REFERENCES "public"."applicant"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "interview" ADD CONSTRAINT "interview_interviewer_id_employee_id_fk" FOREIGN KEY ("interviewer_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "job_post" ADD CONSTRAINT "job_post_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "job_post" ADD CONSTRAINT "job_post_department_id_department_id_fk" FOREIGN KEY ("department_id") REFERENCES "public"."department"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "job_post" ADD CONSTRAINT "job_post_position_id_position_id_fk" FOREIGN KEY ("position_id") REFERENCES "public"."position"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "job_post" ADD CONSTRAINT "job_post_posted_by_employee_id_fk" FOREIGN KEY ("posted_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kpi" ADD CONSTRAINT "kpi_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave" ADD CONSTRAINT "leave_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave" ADD CONSTRAINT "leave_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave" ADD CONSTRAINT "leave_leave_type_id_leave_type_id_fk" FOREIGN KEY ("leave_type_id") REFERENCES "public"."leave_type"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave" ADD CONSTRAINT "leave_approved_by_id_employee_id_fk" FOREIGN KEY ("approved_by_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave_balance" ADD CONSTRAINT "leave_balance_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave_balance" ADD CONSTRAINT "leave_balance_leave_type_id_leave_type_id_fk" FOREIGN KEY ("leave_type_id") REFERENCES "public"."leave_type"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "leave_type" ADD CONSTRAINT "leave_type_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification" ADD CONSTRAINT "notification_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification" ADD CONSTRAINT "notification_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payroll" ADD CONSTRAINT "payroll_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payroll" ADD CONSTRAINT "payroll_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payroll" ADD CONSTRAINT "payroll_processed_by_employee_id_fk" FOREIGN KEY ("processed_by") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "payroll_item" ADD CONSTRAINT "payroll_item_payroll_id_payroll_id_fk" FOREIGN KEY ("payroll_id") REFERENCES "public"."payroll"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "performance_review" ADD CONSTRAINT "performance_review_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "performance_review" ADD CONSTRAINT "performance_review_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "performance_review" ADD CONSTRAINT "performance_review_reviewer_id_employee_id_fk" FOREIGN KEY ("reviewer_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "position" ADD CONSTRAINT "position_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "position" ADD CONSTRAINT "position_department_id_department_id_fk" FOREIGN KEY ("department_id") REFERENCES "public"."department"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "position_history" ADD CONSTRAINT "position_history_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "position_history" ADD CONSTRAINT "position_history_changed_by_id_employee_id_fk" FOREIGN KEY ("changed_by_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resignation" ADD CONSTRAINT "resignation_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "resignation" ADD CONSTRAINT "resignation_approved_by_id_employee_id_fk" FOREIGN KEY ("approved_by_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "role" ADD CONSTRAINT "role_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_role_id_role_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."role"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_permission_id_permission_id_fk" FOREIGN KEY ("permission_id") REFERENCES "public"."permission"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "salary_history" ADD CONSTRAINT "salary_history_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "salary_history" ADD CONSTRAINT "salary_history_changed_by_id_employee_id_fk" FOREIGN KEY ("changed_by_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "salary_structure" ADD CONSTRAINT "salary_structure_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "salary_structure" ADD CONSTRAINT "salary_structure_approved_by_id_employee_id_fk" FOREIGN KEY ("approved_by_id") REFERENCES "public"."employee"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "session" ADD CONSTRAINT "session_user_id_user_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "shift" ADD CONSTRAINT "shift_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "training" ADD CONSTRAINT "training_company_id_company_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."company"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "training_participant" ADD CONSTRAINT "training_participant_training_id_training_id_fk" FOREIGN KEY ("training_id") REFERENCES "public"."training"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "training_participant" ADD CONSTRAINT "training_participant_employee_id_employee_id_fk" FOREIGN KEY ("employee_id") REFERENCES "public"."employee"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_role_id_role_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."role"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "account_userId_idx" ON "account" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "address_employee_idx" ON "address" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "address_type_idx" ON "address" USING btree ("type");--> statement-breakpoint
CREATE INDEX "allowance_company_idx" ON "allowance_type" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "applicant_job_idx" ON "applicant" USING btree ("job_post_id");--> statement-breakpoint
CREATE INDEX "applicant_email_idx" ON "applicant" USING btree ("email");--> statement-breakpoint
CREATE INDEX "applicant_status_idx" ON "applicant" USING btree ("status");--> statement-breakpoint
CREATE INDEX "applicant_company_idx" ON "applicant" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "asset_company_idx" ON "asset" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "asset_assigned_idx" ON "asset" USING btree ("assigned_to");--> statement-breakpoint
CREATE INDEX "asset_status_idx" ON "asset" USING btree ("status");--> statement-breakpoint
CREATE INDEX "attendance_emp_date_idx" ON "attendance" USING btree ("employee_id","date");--> statement-breakpoint
CREATE INDEX "attendance_status_idx" ON "attendance" USING btree ("status");--> statement-breakpoint
CREATE INDEX "attendance_date_idx" ON "attendance" USING btree ("date");--> statement-breakpoint
CREATE INDEX "audit_table_record_idx" ON "audit_log" USING btree ("table_name","record_id");--> statement-breakpoint
CREATE INDEX "audit_changed_by_idx" ON "audit_log" USING btree ("changed_by");--> statement-breakpoint
CREATE INDEX "audit_changed_at_idx" ON "audit_log" USING btree ("changed_at");--> statement-breakpoint
CREATE INDEX "audit_company_idx" ON "audit_log" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "bank_employee_idx" ON "bank_info" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "company_name_idx" ON "company" USING btree ("name");--> statement-breakpoint
CREATE INDEX "company_code_idx" ON "company" USING btree ("code");--> statement-breakpoint
CREATE INDEX "company_is_active_idx" ON "company" USING btree ("is_active");--> statement-breakpoint
CREATE INDEX "contract_employee_idx" ON "contract" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "contract_dates_idx" ON "contract" USING btree ("start_date","end_date");--> statement-breakpoint
CREATE INDEX "deduction_company_idx" ON "deduction_type" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "dept_name_idx" ON "department" USING btree ("name");--> statement-breakpoint
CREATE INDEX "dept_company_idx" ON "department" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "dept_manager_idx" ON "department" USING btree ("manager_id");--> statement-breakpoint
CREATE INDEX "dept_parent_idx" ON "department" USING btree ("parent_department_id");--> statement-breakpoint
CREATE INDEX "document_employee_idx" ON "document" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "document_type_idx" ON "document" USING btree ("document_type");--> statement-breakpoint
CREATE INDEX "education_employee_idx" ON "education" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "education_degree_idx" ON "education" USING btree ("degree");--> statement-breakpoint
CREATE INDEX "emergency_employee_idx" ON "emergency_contact" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "employee_email_idx" ON "employee" USING btree ("email");--> statement-breakpoint
CREATE INDEX "employee_code_idx" ON "employee" USING btree ("employee_code");--> statement-breakpoint
CREATE INDEX "employee_position_idx" ON "employee" USING btree ("position_id");--> statement-breakpoint
CREATE INDEX "employee_department_idx" ON "employee" USING btree ("department_id");--> statement-breakpoint
CREATE INDEX "employee_manager_idx" ON "employee" USING btree ("reporting_manager_id");--> statement-breakpoint
CREATE INDEX "employee_company_idx" ON "employee" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "emp_allowance_employee_idx" ON "employee_allowance" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "emp_allowance_effective_idx" ON "employee_allowance" USING btree ("effective_from");--> statement-breakpoint
CREATE INDEX "emp_deduction_employee_idx" ON "employee_deduction" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "emp_deduction_effective_idx" ON "employee_deduction" USING btree ("effective_from");--> statement-breakpoint
CREATE INDEX "emp_kpi_review_idx" ON "employee_kpi" USING btree ("review_id");--> statement-breakpoint
CREATE INDEX "emp_shift_employee_idx" ON "employee_shift" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "emp_shift_date_idx" ON "employee_shift" USING btree ("date");--> statement-breakpoint
CREATE INDEX "exit_clearance_resignation_idx" ON "exit_clearance" USING btree ("resignation_id");--> statement-breakpoint
CREATE INDEX "exit_clearance_department_idx" ON "exit_clearance" USING btree ("department");--> statement-breakpoint
CREATE INDEX "experience_employee_idx" ON "experience" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "experience_company_idx" ON "experience" USING btree ("company");--> statement-breakpoint
CREATE INDEX "interview_applicant_idx" ON "interview" USING btree ("applicant_id");--> statement-breakpoint
CREATE INDEX "interview_interviewer_idx" ON "interview" USING btree ("interviewer_id");--> statement-breakpoint
CREATE INDEX "interview_scheduled_idx" ON "interview" USING btree ("scheduled_at");--> statement-breakpoint
CREATE INDEX "job_post_company_idx" ON "job_post" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "job_post_title_idx" ON "job_post" USING btree ("title");--> statement-breakpoint
CREATE INDEX "job_post_status_idx" ON "job_post" USING btree ("is_active");--> statement-breakpoint
CREATE INDEX "kpi_company_idx" ON "kpi" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "kpi_category_idx" ON "kpi" USING btree ("category");--> statement-breakpoint
CREATE INDEX "leave_employee_idx" ON "leave" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "leave_type_idx" ON "leave" USING btree ("leave_type_id");--> statement-breakpoint
CREATE INDEX "leave_status_idx" ON "leave" USING btree ("status");--> statement-breakpoint
CREATE INDEX "leave_dates_idx" ON "leave" USING btree ("start_date","end_date");--> statement-breakpoint
CREATE INDEX "leave_company_idx" ON "leave" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "leave_balance_employee_idx" ON "leave_balance" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "leave_balance_year_idx" ON "leave_balance" USING btree ("year");--> statement-breakpoint
CREATE INDEX "leave_type_company_idx" ON "leave_type" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "notification_employee_idx" ON "notification" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "notification_company_idx" ON "notification" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "notification_is_read_idx" ON "notification" USING btree ("is_read");--> statement-breakpoint
CREATE INDEX "notification_created_at_idx" ON "notification" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "payroll_employee_idx" ON "payroll" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "payroll_month_year_idx" ON "payroll" USING btree ("month","year");--> statement-breakpoint
CREATE INDEX "payroll_status_idx" ON "payroll" USING btree ("status");--> statement-breakpoint
CREATE INDEX "payroll_company_idx" ON "payroll" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "payroll_item_payroll_idx" ON "payroll_item" USING btree ("payroll_id");--> statement-breakpoint
CREATE INDEX "payroll_item_type_idx" ON "payroll_item" USING btree ("type");--> statement-breakpoint
CREATE INDEX "perf_review_employee_idx" ON "performance_review" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "perf_review_reviewer_idx" ON "performance_review" USING btree ("reviewer_id");--> statement-breakpoint
CREATE INDEX "perf_review_company_idx" ON "performance_review" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "permission_resource_idx" ON "permission" USING btree ("resource");--> statement-breakpoint
CREATE INDEX "position_title_idx" ON "position" USING btree ("title");--> statement-breakpoint
CREATE INDEX "position_dept_idx" ON "position" USING btree ("department_id");--> statement-breakpoint
CREATE INDEX "position_company_idx" ON "position" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "pos_history_employee_idx" ON "position_history" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "pos_history_effective_idx" ON "position_history" USING btree ("effective_date");--> statement-breakpoint
CREATE INDEX "resignation_employee_idx" ON "resignation" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "resignation_status_idx" ON "resignation" USING btree ("status");--> statement-breakpoint
CREATE INDEX "role_company_idx" ON "role" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "role_level_idx" ON "role" USING btree ("level");--> statement-breakpoint
CREATE INDEX "role_permission_role_idx" ON "role_permission" USING btree ("role_id");--> statement-breakpoint
CREATE INDEX "salary_history_employee_idx" ON "salary_history" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "salary_history_effective_idx" ON "salary_history" USING btree ("effective_from");--> statement-breakpoint
CREATE INDEX "salary_employee_idx" ON "salary_structure" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "salary_effective_from_idx" ON "salary_structure" USING btree ("effective_from");--> statement-breakpoint
CREATE INDEX "session_userId_idx" ON "session" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "shift_company_idx" ON "shift" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "training_company_idx" ON "training" USING btree ("company_id");--> statement-breakpoint
CREATE INDEX "training_dates_idx" ON "training" USING btree ("start_date","end_date");--> statement-breakpoint
CREATE INDEX "training_participant_emp_idx" ON "training_participant" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "user_role_employee_idx" ON "user_role" USING btree ("employee_id");--> statement-breakpoint
CREATE INDEX "verification_identifier_idx" ON "verification" USING btree ("identifier");