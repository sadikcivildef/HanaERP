import { writable } from 'svelte/store';

export const loadingStore = writable({
  isLoading: false,
  progress: 0
});

export function startLoading() {
  loadingStore.set({ isLoading: true, progress: 0 });
  
  const interval = setInterval(() => {
    loadingStore.update(state => {
      const newProgress = state.progress + Math.random() * 15;
      if (newProgress >= 100) {
        clearInterval(interval);
        return { isLoading: false, progress: 100 };
      }
      return { ...state, progress: newProgress };
    });
  }, 100);
}

export function stopLoading() {
  loadingStore.set({ isLoading: false, progress: 100 });
}