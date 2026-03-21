/**
 * Svelte 5 compatible Action to detect clicks outside
 * @param {HTMLDivElement} node
 * @param {{ (): boolean; (arg0: any): void; }} handler
 */
export function clickOutside(node, handler) {
  const handleClick = (/** @type {{ target: any; defaultPrevented: any; }} */ event) => {
    if (node && !node.contains(event.target) && !event.defaultPrevented) {
      // Call the function passed to the action
      if (handler) handler(event);
    }
  };

  document.addEventListener('click', handleClick, true);

  return {
    destroy() {
      document.removeEventListener('click', handleClick, true);
    }
  };
}