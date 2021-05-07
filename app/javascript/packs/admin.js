import $ from 'jquery';
import select2 from 'select2';
import 'select2/dist/css/select2.css';


$( document ).on('turbolinks:load', function() {
    if($(".nested-fields").length===1) $(".remove-sales-rep-link").remove();
    if ($("#sales-rep-option").is(":checked")){
        $(".all_suppliers").slideDown("slow")
    }
    $("#sales-rep-option").on("click",(e) =>{
        e.target.checked ? $(".all_suppliers").slideDown("slow") : $(".all_suppliers").slideUp("slow")
    })


    $(document).ready(function() {
        $('.search-prod-cat').select2()
    });
    $('.custom-file-input').change(function(e){
        var fileName = e.target.files[0].name;
        $('.custom-file-label').html(fileName.substr(0,20));
    });
    if ($("#product_published").is(":checked")){
        $(".qr-container").slideDown("slow")
    }
    $("#product_published").change((e) => {
        if (e.target.checked)
            $(".qr-container").slideDown("slow")
        else
            $(".qr-container").slideUp("slow")
    })


})
