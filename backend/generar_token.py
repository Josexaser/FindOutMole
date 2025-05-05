import jwt

payload = {"sub": "test_user", "exp": 1730000000}
token = jwt.encode(payload, "your-secret-key", algorithm="HS256")
print(token)