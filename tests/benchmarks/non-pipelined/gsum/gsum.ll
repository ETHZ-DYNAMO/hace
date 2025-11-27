; ModuleID = 'gsum.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP19\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP39\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP40\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind
define i32 @gsum(i32* nocapture readonly %a) #0 {
  br label %1

; <label>:1                                       ; preds = %10, %0
  %s.02 = phi i32 [ 0, %0 ], [ %s.1, %10 ]
  %i.01 = phi i32 [ 0, %0 ], [ %11, %10 ]
  %scevgep = getelementptr i32, i32* %a, i32 %i.01
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0)) #3
  %2 = load i32, i32* %scevgep, align 4
  %3 = icmp sgt i32 %2, -1
  br i1 %3, label %4, label %10

; <label>:4                                       ; preds = %1
  %5 = mul nsw i32 %2, %2
  %6 = mul nsw i32 %5, %2
  %7 = mul nsw i32 %6, %2
  %8 = mul nsw i32 %7, %2
  %9 = add nsw i32 %s.02, %8
  br label %10

; <label>:10                                      ; preds = %4, %1
  %s.1 = phi i32 [ %9, %4 ], [ %s.02, %1 ]
  %11 = add nsw i32 %i.01, 1
  %exitcond = icmp eq i32 %11, 1000
  br i1 %exitcond, label %12, label %1

; <label>:12                                      ; preds = %10
  %s.1.lcssa = phi i32 [ %s.1, %10 ]
  ret i32 %s.1.lcssa
}

;declare void @__legup_label(i8*) #1


attributes #0 = { noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin nounwind }
attributes #4 = { nobuiltin }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!legup.pipeline = !{!1}

!0 =  !{ !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
!1 =  !{ !"II",  !"1"}
!2 =  !{ !"1"}
!3 =  !{ !"0"}
!4 =  !{ !"32"}
!5 =  !{ !"33"}
!6 =  !{ !"34"}
!7 =  !{ !"35"}
!8 =  !{ !"1000"}
!9 =  !{ !"LOOP40"}
