from django.urls import path
from .views import LoginView, LogoutView, CadastroView


urlpatterns = [
    path('registro/', CadastroView.as_view(), name='registro'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
]