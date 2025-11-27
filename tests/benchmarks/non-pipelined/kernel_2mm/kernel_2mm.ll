; ModuleID = 'kernel_2mm.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP16\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP24\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP28\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP48\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP51\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP52\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP64\00", align 1
@.str7 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str8 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind
define void @kernel_2mm(i32 %alpha, i32 %beta, i32* nocapture %tmp, i32* nocapture readonly %A, i32* nocapture readonly %B, i32* nocapture readonly %C, i32* nocapture %D) #0 {
  br label %1

; <label>:1                                       ; preds = %18, %0
  %i.08 = phi i32 [ 0, %0 ], [ %19, %18 ]
  %2 = mul i32 %i.08, 8
  br label %3

; <label>:3                                       ; preds = %16, %1
  %j.07 = phi i32 [ 0, %1 ], [ %17, %16 ]
  %4 = add i32 %2, %j.07
  %scevgep14 = getelementptr i32, i32* %tmp, i32 %4
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0)) #3
  %5 = load i32, i32* %scevgep14, align 4
  br label %6

; <label>:6                                       ; preds = %6, %3
  %x.06 = phi i32 [ %5, %3 ], [ %14, %6 ]
  %k.05 = phi i32 [ 0, %3 ], [ %15, %6 ]
  %7 = add i32 %2, %k.05
  %scevgep11 = getelementptr i32, i32* %A, i32 %7
  %8 = mul i32 %k.05, 8
  %9 = add i32 %j.07, %8
  %scevgep10 = getelementptr i32, i32* %B, i32 %9
  %10 = load i32, i32* %scevgep11, align 4
  %11 = mul nsw i32 %10, %alpha
  %12 = load i32, i32* %scevgep10, align 4
  %13 = mul nsw i32 %11, %12
  %14 = add nsw i32 %x.06, %13
  %15 = add nsw i32 %k.05, 1
  %exitcond14 = icmp eq i32 %15, 8
  br i1 %exitcond14, label %16, label %6

; <label>:16                                      ; preds = %6
  %.lcssa1 = phi i32 [ %14, %6 ]
  store i32 %.lcssa1, i32* %scevgep14, align 4
  %17 = add nsw i32 %j.07, 1
  %exitcond17 = icmp eq i32 %17, 8
  br i1 %exitcond17, label %18, label %3

; <label>:18                                      ; preds = %16
  %19 = add nsw i32 %i.08, 1
  %exitcond20 = icmp eq i32 %19, 8
  br i1 %exitcond20, label %.preheader.preheader.preheader, label %1

.preheader.preheader.preheader:                   ; preds = %18
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %.preheader, %.preheader.preheader.preheader
  %i.14 = phi i32 [ %36, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %20 = mul i32 %i.14, 8
  br label %21

; <label>:21                                      ; preds = %34, %.preheader.preheader
  %j.13 = phi i32 [ 0, %.preheader.preheader ], [ %35, %34 ]
  %22 = add i32 %20, %j.13
  %scevgep5 = getelementptr i32, i32* %D, i32 %22
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str1, i32 0, i32 0)) #3
  %23 = load i32, i32* %scevgep5, align 4
  %24 = mul nsw i32 %23, %beta
  br label %25

; <label>:25                                      ; preds = %25, %21
  %x1.02 = phi i32 [ %24, %21 ], [ %32, %25 ]
  %k.11 = phi i32 [ 0, %21 ], [ %33, %25 ]
  %26 = add i32 %20, %k.11
  %scevgep3 = getelementptr i32, i32* %tmp, i32 %26
  %27 = mul i32 %k.11, 8
  %28 = add i32 %j.13, %27
  %scevgep = getelementptr i32, i32* %C, i32 %28
  %29 = load i32, i32* %scevgep3, align 4
  %30 = load i32, i32* %scevgep, align 4
  %31 = mul nsw i32 %29, %30
  %32 = add nsw i32 %x1.02, %31
  %33 = add nsw i32 %k.11, 1
  %exitcond3 = icmp eq i32 %33, 8
  br i1 %exitcond3, label %34, label %25

; <label>:34                                      ; preds = %25
  %.lcssa = phi i32 [ %32, %25 ]
  store i32 %.lcssa, i32* %scevgep5, align 4
  %35 = add nsw i32 %j.13, 1
  %exitcond7 = icmp eq i32 %35, 8
  br i1 %exitcond7, label %.preheader, label %21

.preheader:                                       ; preds = %34
  %36 = add nsw i32 %i.14, 1
  %exitcond = icmp eq i32 %36, 8
  br i1 %exitcond, label %37, label %.preheader.preheader

; <label>:37                                      ; preds = %.preheader
  ret void
}

;declare void @__legup_label(i8*) #1

attributes #0 = { noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin nounwind }
attributes #4 = { nobuiltin }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!legup.pipeline = !{!1, !1}

!0 =  !{ !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
!1 =  !{ !"II",  !"1"}
!2 =  !{ !"1"}
!3 =  !{ !"0"}
!4 =  !{ !"2"}
!5 =  !{ !"3"}
!6 =  !{ !"8"}
!7 =  !{ !"LOOP52"}
!8 =  !{ !"LOOP64"}
