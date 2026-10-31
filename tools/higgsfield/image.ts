// Generate images with Higgsfield Soul 2 and save them to art/raw/ for the palette-lock pipeline.
//
//   npm run image -- --name gas-station --prompt "..." [--aspect 16:9] [--resolution 1080p]
//                    [--batch 1|4] [--seed N] [--enhance]
//
// Billable. Credentials come from ../../.env.local (HF_CREDENTIALS) and are never printed.

import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { config, higgsfield } from '@higgsfield/client/v2';
import type { V2Response } from '@higgsfield/client/v2';

const MODEL = 'higgsfield-ai/soul/v2/standard';
const OUT_DIR = join(dirname(fileURLToPath(import.meta.url)), '..', '..', 'art', 'raw');

function arg(name: string): string | undefined {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : undefined;
}

const prompt = arg('prompt');
const name = arg('name') ?? 'image';
if (!prompt) {
  console.error('Usage: npm run image -- --name <file-stem> --prompt "<prompt>" [--aspect 16:9] [--resolution 1080p] [--batch 1] [--seed N] [--enhance]');
  process.exit(1);
}
if (!process.env.HF_CREDENTIALS) {
  console.error('HF_CREDENTIALS is not set. Add it to .env.local at the project root (key-id:key-secret).');
  process.exit(1);
}
config({ credentials: process.env.HF_CREDENTIALS });

async function main() {
  const input: Record<string, unknown> = {
    prompt,
    aspect_ratio: arg('aspect') ?? '16:9',
    resolution: arg('resolution') ?? '1080p',
    batch_size: Number(arg('batch') ?? 1),
    // Prompt enhancement tends to add photographic detail; off unless asked for.
    enhance_prompt: process.argv.includes('--enhance'),
  };
  if (arg('seed')) input.seed = Number(arg('seed'));

  console.log(`Submitting to ${MODEL}...`);
  const result: V2Response = await higgsfield.subscribe(MODEL, { input, withPolling: true });
  const status: string = result.status;
  if (status !== 'completed') {
    console.error(status === 'nsfw' ? 'Rejected by moderation (credits refunded).' : `Generation ended with status "${status}".`);
    process.exit(1);
  }
  const urls = (result.images ?? []).map((i) => i.url).filter(Boolean);
  if (!urls.length) {
    console.error('Generation reported completed but returned no images.');
    process.exit(1);
  }
  await mkdir(OUT_DIR, { recursive: true });
  for (const [i, url] of urls.entries()) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`download failed (${res.status}) for ${url}`);
    const ext = (res.headers.get('content-type') ?? '').includes('png') ? 'png' : (res.headers.get('content-type') ?? '').includes('webp') ? 'webp' : 'jpg';
    const file = join(OUT_DIR, `${name}${urls.length > 1 ? `-${i + 1}` : ''}.${ext}`);
    await writeFile(file, Buffer.from(await res.arrayBuffer()));
    console.log(`Saved ${file}`);
    console.log(`  from ${url}`);
  }
}

main().catch((err: unknown) => {
  const e = err as { name?: string; message?: string };
  console.error(`Request failed: ${e.name ?? 'Error'}: ${e.message ?? String(err)}`);
  process.exit(1);
});
