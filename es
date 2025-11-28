
[1mFrom:[0m /rails/app/controllers/students/checkouts_controller.rb:7 Students::CheckoutsController#create:

     [1;34m3[0m: [32mdef[0m [1;34mcreate[0m
     [1;34m4[0m:   [32mbegin[0m
     [1;34m5[0m:     courses = [1;34;4mCourse[0m.where([35mid[0m: params[[33m:course_ids[0m])
     [1;34m6[0m:     binding.pry
 =>  [1;34m7[0m:     line_items = courses.map [32mdo[0m |course|
     [1;34m8[0m:       {
     [1;34m9[0m:         [31m[1;31m"[0m[31mprice_data[1;31m"[0m[31m[0m => {
    [1;34m10[0m:           [31m[1;31m"[0m[31mcurrency[1;31m"[0m[31m[0m => [31m[1;31m"[0m[31minr[1;31m"[0m[31m[0m,
    [1;34m11[0m:           [31m[1;31m"[0m[31mproduct_data[1;31m"[0m[31m[0m => { [31m[1;31m"[0m[31mname[1;31m"[0m[31m[0m => course.title },
    [1;34m12[0m:           [31m[1;31m"[0m[31munit_amount[1;31m"[0m[31m[0m => (course.amount.to_i * [1;34m100[0m)
    [1;34m13[0m:         },
    [1;34m14[0m:         [31m[1;31m"[0m[31mquantity[1;31m"[0m[31m[0m => [1;34m1[0m
    [1;34m15[0m:       }
    [1;34m16[0m:     [32mend[0m
    [1;34m17[0m:     session = [1;34;4mStripe[0m::[1;34;4mCheckout[0m::[1;34;4mSession[0m.create(
    [1;34m18[0m:       [35mpayment_method_types[0m: [[31m[1;31m"[0m[31mcard[1;31m"[0m[31m[0m],
    [1;34m19[0m:       [35mline_items[0m: line_items,
    [1;34m20[0m:       [35mmode[0m: [31m[1;31m"[0m[31mpayment[1;31m"[0m[31m[0m,
    [1;34m21[0m:       [35msuccess_url[0m: [31m[1;31m"[0m[31m#{root_url}[0m[31mstudents/checkouts/success?course_ids=#{courses.pluck(:id).join([1;31m'[0m[31m,[1;31m'[0m[31m[0m[31m)}[0m[31m[1;31m"[0m[31m[0m,
    [1;34m22[0m:       [35mcancel_url[0m: [31m[1;31m"[0m[31m#{root_url}[0m[31mstudents/cart[1;31m"[0m[31m[0m
    [1;34m23[0m:     )
    [1;34m24[0m: 
    [1;34m25[0m:     render [35mjson[0m: { [35mid[0m: session.id }
    [1;34m26[0m: 
    [1;34m27[0m:   [32mrescue[0m => e
    [1;34m28[0m:     render [35mjson[0m: { [35merror[0m: e.message }, [35mstatus[0m: [1;34m422[0m
    [1;34m29[0m:   [32mend[0m
    [1;34m30[0m: [32mend[0m

