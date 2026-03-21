// src/routes/demo/better-auth/login/+page.svelte
<script lang='ts'>
	import { enhance } from '$app/forms';
	import type { ActionData } from './$types';

	let { form }: { form: ActionData } = $props();
</script>

<h1 class="text-center font-mono text-3xl mb-10">Login</h1>
<form class="flex flex-col gap-10 justify-center items-center" method="post" action="?/signInEmail" use:enhance>
<div class="flex gap-6 w-full max-w-sm">
		<label>
		Email
		<input type="email" name="email" class="mt-1 px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
	</label>
	<label>
		Password
		<input type="password" name="password" class="mt-1 px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
	</label>
</div>
For registration, please provide your name and company ID:
<div class="flex gap-6">
		<label>
		Name
		<input name="name" class="mt-1 px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
	</label>
		<label>
		Company ID
		<input name="companyId" class="mt-1 px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
	</label>
</div>
	<button class="bg-blue-600 w-50 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Login</button>
	<button formaction="?/signUpEmail" class="bg-blue-600 w-50 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">Register</button>
</form>
<p class="text-red-500">{form?.message ?? ''}</p>
