<script>
  import Button from "$lib/assets/ui/components/button.svelte";
  import Header from "$lib/assets/ui/sections/header.svelte";
  import Icon from "@iconify/svelte";
</script>

<Header />

<div
  class="min-h-[calc(100vh-4.5rem)] py-4 flex items-center justify-center bg-[url(bg.svg)] bg-cover"
>
  <div
    class="flex h-130 border border-primary/30 rounded-2xl shadow-lg overflow-hidden"
  >
    <div class="flex flex-col items-center justify-center px-10 gap-6 bg-white">
      <div class=" text-center">
        <div class="text-2xl text-primary font-semibold">
          Login to your account
        </div>
        <div class="text-gray-400 text-sm">
          Enter your email below to login to your account
        </div>
      </div>
      <form action="" class="flex flex-col items-center gap-6">
        <label class="flex flex-col gap-1 w-80">
          <div class="text-sm">Email</div>
          <input
            class="px-4 py-1 rounded-md shadow-xs border border-gray-300 outline-none ring-0 ring-primary/20 focus:border-primary/70 focus:ring-3 transition-all ease-in-out"
            type="text"
          />
        </label>
        <label class="flex flex-col gap-1 w-80">
          <div class="text-sm">Password</div>
          <input
            class="px-4 py-1 rounded-md shadow-xs border border-gray-300 outline-none ring-0 ring-primary/20 focus:border-primary/70 focus:ring-3 transition-all ease-in-out"
            type="password"
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
        <div class="text-sm text-gray-500 text-center w-full">Don't have an account? <a href="/signup" class="hover:underline hover:text-primary">Sign up</a></div>
      </div>
    </div>
  </div>
</div>
