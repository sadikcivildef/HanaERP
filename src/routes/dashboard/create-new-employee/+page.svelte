<script lang="ts">
  import { goto } from "$app/navigation";
  import Button from "$lib/assets/ui/components/button.svelte";
  import TopNav from "../ui/top-nav.svelte";
  import { onMount } from "svelte";
  import { startLoading } from "$lib/stores/loading";
  import Body from "../ui/body.svelte";
  import Icon from "@iconify/svelte";
  import Input from "$lib/assets/ui/components/input.svelte";
  import RadioGroup from "$lib/assets/ui/components/radio-group.svelte";
  import InputSelect from "$lib/assets/ui/components/input-select.svelte";

  onMount(() => startLoading());

  // ✅ STEP STATE
  let currentStep = $state(1);

  function nextStep() {
    if (currentStep < 4) currentStep++;
  }

  function prevStep() {
    if (currentStep > 1) currentStep--;
  }

  interface Item {
    id: number;
    text: string;
  }

  // ✅ OPTIONS
  const genderOptions = {
    male: "Male",
    female: "Female",
    other: "Other",
  };

  const bloodGroupOptions = {
    a_positive: "A+",
    a_negative: "A-",
    b_positive: "B+",
    b_negative: "B-",
    ab_positive: "AB+",
    ab_negative: "AB-",
    o_positive: "O+",
    o_negative: "O-",
  };

  const employmentTypeOptions = [
    { id: 1, text: "Permanent" },
    { id: 2, text: "Contract" },
  ];

  const departmentOptions = [
    { id: 1, text: "HR" },
    { id: 2, text: "Engineering" },
  ];

  const sectionOptions = [
    { id: 1, text: "Recruitment" },
    { id: 2, text: "Payroll" },
  ];

  // ✅ STATE
  let userGender = $state(null);
  let userBloodGroup = $state(null);
  let employeeType = $state<Item | undefined>(undefined);
  let department = $state<Item | undefined>(undefined);
  let section = $state<Item | undefined>(undefined);
</script>

<TopNav>
  <div>Create New Employee</div>
  <div class="flex gap-3 items-center">
    <Button>Save</Button>
    <Button variant="outline" onclick={() => goto("/dashboard/people")}
      >Cancel</Button
    >
  </div>
</TopNav>
<Body>
<div class="flex justify-center gap-10 py-6">
  {#each [1,2,3,4] as step}
    <div class="flex flex-col items-center">
      <div class={`h-10 w-10 flex items-center justify-center rounded-xl
        ${currentStep >= step ? 'bg-primary text-white' : 'text-gray-300 border'}`}>
        
        <Icon icon={currentStep > step ? "tabler:check" : "tabler:player-stop"} />
      </div>
      <div>Step {step}</div>
    </div>
  {/each}
</div>







  <div class="flex justify-center items-center gap-30">
    <div class="flex flex-col gap-1 items-center">
      <button
        class="bg-primary h-10 w-10 rounded-xl items-center justify-center text-white flex"
      >
        <Icon icon="tabler:check" width="28" height="28" />
      </button>
      <div class="">Step 1</div>
      <div class="text-sm text-gray-500">Personal Information</div>
    </div>
    <div class="flex flex-col gap-1 items-center">
      <button
        class="bg-primary ring-primary/15 ring-4 h-10 w-10 rounded-xl items-center justify-center text-white flex"
      >
        <Icon icon="tabler:player-stop" width="28" height="28" />
      </button>
      <div class="">Step 2</div>
      <div class="text-sm text-gray-500">Employee Details</div>
    </div>
    <div class="flex flex-col gap-1 items-center">
      <button class="h-10 w-10">
        <div
          class="h-full w-full outline-2 rounded-xl items-center justify-center text-gray-300 flex"
        >
          <Icon icon="tabler:player-stop" width="28" height="28" />
        </div>
      </button>
      <div class="">Step 3</div>
      <div class="text-sm text-gray-500">Compensation & Bank</div>
    </div>

    <!-- <button class="w-24 h-24 rounded-full bg-gray-200 flex items-center justify-center text-gray-500">
            <Icon icon="mdi:camera" width="24" height="24" />
        </button> -->
  </div>
  <div class="flex flex-col py-6 gap-8">
    <div class="border-b border-gray-100 pb-4">
      <h2 class="text-2xl font-semibold text-gray-800">Personal Information</h2>
      <p class="text-sm text-gray-500 mt-1">
        Please ensure all details match your official documents.
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-5">
      <Input
        name="employeeId"
        label="Employee ID"
        placeholder="e.g. EMP-10293"
      />

      <Input name="fullName" label="Full Name" placeholder="John Doe" />

      <Input
        name="email"
        label="Email Address"
        type="email"
        placeholder="name@company.com"
      />

      <Input name="phone" label="Phone Number" placeholder="+880 1XXX-XXXXXX" />

      <Input
        name="dateOfBirth"
        label="Date of Birth"
        type="date"
        placeholder="Select date of birth"
      />

      <RadioGroup
        label="Gender"
        name="user-gender"
        options={genderOptions}
        bind:selectedOption={userGender}
      />

      <div class="md:col-span-2 my-2 border-t border-gray-50"></div>
      <Input
        name="idNumber"
        label="NID Number"
        placeholder="13-digit or 17-digit NID"
      />

      <Input
        name="passportNumber"
        label="Passport Number"
        placeholder="Enter passport number"
      />

      <RadioGroup
        label="Blood Group"
        name="user-blood-group"
        options={bloodGroupOptions}
        bind:selectedOption={userBloodGroup}
      />

      <Input name="religion" label="Religion" placeholder="Select religion" />

      <div class="md:col-span-2 my-2 border-t border-gray-50"></div>
      <Input
        name="fatherName"
        label="Father's Name"
        placeholder="Father's full name"
      />
      <Input
        name="motherName"
        label="Mother's Name"
        placeholder="Mother's full name"
      />

      <div class="md:col-span-2">
        <Input
          name="address"
          label="Permanent Address"
          placeholder="Street, House, Area, City"
        />
      </div>
    </div>

    <div class="flex justify-end gap-3 pt-6 border-t border-gray-100">
      <Button variant="outline" onclick={() => goto("/dashboard/people")}
        >Cancel</Button
      >
      <Button>Next</Button>
    </div>
  </div>

  <div class="flex flex-col py-6 gap-8">
    <div class="border-b border-gray-100 pb-4">
      <h2 class="text-2xl font-semibold text-gray-800">Employee Details</h2>
      <p class="text-sm text-gray-500 mt-1">
        Please ensure all details match your official documents.
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-5">
      <Input
        name="joiningDate"
        label="Joining Date"
        placeholder="Select joining date"
        type="date"
      />

      <InputSelect
        variant="primary"
        label="Employee Type"
        items={employmentTypeOptions}
        bind:selected={employeeType}
      />

      <InputSelect
        variant="primary"
        label="Department"
        items={departmentOptions}
        bind:selected={department}
      />

      <InputSelect
        variant="primary"
        label="Section"
        items={sectionOptions}
        bind:selected={section}
      />

      <Input
        name="dateOfBirth"
        label="Date of Birth"
        type="date"
        placeholder="Select date of birth"
      />

      <RadioGroup
        label="Gender"
        name="user-gender"
        options={genderOptions}
        bind:selectedOption={userGender}
      />

      <div class="md:col-span-2 my-2 border-t border-gray-50"></div>
      <Input
        name="idNumber"
        label="NID Number"
        placeholder="13-digit or 17-digit NID"
      />

      <Input
        name="passportNumber"
        label="Passport Number"
        placeholder="Enter passport number"
      />

      <RadioGroup
        label="Blood Group"
        name="user-blood-group"
        options={bloodGroupOptions}
        bind:selectedOption={userBloodGroup}
      />

      <Input name="religion" label="Religion" placeholder="Select religion" />

      <div class="md:col-span-2 my-2 border-t border-gray-50"></div>
      <Input
        name="fatherName"
        label="Father's Name"
        placeholder="Father's full name"
      />
      <Input
        name="motherName"
        label="Mother's Name"
        placeholder="Mother's full name"
      />

      <div class="md:col-span-2">
        <Input
          name="address"
          label="Permanent Address"
          placeholder="Street, House, Area, City"
        />
      </div>
    </div>

    <div class="flex justify-end gap-3 pt-6 border-t border-gray-100">
      <Button variant="outline" onclick={() => goto("/dashboard/people")}
        >Cancel</Button
      >
      <Button>Next</Button>
    </div>
  </div>
</Body>
