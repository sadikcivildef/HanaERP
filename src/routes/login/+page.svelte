<script lang="ts">
  import { enhance } from "$app/forms";
  import type { ActionData } from "./$types";
  let { form }: { form: ActionData } = $props() ;
  import Button from "$lib/assets/ui/components/button.svelte";
  import Header from "$lib/assets/ui/sections/header.svelte";
  import Icon from "@iconify/svelte";
  import { onDestroy } from "svelte";
  import { fade, fly } from "svelte/transition";

  let showMessage = $state(false);
  let timer: string | number | NodeJS.Timeout | undefined;

  $effect(() => {
    if (form?.message) {
      showMessage = true;

      clearTimeout(timer);
      timer = setTimeout(() => {
        showMessage = false;
      }, 10000);
    }
  });

  onDestroy(() => clearTimeout(timer));
</script>

<Header />

<div
  class="min-h-[calc(100vh-4.5rem)] py-4 flex items-center justify-center bg-[url('/bg.svg')] bg-cover"
>
  <div
    class="flex w-full max-w-sm h-125 border border-primary/30 rounded-2xl shadow-lg overflow-hidden mx-5"
  >
    <div
      class="flex flex-col w-full items-center justify-center px-6 sm:px-8 gap-6 bg-white/60 backdrop-blur-lg"
    >
      <div class=" text-center mb-1">
        <div class="text-2xl text-primary font-semibold">
          Login to your account
        </div>
        <div class="text-gray-400 text-sm">
          Enter your email below to login to your account
        </div>
      </div>
      <form
        method="post"
        action="?/signInEmail"
        use:enhance
        class="flex w-full flex-col items-center gap-6"
      >
        <label class="flex flex-col gap-1 w-full">
          <div class="text-sm">Email</div>
          <input
            class={`px-4 py-1 rounded-md shadow-xs border ${form?.message ? "border-red-500/70 ring-red-500/20 focus:border-ring-red-500/70" : "border-gray-300 ring-primary/20 focus:border-primary/70"}  outline-none ring-0  focus:ring-3 transition-all ease-in-out`}
            type="email"
            name="email"
          />
        </label>
        <label class="flex flex-col gap-1 w-full">
          <div class="text-sm">Password</div>
          <input
            class={`px-4 py-1 rounded-md shadow-xs border ${form?.message ? "border-red-500/70 ring-red-500/20 focus:border-ring-red-500/70" : "border-gray-300 ring-primary/20 focus:border-primary/70"}  outline-none ring-0  focus:ring-3 transition-all ease-in-out`}
            type="password"
            name="password"
          />
        </label>
        <Button className="w-full py-2 mt-2">Login</Button>
      </form>
      <div class="flex flex-col w-full gap-6">
        <div class="flex items-center w-full gap-1 text-sm text-gray-500">
          <hr class="flex-1 border-gray-200" />
          Or continue with
          <hr class="flex-1 border-gray-200" />
        </div>
        <Button
          variant="outline"
          className="w-full py-1.5 flex items-center justify-center gap-3"
          ><Icon icon="uim:google" width="18" height="18" /> Login with google</Button
        >
        <div class="text-sm text-gray-500 text-center w-full">
          Don't have an account? <a
            href="/signup"
            class="hover:underline hover:text-primary">Sign up</a
          >
        </div>
      </div>
    </div>
  </div>
</div>
{#if showMessage}
  <div class="fixed bottom-5 border border-gray-300 text-red-500 right-5 rounded-xl px-6 py-4 flex items-center gap-3 bg-white shadow-lg"  in:fly={{ x: 120, duration: 250 }} out:fly={{ x: -120, duration: 350 }}> 
    <Icon icon="wordpress:caution" width="24" height="24" /> <p >{form?.message}</p>
  </div>
{/if}
