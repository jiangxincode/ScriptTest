:: This batch file clears the cache for Beyond Compare 4 and 5 by deleting the CacheID registry entries

reg delete "HKEY_CURRENT_USER\Software\Scooter Software\Beyond Compare 4" /v CacheID /f
reg delete "HKEY_CURRENT_USER\Software\Scooter Software\Beyond Compare 5" /v CacheID /f

pause