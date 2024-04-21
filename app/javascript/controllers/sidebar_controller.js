// app/javascript/controllers/sidebar_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["panel"]
  
    connect() {
      this.handleClickOutside = this.handleClickOutside.bind(this);
    }
  
    open() {
      this.panelTarget.classList.add('active');
      document.body.classList.add('modal-open');
      // Añade el listener para clics fuera del panel solo cuando el panel esté abierto
      document.addEventListener('click', this.handleClickOutside, true);
    }
  
    close() {
      this.panelTarget.classList.remove('active');
      document.body.classList.remove('modal-open');
      document.removeEventListener('click', this.handleClickOutside, true);
    }
  
    handleClickOutside(event) {
      // Verifica si el clic fue fuera del elemento específico
      if (!this.panelTarget.contains(event.target)) {
        this.close();
      }
    }
  }