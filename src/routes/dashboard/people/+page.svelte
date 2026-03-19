<script lang="ts">
  import Button from "$lib/assets/ui/components/button.svelte";
  import Input from "$lib/assets/ui/components/input.svelte";
  import Pagination from "$lib/assets/ui/components/pagination.svelte";
  import * as Table from "$lib/assets/ui/table";
  import { navBtn, navBtnLink, navTitle } from "$lib/navStore";
  import { startLoading } from "$lib/stores/loading";
  import Icon from "@iconify/svelte";
  import { onMount } from "svelte";

  // When this specific page loads, change the title
  onMount(() => {
    $navTitle = "Employee";
    $navBtn = "Add new";
    $navBtnLink = "dashboard/people/add-new";

    // Start loading animation
    startLoading();
  });

const employees = [
  { id: 101, name: "Rahim Mia", department: "Sewing", section: "A1", position: "Operator", joining_date: "18-03-2026", status: "Active" },
  { id: 102, name: "Fatima Begum", department: "Cutting", section: "-", position: "Assistant Operator", joining_date: "12-07-2024", status: "Inactive" },

  { id: 103, name: "Md. Jamal Hossain", department: "Sewing", section: "A1", position: "Senior Operator", joining_date: "05-11-2022", status: "Active" },
  { id: 104, name: "Ayesha Akter", department: "Sewing", section: "A2", position: "Operator", joining_date: "19-09-2023", status: "Active" },
  { id: 105, name: "Kamal Uddin", department: "Cutting", section: "C1", position: "Cutter", joining_date: "03-04-2021", status: "Active" },
  { id: 106, name: "Nasrin Sultana", department: "Finishing", section: "F3", position: "Checker", joining_date: "28-06-2024", status: "Active" },
  { id: 107, name: "Sohag Mia", department: "Sewing", section: "B2", position: "Operator", joining_date: "14-02-2023", status: "Active" },
  { id: 108, name: "Rina Begum", department: "Sewing", section: "A3", position: "Helper", joining_date: "09-10-2025", status: "Active" },
  { id: 109, name: "Md. Faruk Hossain", department: "Iron", section: "I1", position: "Ironman", joining_date: "22-08-2020", status: "Active" },
  { id: 110, name: "Shahnaz Parvin", department: "Packing", section: "P2", position: "Folder", joining_date: "17-01-2024", status: "Active" },

  { id: 111, name: "Babu Miah", department: "Sewing", section: "A1", position: "Line Leader", joining_date: "30-05-2019", status: "Active" },
  { id: 112, name: "Mst. Lovely Akter", department: "Sewing", section: "B1", position: "Operator", joining_date: "11-12-2023", status: "Active" },
  { id: 113, name: "Jahangir Alam", department: "Cutting", section: "C2", position: "Marker Man", joining_date: "07-03-2022", status: "Active" },
  { id: 114, name: "Suma Akter", department: "Finishing", section: "F1", position: "Thread Cutter", joining_date: "25-04-2025", status: "Active" },
  { id: 115, name: "Rasel Khan", department: "Sewing", section: "A4", position: "Operator", joining_date: "16-08-2024", status: "Active" },
  { id: 116, name: "Parvin Akter", department: "Sewing", section: "B3", position: "Helper", joining_date: "02-11-2025", status: "Active" },
  { id: 117, name: "Md. Salim", department: "Maintenance", section: "-", position: "Helper", joining_date: "13-06-2021", status: "Active" },
  { id: 118, name: "Rokeya Begum", department: "Finishing", section: "F2", position: "Checker", joining_date: "20-09-2023", status: "Active" },
  { id: 119, name: "Habib Rahman", department: "Sewing", section: "A2", position: "Senior Operator", joining_date: "08-07-2020", status: "Active" },
  { id: 120, name: "Sadia Islam", department: "Packing", section: "P1", position: "Packer", joining_date: "04-02-2025", status: "Active" },

  // ───────────────────────────────────────────────
  // Bulk generated style (121–220)
  // ───────────────────────────────────────────────

  { id: 121, name: "Md. Raju", department: "Sewing", section: "A3", position: "Operator", joining_date: "15-03-2024", status: "Active" },
  { id: 122, name: "Laila Begum", department: "Sewing", section: "B1", position: "Operator", joining_date: "27-05-2023", status: "Active" },
  { id: 123, name: "Asaduzzaman", department: "Cutting", section: "C1", position: "Cutter", joining_date: "19-10-2022", status: "Active" },
  { id: 124, name: "Mim Akter", department: "Finishing", section: "F3", position: "Helper", joining_date: "06-12-2024", status: "Active" },
  { id: 125, name: "Shakil Ahmed", department: "Sewing", section: "A1", position: "Operator", joining_date: "21-08-2023", status: "Active" },
  { id: 126, name: "Nargis Fatema", department: "Packing", section: "P2", position: "Packer", joining_date: "10-01-2025", status: "Active" },
  { id: 127, name: "Md. Imran", department: "Sewing", section: "B2", position: "Helper", joining_date: "03-04-2024", status: "Active" },
  { id: 128, name: "Sultana Razia", department: "Sewing", section: "A4", position: "Operator", joining_date: "29-07-2023", status: "Active" },
  { id: 129, name: "Belal Hossain", department: "Iron", section: "I1", position: "Ironman", joining_date: "14-11-2021", status: "Active" },
  { id: 130, name: "Ruma Akter", department: "Finishing", section: "F1", position: "Checker", joining_date: "08-09-2024", status: "Active" },

  // ... continuing pattern ...
];
</script>

<div class="flex w-fit gap-3 items-center">
  <Input
    type="text"
    name="search"
    placeholder="Search by ID, Name, Section etc."
    className="w-85"
  />
  <Button><Icon icon="tabler:search" class="-mx-1.5 my-0.5 w-5 h-5" /></Button>
</div>

<Pagination items={employees} itemsPerPage={10} let:paginatedItems>
  <Table.Root>
    <Table.TableHeader>
      <Table.TableRow>
        <Table.TableHead>ID</Table.TableHead>
        <Table.TableHead>Name</Table.TableHead>
        <Table.TableHead>Department</Table.TableHead>
        <Table.TableHead>Section</Table.TableHead>
        <Table.TableHead>Position</Table.TableHead>
        <Table.TableHead>Joining Date</Table.TableHead>
        <Table.TableHead align="right">Status</Table.TableHead>
      </Table.TableRow>
    </Table.TableHeader>
    <Table.TableBody>
      {#each paginatedItems as employee}
        <Table.TableRow>
          <Table.TableCell>{employee.id}</Table.TableCell>
          <Table.TableCell>{employee.name}</Table.TableCell>
          <Table.TableCell>{employee.department}</Table.TableCell>
          <Table.TableCell>{employee.section}</Table.TableCell>
          <Table.TableCell>{employee.position}</Table.TableCell>
          <Table.TableCell>{employee.joining_date}</Table.TableCell>
          <Table.TableCell align="right">{employee.status}</Table.TableCell>
        </Table.TableRow>
      {/each}
    </Table.TableBody>
  </Table.Root>
</Pagination>
