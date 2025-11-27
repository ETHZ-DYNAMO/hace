; ModuleID = 'mvt.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP16\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP23\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP25\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP44\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP45\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP50\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP59\00", align 1
@.str7 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str8 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str9 = private unnamed_addr constant [7 x i8] c"LOOP64\00", align 1

; Function Attrs: noinline nounwind
define void @mvt(i32* nocapture readonly %A, i32* nocapture %x1, i32* nocapture %x2, i32* nocapture readonly %y1, i32* nocapture readonly %y2) #0 {
  br label %1

; <label>:1                                       ; preds = %11, %0
  %i.06 = phi i32 [ 0, %0 ], [ %12, %11 ]
  %2 = mul i32 %i.06, 32
  %scevgep11 = getelementptr i32, i32* %x1, i32 %i.06
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0)) #3
  %3 = load i32, i32* %scevgep11, align 4
  br label %4

; <label>:4                                       ; preds = %4, %1
  %tmp.05 = phi i32 [ %3, %1 ], [ %9, %4 ]
  %j.04 = phi i32 [ 0, %1 ], [ %10, %4 ]
  %5 = add i32 %2, %j.04
  %scevgep8 = getelementptr i32, i32* %A, i32 %5
  %scevgep7 = getelementptr i32, i32* %y1, i32 %j.04
  %6 = load i32, i32* %scevgep8, align 4
  %7 = load i32, i32* %scevgep7, align 4
  %8 = mul nsw i32 %6, %7
  %9 = add nsw i32 %tmp.05, %8
  %10 = add nsw i32 %j.04, 1
  %exitcond = icmp eq i32 %10, 32
  br i1 %exitcond, label %11, label %4

; <label>:11                                      ; preds = %4
  %.lcssa1 = phi i32 [ %9, %4 ]
  store i32 %.lcssa1, i32* %scevgep11, align 4
  %12 = add nsw i32 %i.06, 1
  %exitcond14 = icmp eq i32 %12, 32
  br i1 %exitcond14, label %.preheader.preheader.preheader, label %1

.preheader.preheader.preheader:                   ; preds = %11
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %.preheader, %.preheader.preheader.preheader
  %i.13 = phi i32 [ %22, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %scevgep5 = getelementptr i32, i32* %x2, i32 %i.13
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str1, i32 0, i32 0)) #3
  %13 = load i32, i32* %scevgep5, align 4
  br label %14

; <label>:14                                      ; preds = %14, %.preheader.preheader
  %tmp1.02 = phi i32 [ %13, %.preheader.preheader ], [ %20, %14 ]
  %j.11 = phi i32 [ 0, %.preheader.preheader ], [ %21, %14 ]
  %15 = mul i32 %j.11, 32
  %16 = add i32 %i.13, %15
  %scevgep3 = getelementptr i32, i32* %A, i32 %16
  %scevgep = getelementptr i32, i32* %y2, i32 %j.11
  %17 = load i32, i32* %scevgep3, align 4
  %18 = load i32, i32* %scevgep, align 4
  %19 = mul nsw i32 %17, %18
  %20 = add nsw i32 %tmp1.02, %19
  %21 = add nsw i32 %j.11, 1
  %exitcond3 = icmp eq i32 %21, 32
  br i1 %exitcond3, label %.preheader, label %14

.preheader:                                       ; preds = %14
  %.lcssa = phi i32 [ %20, %14 ]
  store i32 %.lcssa, i32* %scevgep5, align 4
  %22 = add nsw i32 %i.13, 1
  %exitcond7 = icmp eq i32 %22, 32
  br i1 %exitcond7, label %23, label %.preheader.preheader

; <label>:23                                      ; preds = %.preheader
  ret void
}

;declare void @__legup_label(i8*) #1

attributes #0 = { noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin nounwind }
attributes #4 = { nobuiltin }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!legup.pipeline = !{!1, !1, !1}

!0 =  !{ !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
!1 =  !{ !"II",  !"1"}
!2 =  !{ !"1"}
!3 =  !{ !"0"}
!4 =  !{ !"2"}
!5 =  !{ !"3"}
!6 =  !{ !"32"}
!7 =  !{ !"LOOP50"}
!8 =  !{ !"LOOP59"}
!9 =  !{ !"LOOP64"}
