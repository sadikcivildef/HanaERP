<script lang="ts">
  import { enhance } from "$app/forms";
  import type { ActionData } from "./$types";
  let { form }: { form: ActionData } = $props() ;
  import Button from "$lib/assets/ui/components/button.svelte";
  import Toast from "$lib/assets/ui/components/toast.svelte";
  import Header from "$lib/assets/ui/sections/header.svelte";
  import Icon from "@iconify/svelte";
  import { goto } from "$app/navigation";

  let showMessage = $state(false);
  let messageType = $state<"success" | "error">("success");
  let messageText = $state("");
  let isLoggingIn = $state(false);
  let hasInputError = $state(false);

  $effect(() => {
    hasInputError = !!form?.message && !form?.success;
    if (hasInputError) {
      showMessage = true;
      messageType = "error";
      messageText = form?.message ?? "Unknown login error";
      isLoggingIn = false;
    }

    if (form?.success) {
      goto("/dashboard");
    }
  });
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
        onsubmit={() => {
          isLoggingIn = true;
          showMessage = false;
          messageText = "";
        }}
        class="flex w-full flex-col items-center gap-6"
      >
        <label class="flex flex-col gap-1 w-full">
          <div class="text-sm">Email</div>
          <input
            class={`px-4 py-1 rounded-md shadow-xs border ${hasInputError ? "border-red-500/70 ring-red-500/20 focus:border-ring-red-500/70" : "border-gray-300 ring-primary/20 focus:border-primary/70"} outline-none ring-0 focus:ring-3 transition-all ease-in-out`}
            type="email"
            name="email"
          />
        </label>
        <label class="flex flex-col gap-1 w-full">
          <div class="text-sm">Password</div>
          <input
            class={`px-4 py-1 rounded-md shadow-xs border ${hasInputError ? "border-red-500/70 ring-red-500/20 focus:border-ring-red-500/70" : "border-gray-300 ring-primary/20 focus:border-primary/70"} outline-none ring-0 focus:ring-3 transition-all ease-in-out`}
            type="password"
            name="password"
          />
        </label>
        <Button className="w-full py-2 mt-2" type="submit">Login</Button>
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

<Toast bind:show={showMessage} type={messageType} message={messageText} />
