# Review Result
## Task
ID: AUTH-317
Context: Moving session storage to separate auth:session module, adding SessionManager and retrofit interceptor integration.
Overall Assessment
The solution is architecturally correct overall: separate module extracted, no direct UI → data dependencies, DI is used.
There is 1 critical comment on threading and 2 major ones on architectural coupling.
Status: ❌ Changes requested
## Architecture
✅ Session moved to auth:session
✅ SessionRepository interface is used
❌ Interceptor directly depends on SessionManagerImpl
⚠️ Dependency inversion principle violated in core:network
Problem:
AuthInterceptor accepts concrete implementation, not interface.
Risk:
Complicates testing and future implementation substitution.
Potential bugs
[Severity: Critical]
File: SessionManager.kt
Problem: token writing to SharedPreferences happens on main thread
Why: can cause lags during frequent token updates
Suggestion: use dispatcher IO
[Severity: Major]
File: AuthInterceptor.kt
Problem: if token is null — request goes without header
Why: can lead to 401 without explicit handling
Suggestion: add fail-fast or logging
Performance
Minor: token is read from SharedPreferences on every request
Suggestion: cache token in memory
Contracts and Compatibility
API not changed
Backward compatibility maintained
No migrations
Readability and Maintenance
[Severity: Minor]
File: SessionManagerImpl.kt
Problem: updateSession() method > 70 lines
Suggestion: extract mapping to separate mapper
## Tests
No token update test
No interceptor test with null token
Recommendation:
Add unit tests for:
SessionManager.updateSession()
AuthInterceptor.addHeader()