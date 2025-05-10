from rest_framework.permissions import BasePermission

class IsAdminUser(BasePermission):
    """
    Allows access only to admin users.
    """
    def has_permission(self, request, view):
        return hasattr(request.user, "role") and request.user.role == "Admin"

# Alternative implementation for case-insensitive role checking
class IsAdminUserOnly(BasePermission):
    """
    Allows access only to admin users (case-insensitive role check).
    """
    def has_permission(self, request, view):
        return (
            request.user and 
            request.user.is_authenticated and 
            hasattr(request.user, "role") and 
            request.user.role.upper() == "ADMIN"
        )