// schema.ts
import {
  pgTable,
  serial,
  integer,
  text,
  timestamp,
  date,
  boolean,
  pgEnum,
  index,
  unique,
  json,
  decimal,
} from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm";

// ============================================
// ENUMS
// ============================================

export const resignationStatusEnum = pgEnum("resignation_status", [
  "pending",
  "approved",
  "rejected",
  "cancelled",
  "withdrawn",
]);

export const reviewStatusEnum = pgEnum("review_status", [
  "pending",
  "in_progress",
  "completed",
  "cancelled",
]);

export const interviewStatusEnum = pgEnum("interview_status", [
  "scheduled",
  "completed",
  "cancelled",
  "no_show",
  "rescheduled",
]);

export const priorityEnum = pgEnum("priority_level", [
  "low",
  "normal",
  "high",
  "urgent",
]);

export const clearanceStatusEnum = pgEnum("clearance_status", [
  "pending",
  "cleared",
  "rejected",
]);

export const maritalStatusEnum = pgEnum("marital_status", [
  "single",
  "married",
  "divorced",
  "widowed",
]);

export const bloodGroupEnum = pgEnum("blood_group", [
  "A+",
  "A-",
  "B+",
  "B-",
  "O+",
  "O-",
  "AB+",
  "AB-",
]);

export const genderEnum = pgEnum("gender", ["male", "female", "other"]);

export const leaveStatusEnum = pgEnum("leave_status", [
  "pending",
  "approved",
  "rejected",
  "cancelled",
]);

export const attendanceStatusEnum = pgEnum("attendance_status", [
  "present",
  "absent",
  "late",
  "half_day",
  "leave",
]);

export const attendanceSourceEnum = pgEnum("attendance_source", [
  "biometric",
  "manual",
  "api",
  "mobile",
  "web",
]);

export const leaveTypeEnum = pgEnum("leave_type_enum", [
  "annual",
  "sick",
  "maternity",
  "paternity",
  "casual",
  "unpaid",
  "bereavement",
  "study",
]);

export const payrollStatusEnum = pgEnum("payroll_status", [
  "pending",
  "processing",
  "paid",
  "failed",
  "cancelled",
]);

export const documentTypeEnum = pgEnum("document_type", [
  "nid",
  "passport",
  "cv",
  "certificate",
  "photo",
  "contract",
  "offer_letter",
  "other",
]);

export const addressTypeEnum = pgEnum("address_type", [
  "present",
  "permanent",
  "mailing",
  "emergency",
]);

export const contractTypeEnum = pgEnum("contract_type", [
  "permanent",
  "contractual",
  "intern",
  "probation",
  "consultant",
]);

export const auditActionEnum = pgEnum("audit_action", [
  "INSERT",
  "UPDATE",
  "DELETE",
  "SOFT_DELETE",
  "RESTORE",
]);

export const applicationStatusEnum = pgEnum("application_status", [
  "draft",
  "submitted",
  "reviewing",
  "shortlisted",
  "interviewed",
  "offered",
  "hired",
  "rejected",
]);

export const interviewTypeEnum = pgEnum("interview_type", [
  "phone",
  "video",
  "onsite",
  "technical",
  "hr",
]);

export const assetStatusEnum = pgEnum("asset_status", [
  "available",
  "assigned",
  "maintenance",
  "damaged",
  "retired",
]);

export const trainingStatusEnum = pgEnum("training_status", [
  "scheduled",
  "ongoing",
  "completed",
  "cancelled",
]);

// ============================================
// MULTI-TENANCY (Company)
// ============================================

export const company = pgTable(
  "company",
  {
    id: serial("id").primaryKey(),
    name: text("name").notNull(),
    code: text("code").notNull().unique(),
    registrationNo: text("registration_no"),
    taxId: text("tax_id"),
    email: text("email"),
    phone: text("phone"),
    address: text("address"),
    city: text("city"),
    state: text("state"),
    country: text("country").default("Bangladesh"),
    postalCode: text("postal_code"),
    website: text("website"),
    logo: text("logo"),
    fiscalYearStart: date("fiscal_year_start"),
    fiscalYearEnd: date("fiscal_year_end"),
    timezone: text("timezone").default("Asia/Dhaka"),
    isActive: boolean("is_active").default(true),
    deletedAt: timestamp("deleted_at"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("company_name_idx").on(t.name),
    index("company_code_idx").on(t.code),
    index("company_is_active_idx").on(t.isActive),
  ]
);

// ============================================
// RBAC (Role-Based Access Control)
// ============================================

export const role = pgTable(
  "role",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    description: text("description"),
    isSystem: boolean("is_system").default(false),
    level: integer("level").default(0), // 0-100, higher = more privileges
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("role_company_name").on(t.companyId, t.name),
    index("role_company_idx").on(t.companyId),
    index("role_level_idx").on(t.level),
  ]
);

export const permission = pgTable(
  "permission",
  {
    id: serial("id").primaryKey(),
    resource: text("resource").notNull(), // employee, leave, payroll, etc.
    action: text("action").notNull(), // create, read, update, delete, approve
    description: text("description"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    unique("permission_resource_action").on(t.resource, t.action),
    index("permission_resource_idx").on(t.resource),
  ]
);

export const rolePermission = pgTable(
  "role_permission",
  {
    id: serial("id").primaryKey(),
    roleId: integer("role_id")
      .notNull()
      .references(() => role.id, { onDelete: "cascade" }),
    permissionId: integer("permission_id")
      .notNull()
      .references(() => permission.id, { onDelete: "cascade" }),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    unique("role_permission_unique").on(t.roleId, t.permissionId),
    index("role_permission_role_idx").on(t.roleId),
  ]
);

export const userRole = pgTable(
  "user_role",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id").notNull(),
    roleId: integer("role_id")
      .notNull()
      .references(() => role.id, { onDelete: "cascade" }),
    assignedBy: integer("assigned_by"),
    assignedAt: timestamp("assigned_at").notNull().defaultNow(),
    isActive: boolean("is_active").default(true),
  },
  (t) => [
    unique("user_role_unique").on(t.employeeId, t.roleId),
    index("user_role_employee_idx").on(t.employeeId),
  ]
);


// ============================================
// DEPARTMENT (With company support)
// ============================================

export const department = pgTable(
  "department",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    code: text("code").notNull(),
    description: text("description"),
    location: text("location"),
    managerId: integer("manager_id"),
    parentDepartmentId: integer("parent_department_id"),
    isActive: boolean("is_active").notNull().default(true),
    deletedAt: timestamp("deleted_at"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("dept_company_code").on(t.companyId, t.code),
    index("dept_name_idx").on(t.name),
    index("dept_company_idx").on(t.companyId),
    index("dept_manager_idx").on(t.managerId),
    index("dept_parent_idx").on(t.parentDepartmentId),
  ]
);

// ============================================
// POSITION
// ============================================

export const position = pgTable(
  "position",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    departmentId: integer("department_id")
      .notNull()
      .references(() => department.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    code: text("code").notNull(),
    level: text("level"),
    minSalary: integer("min_salary"),
    maxSalary: integer("max_salary"),
    responsibilities: json("responsibilities"),
    requirements: json("requirements"),
    isActive: boolean("is_active").notNull().default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("position_company_code").on(t.companyId, t.code),
    index("position_title_idx").on(t.title),
    index("position_dept_idx").on(t.departmentId),
    index("position_company_idx").on(t.companyId),
  ]
);

// ============================================
// EMPLOYEE (Complete with all fields)
// ============================================

export const employee = pgTable(
  "employee",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    employeeCode: text("employee_code").notNull(),
    name: text("name").notNull(),
    email: text("email").notNull(),
    personalEmail: text("personal_email"),
    idNo: text("id_no").notNull(),
    passportNo: text("passport_no"),
    positionId: integer("position_id")
      .notNull()
      .references(() => position.id, { onDelete: "restrict" }),
    departmentId: integer("department_id").references(() => department.id, {
      onDelete: "set null",
    }),
    reportingManagerId: integer("reporting_manager_id"),
    joiningDate: date("joining_date").notNull(),
    confirmationDate: date("confirmation_date"),
    dateOfBirth: date("date_of_birth").notNull(),
    gender: genderEnum("gender"),
    religion: text("religion"),
    nationality: text("nationality").notNull(),
    contactNo: text("contact_no").notNull(),
    alternateContactNo: text("alternate_contact_no"),
    bloodGroup: bloodGroupEnum("blood_group"),
    maritalStatus: maritalStatusEnum("marital_status"),
    fatherName: text("father_name"),
    motherName: text("mother_name"),
    spouseName: text("spouse_name"),
    isActive: boolean("is_active").notNull().default(true),
    deletedAt: timestamp("deleted_at"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("employee_company_code").on(t.companyId, t.employeeCode),
    unique("employee_company_email").on(t.companyId, t.email),
    unique("employee_company_id_no").on(t.companyId, t.idNo),
    index("employee_email_idx").on(t.email),
    index("employee_code_idx").on(t.employeeCode),
    index("employee_position_idx").on(t.positionId),
    index("employee_department_idx").on(t.departmentId),
    index("employee_manager_idx").on(t.reportingManagerId),
    index("employee_company_idx").on(t.companyId),
  ]
);


// ============================================
// AUDIT LOG (Enterprise tracking)
// ============================================

export const auditLog = pgTable(
  "audit_log",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id").references(() => company.id),
    tableName: text("table_name").notNull(),
    recordId: integer("record_id").notNull(),
    action: auditActionEnum("action").notNull(),
    oldData: json("old_data"),
    newData: json("new_data"),
    changedBy: integer("changed_by").references(() => employee.id),
    ipAddress: text("ip_address"),
    userAgent: text("user_agent"),
    changedAt: timestamp("changed_at").notNull().defaultNow(),
  },
  (t) => [
    index("audit_table_record_idx").on(t.tableName, t.recordId),
    index("audit_changed_by_idx").on(t.changedBy),
    index("audit_changed_at_idx").on(t.changedAt),
    index("audit_company_idx").on(t.companyId),
  ]
);

// ============================================
// EMERGENCY CONTACT (Normalized)
// ============================================

export const emergencyContact = pgTable(
  "emergency_contact",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    relationship: text("relationship").notNull(),
    contactNo: text("contact_no").notNull(),
    alternateContactNo: text("alternate_contact_no"),
    email: text("email"),
    address: text("address"),
    priority: integer("priority").default(1),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [index("emergency_employee_idx").on(t.employeeId)]
);

// ============================================
// BANK INFORMATION (Normalized)
// ============================================

export const bankInfo = pgTable(
  "bank_info",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    bankName: text("bank_name").notNull(),
    accountNo: text("account_no").notNull(),
    accountName: text("account_name"),
    branchName: text("branch_name"),
    routingNo: text("routing_no"),
    swiftCode: text("swift_code"),
    isPrimary: boolean("is_primary").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("bank_account_unique").on(t.employeeId, t.accountNo),
    index("bank_employee_idx").on(t.employeeId),
  ]
);

// ============================================
// ADDRESS (With company support)
// ============================================

export const address = pgTable(
  "address",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    type: addressTypeEnum("type").notNull().default("present"),
    street: text("street").notNull(),
    city: text("city").notNull(),
    policeStation: text("police_station"),
    postOffice: text("post_office"),
    state: text("state"),
    postalCode: text("postal_code"),
    country: text("country").notNull().default("Bangladesh"),
    isPrimary: boolean("is_primary").default(false),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("address_employee_idx").on(t.employeeId),
    index("address_type_idx").on(t.type),
  ]
);

// ============================================
// EDUCATION
// ============================================

export const education = pgTable(
  "education",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    institution: text("institution").notNull(),
    degree: text("degree").notNull(),
    fieldOfStudy: text("field_of_study"),
    result: text("result"),
    startDate: date("start_date").notNull(),
    endDate: date("end_date"),
    isHighest: boolean("is_highest").default(false),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("education_employee_idx").on(t.employeeId),
    index("education_degree_idx").on(t.degree),
  ]
);

// ============================================
// EXPERIENCE
// ============================================

export const experience = pgTable(
  "experience",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    company: text("company").notNull(),
    position: text("position").notNull(),
    startDate: date("start_date").notNull(),
    endDate: date("end_date"),
    isCurrent: boolean("is_current").default(false),
    description: text("description"),
    responsibilities: json("responsibilities"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("experience_employee_idx").on(t.employeeId),
    index("experience_company_idx").on(t.company),
  ]
);

// ============================================
// DOCUMENT
// ============================================

export const document = pgTable(
  "document",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    documentType: documentTypeEnum("document_type").notNull(),
    documentPath: text("document_path").notNull(),
    fileName: text("file_name").notNull(),
    fileSize: integer("file_size"),
    mimeType: text("mime_type"),
    description: text("description"),
    uploadedBy: integer("uploaded_by").references(() => employee.id),
    isVerified: boolean("is_verified").default(false),
    verifiedBy: integer("verified_by").references(() => employee.id),
    verifiedAt: timestamp("verified_at"),
    expiresAt: timestamp("expires_at"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("document_employee_idx").on(t.employeeId),
    index("document_type_idx").on(t.documentType),
  ]
);

// ============================================
// CONTRACT MANAGEMENT
// ============================================

export const contract = pgTable(
  "contract",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    contractType: contractTypeEnum("contract_type").notNull(),
    startDate: date("start_date").notNull(),
    endDate: date("end_date"),
    probationPeriod: integer("probation_period"), // in days
    noticePeriod: integer("notice_period"), // in days
    salary: integer("salary"),
    documentPath: text("document_path"),
    isActive: boolean("is_active").default(true),
    signedBy: integer("signed_by").references(() => employee.id),
    signedAt: timestamp("signed_at"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("contract_employee_idx").on(t.employeeId),
    index("contract_dates_idx").on(t.startDate, t.endDate),
  ]
);

// ============================================
// SHIFT MANAGEMENT
// ============================================

export const shift = pgTable(
  "shift",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    code: text("code").notNull(),
    startTime: text("start_time").notNull(), // "09:00:00"
    endTime: text("end_time").notNull(),
    gracePeriod: integer("grace_period"), // minutes
    breakTime: integer("break_time"), // minutes
    workingHours: integer("working_hours"), // minutes
    isNightShift: boolean("is_night_shift").default(false),
    isActive: boolean("is_active").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("shift_company_code").on(t.companyId, t.code),
    index("shift_company_idx").on(t.companyId),
  ]
);

export const employeeShift = pgTable(
  "employee_shift",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    shiftId: integer("shift_id")
      .notNull()
      .references(() => shift.id, { onDelete: "cascade" }),
    date: date("date").notNull(),
    assignedBy: integer("assigned_by").references(() => employee.id),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    unique("employee_shift_date").on(t.employeeId, t.date),
    index("emp_shift_employee_idx").on(t.employeeId),
    index("emp_shift_date_idx").on(t.date),
  ]
);

// ============================================
// ATTENDANCE (Enhanced)
// ============================================

export const attendance = pgTable(
  "attendance",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    date: date("date").notNull(),
    shiftId: integer("shift_id").references(() => shift.id),
    status: attendanceStatusEnum("status").notNull(),
    checkIn: timestamp("check_in"),
    checkOut: timestamp("check_out"),
    checkInLocation: json("check_in_location"), // {lat, lng, address}
    checkOutLocation: json("check_out_location"),
    checkInDevice: text("check_in_device"),
    checkOutDevice: text("check_out_device"),
    source: attendanceSourceEnum("source").default("manual"),
    workingHours: integer("working_hours"), // in minutes
    overtimeHours: integer("overtime_hours"), // in minutes
    lateMinutes: integer("late_minutes").default(0),
    earlyExitMinutes: integer("early_exit_minutes").default(0),
    remarks: text("remarks"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("attendance_emp_date_unique").on(t.employeeId, t.date),
    index("attendance_emp_date_idx").on(t.employeeId, t.date),
    index("attendance_status_idx").on(t.status),
    index("attendance_date_idx").on(t.date),
  ]
);

// ============================================
// LEAVE TYPE
// ============================================

export const leaveType = pgTable(
  "leave_type",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: leaveTypeEnum("name").notNull(),
    maxDaysPerYear: integer("max_days_per_year"),
    isPaid: boolean("is_paid").default(true),
    requiresApproval: boolean("requires_approval").default(true),
    carryForward: boolean("carry_forward").default(false),
    maxCarryForwardDays: integer("max_carry_forward_days"),
    applicableGender: genderEnum("applicable_gender"), // null = all
    minServiceMonths: integer("min_service_months").default(0),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("leave_type_company_name").on(t.companyId, t.name),
    index("leave_type_company_idx").on(t.companyId),
  ]
);

// ============================================
// LEAVE
// ============================================

export const leave = pgTable(
  "leave",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    leaveTypeId: integer("leave_type_id")
      .notNull()
      .references(() => leaveType.id),
    startDate: date("start_date").notNull(),
    endDate: date("end_date").notNull(),
    days: decimal("days", { precision: 4, scale: 1 }).notNull(),
    reason: text("reason"),
    status: leaveStatusEnum("status").notNull().default("pending"),
    approvedById: integer("approved_by_id").references(() => employee.id),
    approvedAt: timestamp("approved_at"),
    rejectionReason: text("rejection_reason"),
    attachments: json("attachments"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("leave_employee_idx").on(t.employeeId),
    index("leave_type_idx").on(t.leaveTypeId),
    index("leave_status_idx").on(t.status),
    index("leave_dates_idx").on(t.startDate, t.endDate),
    index("leave_company_idx").on(t.companyId),
  ]
);

// ============================================
// LEAVE BALANCE
// ============================================

export const leaveBalance = pgTable(
  "leave_balance",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    leaveTypeId: integer("leave_type_id")
      .notNull()
      .references(() => leaveType.id),
    year: integer("year").notNull(),
    totalDays: decimal("total_days", { precision: 5, scale: 1 }).notNull(),
    usedDays: decimal("used_days", { precision: 5, scale: 1 }).notNull().default("0"),
    pendingDays: decimal("pending_days", { precision: 5, scale: 1 }).notNull().default("0"),
    carriedOverDays: decimal("carried_over_days", { precision: 5, scale: 1 }).default("0"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("leave_balance_emp_year_type").on(t.employeeId, t.year, t.leaveTypeId),
    index("leave_balance_employee_idx").on(t.employeeId),
    index("leave_balance_year_idx").on(t.year),
  ]
);

// ============================================
// ALLOWANCE & DEDUCTION TYPES
// ============================================

export const allowanceType = pgTable(
  "allowance_type",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    code: text("code").notNull(),
    description: text("description"),
    isFixed: boolean("is_fixed").default(true),
    isTaxable: boolean("is_taxable").default(true),
    calculationType: text("calculation_type"), // fixed, percentage
    calculationValue: decimal("calculation_value"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("allowance_company_code").on(t.companyId, t.code),
    index("allowance_company_idx").on(t.companyId),
  ]
);

export const deductionType = pgTable(
  "deduction_type",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    code: text("code").notNull(),
    description: text("description"),
    isMandatory: boolean("is_mandatory").default(false),
    isTaxable: boolean("is_taxable").default(false),
    calculationType: text("calculation_type"), // fixed, percentage
    calculationValue: decimal("calculation_value"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("deduction_company_code").on(t.companyId, t.code),
    index("deduction_company_idx").on(t.companyId),
  ]
);

// ============================================
// EMPLOYEE COMPENSATION (Dynamic)
// ============================================

export const employeeAllowance = pgTable(
  "employee_allowance",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    allowanceTypeId: integer("allowance_type_id")
      .notNull()
      .references(() => allowanceType.id),
    amount: decimal("amount", { precision: 12, scale: 2 }).notNull(),
    effectiveFrom: date("effective_from").notNull(),
    effectiveTo: date("effective_to"),
    isRecurring: boolean("is_recurring").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("emp_allowance_employee_idx").on(t.employeeId),
    index("emp_allowance_effective_idx").on(t.effectiveFrom),
  ]
);

export const employeeDeduction = pgTable(
  "employee_deduction",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    deductionTypeId: integer("deduction_type_id")
      .notNull()
      .references(() => deductionType.id),
    amount: decimal("amount", { precision: 12, scale: 2 }).notNull(),
    effectiveFrom: date("effective_from").notNull(),
    effectiveTo: date("effective_to"),
    isRecurring: boolean("is_recurring").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("emp_deduction_employee_idx").on(t.employeeId),
    index("emp_deduction_effective_idx").on(t.effectiveFrom),
  ]
);

// ============================================
// SALARY STRUCTURE
// ============================================

export const salaryStructure = pgTable(
  "salary_structure",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    basicSalary: decimal("basic_salary", { precision: 12, scale: 2 }).notNull(),
    effectiveFrom: date("effective_from").notNull(),
    effectiveTo: date("effective_to"),
    isCurrent: boolean("is_current").default(false),
    approvedById: integer("approved_by_id").references(() => employee.id),
    approvedAt: timestamp("approved_at"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("salary_employee_idx").on(t.employeeId),
    index("salary_effective_from_idx").on(t.effectiveFrom),
  ]
);

// ============================================
// PAYROLL (With detailed items)
// ============================================

export const payroll = pgTable(
  "payroll",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    month: integer("month").notNull(),
    year: integer("year").notNull(),
    basicSalary: decimal("basic_salary", { precision: 12, scale: 2 }).notNull(),
    totalAllowances: decimal("total_allowances", { precision: 12, scale: 2 }).notNull().default("0"),
    totalDeductions: decimal("total_deductions", { precision: 12, scale: 2 }).notNull().default("0"),
    netSalary: decimal("net_salary", { precision: 12, scale: 2 }).notNull(),
    bonus: decimal("bonus", { precision: 12, scale: 2 }).default("0"),
    overtimePay: decimal("overtime_pay", { precision: 12, scale: 2 }).default("0"),
    taxAmount: decimal("tax_amount", { precision: 12, scale: 2 }).default("0"),
    paymentDate: date("payment_date"),
    paymentMethod: text("payment_method"),
    transactionId: text("transaction_id"),
    status: payrollStatusEnum("status").notNull().default("pending"),
    processedBy: integer("processed_by").references(() => employee.id),
    processedAt: timestamp("processed_at"),
    remarks: text("remarks"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("payroll_emp_month_year").on(t.employeeId, t.month, t.year),
    index("payroll_employee_idx").on(t.employeeId),
    index("payroll_month_year_idx").on(t.month, t.year),
    index("payroll_status_idx").on(t.status),
    index("payroll_company_idx").on(t.companyId),
  ]
);

export const payrollItem = pgTable(
  "payroll_item",
  {
    id: serial("id").primaryKey(),
    payrollId: integer("payroll_id")
      .notNull()
      .references(() => payroll.id, { onDelete: "cascade" }),
    type: text("type").notNull(), // allowance, deduction, bonus, overtime
    referenceId: integer("reference_id"), // allowanceTypeId or deductionTypeId
    name: text("name").notNull(),
    amount: decimal("amount", { precision: 12, scale: 2 }).notNull(),
    isTaxable: boolean("is_taxable").default(false),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    index("payroll_item_payroll_idx").on(t.payrollId),
    index("payroll_item_type_idx").on(t.type),
  ]
);

// ============================================
// KPI / PERFORMANCE MANAGEMENT
// ============================================

export const kpi = pgTable(
  "kpi",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    description: text("description"),
    category: text("category"), // individual, team, company
    unit: text("unit"), // percentage, number, boolean
    target: json("target"), // {min, max, target}
    weight: integer("weight").default(100),
    isActive: boolean("is_active").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("kpi_company_idx").on(t.companyId),
    index("kpi_category_idx").on(t.category),
  ]
);

export const performanceReview = pgTable(
  "performance_review",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    reviewerId: integer("reviewer_id")
      .notNull()
      .references(() => employee.id),
    reviewPeriod: text("review_period").notNull(),
    reviewDate: date("review_date").notNull(),
    overallRating: decimal("overall_rating", { precision: 3, scale: 1 }), // 1-5
    strengths: text("strengths"),
    areasOfImprovement: text("areas_of_improvement"),
    goals: json("goals"),
    comments: text("comments"),
    status: text("status").default("pending"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("perf_review_employee_idx").on(t.employeeId),
    index("perf_review_reviewer_idx").on(t.reviewerId),
    index("perf_review_company_idx").on(t.companyId),
  ]
);

export const employeeKpi = pgTable(
  "employee_kpi",
  {
    id: serial("id").primaryKey(),
    reviewId: integer("review_id")
      .notNull()
      .references(() => performanceReview.id, { onDelete: "cascade" }),
    kpiId: integer("kpi_id")
      .notNull()
      .references(() => kpi.id),
    score: decimal("score", { precision: 10, scale: 2 }),
    achievedValue: text("achieved_value"),
    comments: text("comments"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    unique("review_kpi_unique").on(t.reviewId, t.kpiId),
    index("emp_kpi_review_idx").on(t.reviewId),
  ]
);

// ============================================
// RECRUITMENT MODULE
// ============================================

export const jobPost = pgTable(
  "job_post",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    departmentId: integer("department_id").references(() => department.id),
    positionId: integer("position_id").references(() => position.id),
    description: text("description"),
    requirements: json("requirements"),
    responsibilities: json("responsibilities"),
    location: text("location"),
    employmentType: text("employment_type"), // full-time, part-time, contract
    experienceRequired: text("experience_required"),
    salaryRange: json("salary_range"),
    postedBy: integer("posted_by").references(() => employee.id),
    postedAt: timestamp("posted_at").defaultNow(),
    expiresAt: timestamp("expires_at"),
    isActive: boolean("is_active").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("job_post_company_idx").on(t.companyId),
    index("job_post_title_idx").on(t.title),
    index("job_post_status_idx").on(t.isActive),
  ]
);

export const applicant = pgTable(
  "applicant",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    jobPostId: integer("job_post_id").references(() => jobPost.id),
    name: text("name").notNull(),
    email: text("email").notNull(),
    phone: text("phone"),
    resumePath: text("resume_path"),
    coverLetter: text("cover_letter"),
    expectedSalary: decimal("expected_salary", { precision: 12, scale: 2 }),
    currentCompany: text("current_company"),
    experienceYears: integer("experience_years"),
    status: applicationStatusEnum("status").default("draft"),
    appliedAt: timestamp("applied_at").defaultNow(),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("applicant_job_idx").on(t.jobPostId),
    index("applicant_email_idx").on(t.email),
    index("applicant_status_idx").on(t.status),
    index("applicant_company_idx").on(t.companyId),
  ]
);

export const interview = pgTable(
  "interview",
  {
    id: serial("id").primaryKey(),
    applicantId: integer("applicant_id")
      .notNull()
      .references(() => applicant.id, { onDelete: "cascade" }),
    interviewerId: integer("interviewer_id").references(() => employee.id),
    interviewType: interviewTypeEnum("interview_type").notNull(),
    scheduledAt: timestamp("scheduled_at").notNull(),
    duration: integer("duration"), // minutes
    location: text("location"),
    meetingLink: text("meeting_link"),
    feedback: text("feedback"),
    rating: integer("rating"), // 1-5
    status: text("status").default("scheduled"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("interview_applicant_idx").on(t.applicantId),
    index("interview_interviewer_idx").on(t.interviewerId),
    index("interview_scheduled_idx").on(t.scheduledAt),
  ]
);

// ============================================
// ASSET MANAGEMENT
// ============================================

export const asset = pgTable(
  "asset",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    assetCode: text("asset_code").notNull(),
    name: text("name").notNull(),
    type: text("type").notNull(), // laptop, monitor, phone, etc.
    model: text("model"),
    serialNo: text("serial_no"),
    purchaseDate: date("purchase_date"),
    purchasePrice: decimal("purchase_price", { precision: 12, scale: 2 }),
    warrantyExpiry: date("warranty_expiry"),
    status: assetStatusEnum("status").default("available"),
    assignedTo: integer("assigned_to").references(() => employee.id),
    assignedAt: timestamp("assigned_at"),
    notes: text("notes"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    unique("asset_company_code").on(t.companyId, t.assetCode),
    index("asset_company_idx").on(t.companyId),
    index("asset_assigned_idx").on(t.assignedTo),
    index("asset_status_idx").on(t.status),
  ]
);

// ============================================
// TRAINING MANAGEMENT
// ============================================

export const training = pgTable(
  "training",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    description: text("description"),
    type: text("type"), // technical, soft-skill, compliance
    startDate: date("start_date"),
    endDate: date("end_date"),
    location: text("location"),
    trainer: text("trainer"),
    maxParticipants: integer("max_participants"),
    cost: decimal("cost", { precision: 12, scale: 2 }),
    status: trainingStatusEnum("status").default("scheduled"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("training_company_idx").on(t.companyId),
    index("training_dates_idx").on(t.startDate, t.endDate),
  ]
);

export const trainingParticipant = pgTable(
  "training_participant",
  {
    id: serial("id").primaryKey(),
    trainingId: integer("training_id")
      .notNull()
      .references(() => training.id, { onDelete: "cascade" }),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    completionStatus: boolean("completion_status").default(false),
    completionDate: date("completion_date"),
    feedback: text("feedback"),
    rating: integer("rating"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    unique("training_participant_unique").on(t.trainingId, t.employeeId),
    index("training_participant_emp_idx").on(t.employeeId),
  ]
);

// ============================================
// EXIT MANAGEMENT
// ============================================

export const resignation = pgTable(
  "resignation",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    resignationDate: date("resignation_date").notNull(),
    lastWorkingDay: date("last_working_day").notNull(),
    reason: text("reason"),
    status: resignationStatusEnum("status").default("pending"), // pending, approved, rejected, cancelled
    approvedById: integer("approved_by_id").references(() => employee.id),
    approvedAt: timestamp("approved_at"),
    counterOffer: text("counter_offer"),
    exitInterviewDate: date("exit_interview_date"),
    exitInterviewFeedback: text("exit_interview_feedback"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
  },
  (t) => [
    index("resignation_employee_idx").on(t.employeeId),
    index("resignation_status_idx").on(t.status),
  ]
);

export const exitClearance = pgTable(
  "exit_clearance",
  {
    id: serial("id").primaryKey(),
    resignationId: integer("resignation_id")
      .notNull()
      .references(() => resignation.id, { onDelete: "cascade" }),
    department: text("department").notNull(), // hr, it, finance, admin
    clearedBy: integer("cleared_by").references(() => employee.id),
    clearedAt: timestamp("cleared_at"),
    remarks: text("remarks"),
    isCleared: boolean("is_cleared").default(false),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    index("exit_clearance_resignation_idx").on(t.resignationId),
    index("exit_clearance_department_idx").on(t.department),
  ]
);

// ============================================
// NOTIFICATIONS
// ============================================

export const notification = pgTable(
  "notification",
  {
    id: serial("id").primaryKey(),
    companyId: integer("company_id")
      .notNull()
      .references(() => company.id, { onDelete: "cascade" }),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    title: text("title").notNull(),
    message: text("message").notNull(),
    type: text("type").notNull(),
    priority: text("priority").default("normal"), // low, normal, high, urgent
    isRead: boolean("is_read").default(false),
    readAt: timestamp("read_at"),
    link: text("link"),
    metadata: json("metadata"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
  },
  (t) => [
    index("notification_employee_idx").on(t.employeeId),
    index("notification_company_idx").on(t.companyId),
    index("notification_is_read_idx").on(t.isRead),
    index("notification_created_at_idx").on(t.createdAt),
  ]
);

// ============================================
// HISTORY TABLES
// ============================================

export const positionHistory = pgTable(
  "position_history",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    positionId: integer("position_id").notNull(),
    departmentId: integer("department_id"),
    changedAt: timestamp("changed_at").notNull().defaultNow(),
    changedById: integer("changed_by_id").references(() => employee.id),
    reason: text("reason"),
    effectiveDate: date("effective_date").notNull(),
  },
  (t) => [
    index("pos_history_employee_idx").on(t.employeeId),
    index("pos_history_effective_idx").on(t.effectiveDate),
  ]
);

export const salaryHistory = pgTable(
  "salary_history",
  {
    id: serial("id").primaryKey(),
    employeeId: integer("employee_id")
      .notNull()
      .references(() => employee.id, { onDelete: "cascade" }),
    oldSalary: decimal("old_salary", { precision: 12, scale: 2 }),
    newSalary: decimal("new_salary", { precision: 12, scale: 2 }).notNull(),
    effectiveFrom: date("effective_from").notNull(),
    changedAt: timestamp("changed_at").notNull().defaultNow(),
    changedById: integer("changed_by_id").references(() => employee.id),
    reason: text("reason"),
    approvalStatus: text("approval_status").default("approved"),
  },
  (t) => [
    index("salary_history_employee_idx").on(t.employeeId),
    index("salary_history_effective_idx").on(t.effectiveFrom),
  ]
);

// ============================================
// RELATIONS (Complete)
// ============================================

export const companyRelations = relations(company, ({ many }) => ({
  employees: many(employee),
  departments: many(department),
  positions: many(position),
  roles: many(role),
  shifts: many(shift),
  leaveTypes: many(leaveType),
  allowanceTypes: many(allowanceType),
  deductionTypes: many(deductionType),
  jobPosts: many(jobPost),
  assets: many(asset),
  trainings: many(training),
  notifications: many(notification),
}));

export const employeeRelations = relations(employee, ({ one, many }) => ({
  company: one(company, {
    fields: [employee.companyId],
    references: [company.id],
  }),
  position: one(position, {
    fields: [employee.positionId],
    references: [position.id],
  }),
  department: one(department, {
    fields: [employee.departmentId],
    references: [department.id],
  }),
  reportingManager: one(employee, {
    fields: [employee.reportingManagerId],
    references: [employee.id],
    relationName: "manager_relations",
  }),
  subordinates: many(employee, {
    relationName: "manager_relations",
  }),
  roles: many(userRole),
  addresses: many(address),
  educations: many(education),
  experiences: many(experience),
  documents: many(document),
  emergencyContacts: many(emergencyContact),
  bankInfo: many(bankInfo),
  contracts: many(contract),
  attendances: many(attendance),
  leaves: many(leave),
  leaveBalances: many(leaveBalance),
  payrolls: many(payroll),
  salaryStructures: many(salaryStructure),
  employeeAllowances: many(employeeAllowance),
  employeeDeductions: many(employeeDeduction),
  performanceReviews: many(performanceReview),
  notifications: many(notification),
  assignedAssets: many(asset, {
    relationName: "assigned_assets",
  }),
  trainingParticipants: many(trainingParticipant),
  resignation: one(resignation),
}));

export const departmentRelations = relations(department, ({ one, many }) => ({
  company: one(company, {
    fields: [department.companyId],
    references: [company.id],
  }),
  manager: one(employee, {
    fields: [department.managerId],
    references: [employee.id],
  }),
  parentDepartment: one(department, {
    fields: [department.parentDepartmentId],
    references: [department.id],
    relationName: "department_hierarchy",
  }),
  subDepartments: many(department, {
    relationName: "department_hierarchy",
  }),
  employees: many(employee),
  positions: many(position),
}));

export const roleRelations = relations(role, ({ one, many }) => ({
  company: one(company, {
    fields: [role.companyId],
    references: [company.id],
  }),
  permissions: many(rolePermission),
  users: many(userRole),
}));

export const permissionRelations = relations(permission, ({ many }) => ({
  roles: many(rolePermission),
}));

export const rolePermissionRelations = relations(rolePermission, ({ one }) => ({
  role: one(role, {
    fields: [rolePermission.roleId],
    references: [role.id],
  }),
  permission: one(permission, {
    fields: [rolePermission.permissionId],
    references: [permission.id],
  }),
}));

export const userRoleRelations = relations(userRole, ({ one }) => ({
  employee: one(employee, {
    fields: [userRole.employeeId],
    references: [employee.id],
  }),
  role: one(role, {
    fields: [userRole.roleId],
    references: [role.id],
  }),
}));

// Add more relations as needed...

// ============================================
// TYPES
// ============================================

import type { InferSelectModel, InferInsertModel } from "drizzle-orm";

export type Company = InferSelectModel<typeof company>;
export type NewCompany = InferInsertModel<typeof company>;

export type Employee = InferSelectModel<typeof employee>;
export type NewEmployee = InferInsertModel<typeof employee>;

export type Department = InferSelectModel<typeof department>;
export type NewDepartment = InferInsertModel<typeof department>;

export type Position = InferSelectModel<typeof position>;
export type NewPosition = InferInsertModel<typeof position>;

export type Attendance = InferSelectModel<typeof attendance>;
export type NewAttendance = InferInsertModel<typeof attendance>;

export type Leave = InferSelectModel<typeof leave>;
export type NewLeave = InferInsertModel<typeof leave>;

export type Payroll = InferSelectModel<typeof payroll>;
export type NewPayroll = InferInsertModel<typeof payroll>;

export type Role = InferSelectModel<typeof role>;
export type NewRole = InferInsertModel<typeof role>;

export type Permission = InferSelectModel<typeof permission>;
export type NewPermission = InferInsertModel<typeof permission>;

export type AuditLog = InferSelectModel<typeof auditLog>;
export type NewAuditLog = InferInsertModel<typeof auditLog>;

export type JobPost = InferSelectModel<typeof jobPost>;
export type NewJobPost = InferInsertModel<typeof jobPost>;

export type Asset = InferSelectModel<typeof asset>;
export type NewAsset = InferInsertModel<typeof asset>;

export type Training = InferSelectModel<typeof training>;
export type NewTraining = InferInsertModel<typeof training>;

// ============================================
// EXPORTS
// ============================================

export * from "./auth.schema";