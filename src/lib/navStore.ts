// src/lib/navStore.ts
import { writable } from 'svelte/store';

// This is your "own title" that you can change manually
export const navTitle = writable("Dashboard");

export const navBtn = writable("");
export const navBtnLink = writable("");