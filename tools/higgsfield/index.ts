// Example: generate a video with Seedance 2.5 through the Higgsfield SDK and print its URL.
// Run with `npm run example` (loads HF_CREDENTIALS from ../../.env.local). This is a billable request.

import { config, higgsfield } from '@higgsfield/client/v2';
import type { V2Response } from '@higgsfield/client/v2';

const MODEL = 'bytedance/seedance-2.5/text-to-video';

if (!process.env.HF_CREDENTIALS) {
  console.error('HF_CREDENTIALS is not set. Add it to .env.local at the project root (key-id:key-secret).');
  process.exit(1);
}

config({ credentials: process.env.HF_CREDENTIALS });

async function main() {
  console.log(`Submitting to ${MODEL}...`);
  const result: V2Response = await higgsfield.subscribe(MODEL, {
    input: {
      prompt: 'A cinematic scene at sunset',
      duration: 5,
      resolution: '720p',
      aspect_ratio: '16:9',
    },
    withPolling: true,
  });

  // V2 statuses: queued | in_progress | completed | failed | nsfw. Anything else (e.g. a
  // request canceled from the console) falls through to the default branch.
  const status: string = result.status;
  const url = result.video?.url;
  switch (status) {
    case 'completed':
      if (!url) {
        console.error('Generation reported completed but returned no video URL.');
        process.exit(1);
      }
      console.log(`Completed. Video URL: ${url}`);
      break;
    case 'nsfw':
      console.error('Rejected by moderation (credits refunded). No video.');
      process.exit(1);
      break;
    case 'failed':
      console.error('Generation failed (credits refunded). No video.');
      process.exit(1);
      break;
    case 'canceled':
    case 'cancelled':
      console.error('Generation was canceled. No video.');
      process.exit(1);
      break;
    default:
      console.error(`Generation ended with status "${status}". No video.`);
      process.exit(1);
  }
}

main().catch((err: unknown) => {
  // Report the error type and message only; never the request (it carries credentials).
  const e = err as { name?: string; message?: string };
  console.error(`Request failed: ${e.name ?? 'Error'}: ${e.message ?? String(err)}`);
  process.exit(1);
});
