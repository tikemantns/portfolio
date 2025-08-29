const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

async function generateResumePDF() {
  let browser;
  
  try {
    console.log('Starting PDF generation...');
    
    // Launch browser
    browser = await puppeteer.launch({
      headless: 'new',
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    
    const page = await browser.newPage();
    
    // Set the page to A4 size
    await page.setViewport({ width: 1200, height: 1600 });
    
    // Load the HTML resume
    const htmlPath = path.join(__dirname, 'resume.html');
    const htmlContent = fs.readFileSync(htmlPath, 'utf8');
    
    await page.setContent(htmlContent, {
      waitUntil: 'networkidle0'
    });
    
    // Generate PDF with high quality settings
    const pdfBuffer = await page.pdf({
      format: 'A4',
      printBackground: true,
      margin: {
        top: '0.5in',
        right: '0.5in',
        bottom: '0.5in',
        left: '0.5in'
      },
      preferCSSPageSize: true,
      displayHeaderFooter: false
    });
    
    // Save the PDF
    const outputPath = path.join(__dirname, 'resume.pdf');
    fs.writeFileSync(outputPath, pdfBuffer);
    
    console.log('✅ PDF resume generated successfully!');
    console.log(`📄 File saved as: ${outputPath}`);
    
  } catch (error) {
    console.error('❌ Error generating PDF:', error);
    process.exit(1);
  } finally {
    if (browser) {
      await browser.close();
    }
  }
}

// Run the generator
generateResumePDF();
