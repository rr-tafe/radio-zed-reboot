// Generate an image guided by a reference image with Ideogram 4.0 on Higgsfield, saving it to
// art/raw/. The reference (e.g. a floor cut from an original backdrop by tools/art_reference.py)
// is uploaded to Higgsfield's CDN first.
//
//   npm run reference -- --ref ../../art/ref/tower-middle-floor.png --name <stem>
//                        --prompt "..." --aspect none [--weight 1-100] [--speed QUALITY]
//
// Note: "--aspect 3:1" and "--weight" made requests fail (refunded); "--aspect none" works.
//
// Billable. Credentials come from ../../.env.local (HF_CREDENTIALS) and are never printed.

import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { HiggsfieldClient } from '@higgsfield/client';
import { config, higgsfield } from '@higgsfield/client/v2';
import type { V2Response } from '@higgsfield/client/v2';

const MODEL = 'ideogram/v4.0';
const HERE = dirname(fileURLToPath(import.meta.url));
const OUT_DIR = join(HERE, '..', '..', 'art', 'raw');

function arg(name: string): string | undefined {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : undefined;
}

const prompt = arg('prompt');
const ref = arg('ref');
const name = arg('name') ?? 'reference';
if (!prompt || !ref) {
  console.error('Usage: npm run reference -- --ref <png> --name <stem> --prompt "<prompt>" [--weight 1-100] [--aspect 3:1] [--speed TURBO|DEFAULT|QUALITY]');
  process.exit(1);
}
const creds = process.env.HF_CREDENTIALS;
if (!creds || !creds.includes(':')) {
  console.error('HF_CREDENTIALS is not set (key-id:key-secret) in .env.local at the project root.');
  process.exit(1);
}
const [apiKey, apiSecret] = [creds.slice(0, creds.indexOf(':')), creds.slice(creds.indexOf(':') + 1)];
config({ credentials: creds });

/**
 * Upload to Higgsfield's CDN. The SDK's uploadImage() (0.2.6) fails with S3
 * "SignatureDoesNotMatch": the presigned URL also signs an x-amz-tagging header, which the API
 * returns in `upload_headers` but the SDK doesn't send. Request the link through the SDK's own
 * authenticated client and PUT with exactly the headers the API asks for.
 */
async function uploadReference(data: Buffer): Promise<string> {
  const client = new HiggsfieldClient({ apiKey, apiSecret }) as unknown as {
    client: { post(path: string, body: unknown): Promise<{ data: { upload_url: string; public_url: string; upload_headers?: Record<string, string> } }> };
  };
  const { data: link } = await client.client.post('/files/generate-upload-url', { content_type: 'image/png' });
  const res = await fetch(link.upload_url, { method: 'PUT', body: data, headers: link.upload_headers ?? { 'Content-Type': 'image/png' } });
  if (!res.ok) throw new Error(`reference upload failed: HTTP ${res.status} ${(await res.text()).slice(0, 200)}`);
  return link.public_url;
}

async function main() {
  // The v1 client provides the CDN upload link; the v2 client runs the generation.
  const imageUrl = await uploadReference(await readFile(resolve(ref!)));
  console.log('Uploaded reference.');
  if (process.argv.includes('--upload-only')) return;

  const input: Record<string, unknown> = { prompt, image_url: imageUrl };
  // Optional: pass "--aspect none" / leave --speed out to send only what's needed.
  const aspect = arg('aspect') ?? '3:1';
  if (aspect !== 'none') input.aspect_ratio = aspect;
  if (arg('speed')) input.rendering_speed = arg('speed');
  if (arg('weight')) input.image_weight = Number(arg('weight'));

  console.log(`Submitting to ${MODEL}...`);
  const result: V2Response = await higgsfield.subscribe(MODEL, { input, withPolling: true });
  const status: string = result.status;
  if (status !== 'completed') {
    console.error(status === 'nsfw' ? 'Rejected by moderation (credits refunded).' : `Generation ended with status "${status}".`);
    console.error(`Result: ${JSON.stringify(result).slice(0, 600)}`);
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
    const type = res.headers.get('content-type') ?? '';
    const ext = type.includes('png') ? 'png' : type.includes('webp') ? 'webp' : 'jpg';
    const file = join(OUT_DIR, `${name}${urls.length > 1 ? `-${i + 1}` : ''}.${ext}`);
    await writeFile(file, Buffer.from(await res.arrayBuffer()));
    console.log(`Saved ${file}`);
  }
}

main().catch((err: unknown) => {
  const e = err as { name?: string; message?: string; response?: { status?: number; data?: unknown } };
  console.error(`Request failed: ${e.name ?? 'Error'}: ${e.message ?? String(err)}`);
  // The server's error body only (never the request, which carries credentials).
  if (e.response?.data) console.error(`Server said: ${JSON.stringify(e.response.data).slice(0, 400)}`);
  process.exit(1);
});
