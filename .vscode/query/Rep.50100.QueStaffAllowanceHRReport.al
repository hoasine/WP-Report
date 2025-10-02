// query 50100 "QueStaffAllowanceHRReport"
// {
//     elements
//     {

//         dataitem(trans; "wpStaffAllowanceEntry")
//         {
//             filter(staffFilter; "Staff Card No.")
//             {
//             }

//             filter(DateFilter; Date)
//             {
//             }
//             column(TSE_Gross_Amount; "Gross Amount")
//             {
//                 Method = Sum;
//             }
//             column(TSE_Discount_Percen; "Discount %")
//             {
//                 Method = Sum;
//             }
//         }
//     }
// }

