// deploy_web.bat

@echo off
setlocal

:: Step 1: Set repo-specific base href
set BASE_HREF=/wrixl-frontend-web/

:: Step 2: Checkout main branch and rebuild
echo Cleaning and building Flutter web app...
git checkout main
flutter clean
flutter pub get
flutter build web --base-href "%BASE_HREF%"

:: Step 3: Delete and recreate gh-pages branch
echo Resetting gh-pages branch...
git branch -D gh-pages
git checkout --orphan gh-pages
git rm -rf .

:: Step 4: Copy web build contents
echo Copying build/web output...
xcopy build\web\*.* . /E /H /Y > nul

:: Step 5: Commit and force push to GitHub
echo Committing and pushing to gh-pages...
git add .
git commit -m "Deploy Flutter Web to GitHub Pages"
git push origin gh-pages --force

echo.
echo Deployment complete! Visit:
echo https://wrixl.github.io/wrixl-frontend-web/
echo.

pause

git checkout main
flutter clean
endlocal
