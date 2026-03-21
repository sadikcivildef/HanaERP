// fix-relations.ts
import { readFileSync, writeFileSync } from 'fs';

const schemaContent = readFileSync('schema.ts', 'utf-8');

// Define all tables that need relations based on your employeeRelations
const tablesNeedingRelations = [
  'address', 'education', 'experience', 'document', 'emergencyContact',
  'bankInfo', 'contract', 'attendance', 'leave', 'leaveBalance', 'payroll',
  'salaryStructure', 'employeeAllowance', 'employeeDeduction', 'performanceReview',
  'notification', 'asset', 'trainingParticipant', 'resignation', 'userRole',
  'employeeShift', 'positionHistory', 'salaryHistory', 'leaveType', 'allowanceType',
  'deductionType', 'jobPost', 'training', 'kpi', 'applicant', 'interview',
  'exitClearance', 'payrollItem', 'employeeKpi'
];

// Generate missing relations
const missingRelations: string[] = [];

// Check if relation exists for each table
for (const table of tablesNeedingRelations) {
  const relationRegex = new RegExp(`export const ${table}Relations = relations\\(${table},`);
  if (!relationRegex.test(schemaContent)) {
    missingRelations.push(table);
  }
}

console.log('🔍 Missing relations for:', missingRelations.join(', '));

if (missingRelations.length === 0) {
  console.log('✅ All relations appear to be defined!');
  process.exit(0);
}

// Generate relation definitions
const relationDefinitions: string[] = [];

for (const table of missingRelations) {
  switch (table) {
    case 'payrollItem':
      relationDefinitions.push(`
export const payrollItemRelations = relations(payrollItem, ({ one }) => ({
  payroll: one(payroll, {
    fields: [payrollItem.payrollId],
    references: [payroll.id],
  }),
}));`);
      break;
      
    case 'employeeKpi':
      relationDefinitions.push(`
export const employeeKpiRelations = relations(employeeKpi, ({ one }) => ({
  review: one(performanceReview, {
    fields: [employeeKpi.reviewId],
    references: [performanceReview.id],
  }),
  kpi: one(kpi, {
    fields: [employeeKpi.kpiId],
    references: [kpi.id],
  }),
}));`);
      break;
      
    case 'kpi':
      relationDefinitions.push(`
export const kpiRelations = relations(kpi, ({ one, many }) => ({
  company: one(company, {
    fields: [kpi.companyId],
    references: [company.id],
  }),
  employeeKpis: many(employeeKpi),
}));`);
      break;
      
    case 'applicant':
      relationDefinitions.push(`
export const applicantRelations = relations(applicant, ({ one, many }) => ({
  company: one(company, {
    fields: [applicant.companyId],
    references: [company.id],
  }),
  jobPost: one(jobPost, {
    fields: [applicant.jobPostId],
    references: [jobPost.id],
  }),
  interviews: many(interview),
}));`);
      break;
      
    case 'interview':
      relationDefinitions.push(`
export const interviewRelations = relations(interview, ({ one }) => ({
  applicant: one(applicant, {
    fields: [interview.applicantId],
    references: [applicant.id],
  }),
  interviewer: one(employee, {
    fields: [interview.interviewerId],
    references: [employee.id],
  }),
}));`);
      break;
      
    case 'exitClearance':
      relationDefinitions.push(`
export const exitClearanceRelations = relations(exitClearance, ({ one }) => ({
  resignation: one(resignation, {
    fields: [exitClearance.resignationId],
    references: [resignation.id],
  }),
  clearedBy: one(employee, {
    fields: [exitClearance.clearedBy],
    references: [employee.id],
  }),
}));`);
      break;
      
    default:
      // Generate generic relation
      relationDefinitions.push(`
export const ${table}Relations = relations(${table}, ({ one }) => ({
  employee: one(employee, {
    fields: [${table}.employeeId],
    references: [employee.id],
  }),
}));`);
  }
}

if (relationDefinitions.length > 0) {
  // Find where to insert the relations
  const lastRelationIndex = schemaContent.lastIndexOf('export const ');
  const insertPoint = schemaContent.lastIndexOf('// Add more relations as needed...');
  
  const updatedContent = schemaContent.slice(0, insertPoint) + 
    '\n' + relationDefinitions.join('\n') + '\n' +
    schemaContent.slice(insertPoint);
  
  // Create backup
  writeFileSync('schema.ts.backup', schemaContent);
  console.log('💾 Backup created: schema.ts.backup');
  
  // Write updated schema
  writeFileSync('schema.ts', updatedContent);
  console.log('✅ Added missing relation definitions to schema.ts');
  console.log('\n📝 Added relations for:');
  missingRelations.forEach(r => console.log(`  - ${r}`));
}