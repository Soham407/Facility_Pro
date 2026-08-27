import { test as setup, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

const authFile = path.join(__dirname, '.auth/user.json');

setup('authenticate', async ({ page }) => {
  // Try to create .auth directory if it doesn't exist
  fs.mkdirSync(path.join(__dirname, '.auth'), { recursive: true });
  
  await page.goto('/login');
  
  // Use generic selectors that should work or adapt them for the app
  // Wait for the email field
  await page.getByPlaceholder('name@company.com').fill('supplier@test.com');
  await page.locator('input[type="password"]').fill('Test@1234'); // Adjust to your actual test user password
  
  await page.getByRole('button', { name: /Enter Workspace/i }).click();
  
  // Wait until the page receives the cookies/tokens
  await page.waitForURL(/.*(dashboard|admin|tickets|supplier).*/, { timeout: 10000 }).catch(() => {});
  
  // Save storage state
  await page.context().storageState({ path: authFile });
});
