const { chromium } = require('@playwright/test');
const fs = require('fs');
const path = require('path');

const users = [
  { role: 'super_admin', email: 'superadmin@test.com', path: '/settings/admins' },
  { role: 'admin', email: 'admin@test.com', path: '/inventory/purchase-orders' },
  { role: 'company_md', email: 'md@test.com', path: '/finance/buyer-billing' },
  { role: 'company_hod', email: 'hod@test.com', path: '/service-requests' },
  { role: 'account', email: 'account@test.com', path: '/finance/supplier-bills' },
  { role: 'buyer', email: 'buyer@test.com', path: '/buyer/requests' },
  { role: 'supplier', email: 'supplier@test.com', path: '/supplier/indents' },
  { role: 'delivery_agent', email: 'delivery@test.com', path: '/delivery' },
  { role: 'security_guard', email: 'guard@test.com', path: '/guard' },
  { role: 'security_supervisor', email: 'supervisor@test.com', path: '/hrms/attendance' },
  { role: 'society_manager', email: 'societymanager@test.com', path: '/society/visitors' },
  { role: 'field_technician', email: 'serviceboy@test.com', path: '/dashboard' },
  { role: 'resident', email: 'resident@test.com', path: '/society/my-flat' },
  { role: 'storekeeper', email: 'storekeeper@test.com', path: '/inventory/grn' },
  { role: 'site_supervisor', email: 'sitesupervisor@test.com', path: '/service-requests' },
  { role: 'ac_technician', email: 'actech@test.com', path: '/services/ac' },
  { role: 'pest_control_technician', email: 'pesttech@test.com', path: '/services/pest-control' }
];

const password = 'Test@1234';

async function main() {
  const browser = await chromium.launch({ headless: true });
  
  if (!fs.existsSync('.playwright-cli')) {
    fs.mkdirSync('.playwright-cli');
  }

  for (const user of users) {
    console.log(`Testing role: ${user.role}`);
    const context = await browser.newContext({ viewport: { width: 1280, height: 800 } });
    const page = await context.newPage();
    
    try {
      await page.goto('http://localhost:3000/login');
      await page.fill('input[type="email"]', user.email);
      await page.fill('input[type="password"]', password);
      await page.click('button[type="submit"]');
      
      // Wait for navigation after login
      await page.waitForURL('**/dashboard', { timeout: 10000 }).catch(() => {});
      
      // Navigate to allowed path
      await page.goto(`http://localhost:3000${user.path}`);
      
      // Wait a bit for data to load
      await page.waitForTimeout(2000);
      
      // Take screenshot
      await page.screenshot({ path: `.playwright-cli/desktop-${user.role}.png` });
      console.log(`Saved screenshot for ${user.role}`);
    } catch (e) {
      console.error(`Failed for ${user.role}: ${e.message}`);
    } finally {
      await context.close();
    }
  }

  await browser.close();
}

main().catch(console.error);
