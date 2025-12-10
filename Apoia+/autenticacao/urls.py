from django.urls import path
from .views import LoginView, LogoutView, CadastroView, ListaOngsView

urlpatterns = [
    # MUDANÇA AQUI: de 'registro' para 'cadastro'
    path('cadastro/', CadastroView.as_view(), name='cadastro'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('ongs/', ListaOngsView.as_view(), name='lista-ongs'),
]