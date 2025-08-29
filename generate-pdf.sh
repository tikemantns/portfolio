#!/bin/bash

# Resume PDF Generation Script

echo "🚀 Starting Resume PDF Generation..."

# Check if we're on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📱 macOS detected - Using system Chrome for PDF generation..."
    
    # Check if Chrome is installed
    if [ -d "/Applications/Google Chrome.app" ]; then
        echo "✅ Chrome found, generating PDF..."
        
        # Get the absolute path to resume.html
        RESUME_PATH="$(pwd)/resume.html"
        PDF_PATH="$(pwd)/resume.pdf"
        
        # Use Chrome in headless mode to generate PDF
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
            --headless \
            --disable-gpu \
            --disable-software-rasterizer \
            --disable-dev-shm-usage \
            --no-sandbox \
            --print-to-pdf="$PDF_PATH" \
            --print-to-pdf-no-header \
            --run-all-compositor-stages-before-draw \
            --virtual-time-budget=5000 \
            "file://$RESUME_PATH"
        
        if [ -f "$PDF_PATH" ]; then
            echo "✅ PDF generated successfully: $PDF_PATH"
            echo "📄 File size: $(du -h "$PDF_PATH" | cut -f1)"
        else
            echo "❌ Failed to generate PDF"
            exit 1
        fi
    else
        echo "❌ Google Chrome not found. Please install Chrome or use manual method."
        echo "📖 Manual method: Open resume.html in your browser and use Cmd+P -> Save as PDF"
        exit 1
    fi
else
    echo "🖥️  Non-macOS system detected"
    echo "📖 Please open resume.html in your browser and use Ctrl+P -> Save as PDF"
fi

echo "🎉 Resume generation complete!"
