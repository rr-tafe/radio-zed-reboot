// Reboot-only options (not in the original), kept per browser.

const KEY = 'radiozed.settings.v1';

export const settings = {
  /** Let gameplay show more of the street on wide windows (the original was 640 px wide). */
  wide: false,
};

try {
  Object.assign(settings, JSON.parse(localStorage.getItem(KEY) ?? '{}'));
} catch {
  // Defaults.
}

export function toggleWide() {
  settings.wide = !settings.wide;
  try {
    localStorage.setItem(KEY, JSON.stringify(settings));
  } catch {
    // Not persisted.
  }
}
