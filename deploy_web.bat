@echo off
setlocal

:: Set base href for GitHub Pages
set BASE_HREF=/wrixl-frontend-web/

:: Step 1: Checkout main and build
echo Cleaning and building Flutter web app...
git checkout main
flutter clean
flutter pub get
flutter build web --base-href "%BASE_HREF%"

:: Step 2: Copy build to temp folder
echo Backing up build\web\ to temp_deploy\
rmdir /s /q temp_deploy > nul 2>&1
mkdir temp_deploy
xcopy build\web\*.* temp_deploy\ /E /H /Y > nul

:: Step 3: Switch to gh-pages and reset it
echo Resetting gh-pages branch...
git branch -D gh-pages
git checkout --orphan gh-pages
git rm -rf .

:: Step 4: Copy temp_deploy\ contents into root
echo Copying deploy contents into gh-pages...
xcopy temp_deploy\*.* . /E /H /Y > nul

:: Step 5: Commit and push
echo Committing and pushing to gh-pages...
git add .
git commit -m "Deploy Flutter Web to GitHub Pages"
git push origin gh-pages --force

:: Step 6: Clean up
rmdir /s /q temp_deploy

:: Step 7: Return to main
echo Returning to main branch...
git checkout main

echo.
echo ✅ Deployment complete! Visit:
echo https://wrixl.github.io/wrixl-frontend-web/
echo.

pause
endlocal
