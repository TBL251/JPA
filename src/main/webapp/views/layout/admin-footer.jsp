  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(() => {'use strict';const f=document.querySelectorAll('.needs-validation');
Array.from(f).forEach(form=>form.addEventListener('submit',e=>{
if(!form.checkValidity()){e.preventDefault();e.stopPropagation()}
form.classList.add('was-validated')},false))})()
</script>
</body>
</html>
