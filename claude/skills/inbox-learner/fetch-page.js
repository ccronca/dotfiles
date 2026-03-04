#!/usr/bin/env node

/**
 * Fetch JavaScript-rendered page content using Puppeteer (with sandbox enabled)
 * Usage: node fetch-page.js <url>
 */

const url = process.argv[2];

if (!url) {
  console.error('Usage: node fetch-page.js <url>');
  process.exit(1);
}

(async () => {
  let browser;
  try {
    const puppeteer = require('puppeteer');

    browser = await puppeteer.launch({
      headless: 'new',
      // Sandbox enabled by default - only add minimal required args
      args: [
        '--disable-dev-shm-usage',  // Avoid /dev/shm issues
        '--disable-gpu'              // Not needed for headless
      ]
    });

    const page = await browser.newPage();

    // Puppeteer automatically sets a realistic Chrome user agent
    // No need to override unless a specific site requires it

    await page.goto(url, {
      waitUntil: 'networkidle2',
      timeout: 30000
    });

    // Extract text content from the page
    const content = await page.evaluate(() => document.body.innerText);

    console.log(content);

  } catch (error) {
    console.error('Error fetching page:', error.message);
    process.exit(1);
  } finally {
    if (browser) await browser.close();
  }
})();
