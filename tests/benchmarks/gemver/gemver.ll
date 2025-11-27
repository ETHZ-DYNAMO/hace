; ModuleID = 'gemver.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP24\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP35\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP37\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP60\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP63\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP72\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP81\00", align 1
@.str7 = private unnamed_addr constant [7 x i8] c"LOOP82\00", align 1
@.str8 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str9 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str10 = private unnamed_addr constant [7 x i8] c"LOOP88\00", align 1
@.str11 = private unnamed_addr constant [7 x i8] c"LOOP93\00", align 1

; Function Attrs: noinline nounwind
define void @gemver(i32 %alpha, i32 %beta, i32* nocapture %A, i32* nocapture readonly %u1, i32* nocapture readonly %v1, i32* nocapture readonly %u2, i32* nocapture readonly %v2, i32* nocapture %w, i32* nocapture %x, i32* nocapture readonly %y, i32* nocapture readonly %z) #0 {
  br label %1

; <label>:1                                       ; preds = %15, %0
  %i.011 = phi i32 [ 0, %0 ], [ %16, %15 ]
  %2 = mul i32 %i.011, 32
  %scevgep22 = getelementptr i32, i32* %u1, i32 %i.011
  %scevgep21 = getelementptr i32, i32* %u2, i32 %i.011
  br label %3

; <label>:3                                       ; preds = %3, %1
  %j.010 = phi i32 [ 0, %1 ], [ %14, %3 ]
  %4 = add i32 %2, %j.010
  %scevgep18 = getelementptr i32, i32* %A, i32 %4
  %scevgep17 = getelementptr i32, i32* %v1, i32 %j.010
  %scevgep16 = getelementptr i32, i32* %v2, i32 %j.010
  %5 = load i32, i32* %scevgep18, align 4
  %6 = load i32, i32* %scevgep22, align 4
  %7 = load i32, i32* %scevgep17, align 4
  %8 = mul nsw i32 %6, %7
  %9 = add nsw i32 %5, %8
  %10 = load i32, i32* %scevgep21, align 4
  %11 = load i32, i32* %scevgep16, align 4
  %12 = mul nsw i32 %10, %11
  %13 = add nsw i32 %9, %12
  store i32 %13, i32* %scevgep18, align 4
  %14 = add nsw i32 %j.010, 1
  %exitcond25 = icmp eq i32 %14, 32
  br i1 %exitcond25, label %15, label %3

; <label>:15                                      ; preds = %3
  %16 = add nsw i32 %i.011, 1
  %exitcond29 = icmp eq i32 %16, 32
  br i1 %exitcond29, label %.preheader2.preheader.preheader, label %1

.preheader2.preheader.preheader:                  ; preds = %15
  br label %.preheader2.preheader

.preheader2.preheader:                            ; preds = %.preheader2, %.preheader2.preheader.preheader
  %i.19 = phi i32 [ %27, %.preheader2 ], [ 0, %.preheader2.preheader.preheader ]
  %scevgep14 = getelementptr i32, i32* %x, i32 %i.19
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0)) #3
  %17 = load i32, i32* %scevgep14, align 4
  br label %18

; <label>:18                                      ; preds = %18, %.preheader2.preheader
  %tmp.08 = phi i32 [ %17, %.preheader2.preheader ], [ %25, %18 ]
  %j.17 = phi i32 [ 0, %.preheader2.preheader ], [ %26, %18 ]
  %19 = mul i32 %j.17, 32
  %20 = add i32 %i.19, %19
  %scevgep11 = getelementptr i32, i32* %A, i32 %20
  %scevgep10 = getelementptr i32, i32* %y, i32 %j.17
  %21 = load i32, i32* %scevgep11, align 4
  %22 = mul nsw i32 %21, %beta
  %23 = load i32, i32* %scevgep10, align 4
  %24 = mul nsw i32 %22, %23
  %25 = add nsw i32 %tmp.08, %24
  %26 = add nsw i32 %j.17, 1
  %exitcond16 = icmp eq i32 %26, 32
  br i1 %exitcond16, label %.preheader2, label %18

.preheader2:                                      ; preds = %18
  %.lcssa1 = phi i32 [ %25, %18 ]
  store i32 %.lcssa1, i32* %scevgep14, align 4
  %27 = add nsw i32 %i.19, 1
  %exitcond21 = icmp eq i32 %27, 32
  br i1 %exitcond21, label %.preheader1.preheader, label %.preheader2.preheader

.preheader1.preheader:                            ; preds = %.preheader2
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1, %.preheader1.preheader
  %i.26 = phi i32 [ %31, %.preheader1 ], [ 0, %.preheader1.preheader ]
  %scevgep8 = getelementptr i32, i32* %x, i32 %i.26
  %scevgep7 = getelementptr i32, i32* %z, i32 %i.26
  %28 = load i32, i32* %scevgep8, align 4
  %29 = load i32, i32* %scevgep7, align 4
  %30 = add nsw i32 %28, %29
  store i32 %30, i32* %scevgep8, align 4
  %31 = add nsw i32 %i.26, 1
  %exitcond = icmp eq i32 %31, 32
  br i1 %exitcond, label %.preheader.preheader.preheader, label %.preheader1

.preheader.preheader.preheader:                   ; preds = %.preheader1
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %.preheader, %.preheader.preheader.preheader
  %i.35 = phi i32 [ %42, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %32 = mul i32 %i.35, 32
  %scevgep5 = getelementptr i32, i32* %w, i32 %i.35
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str1, i32 0, i32 0)) #3
  %33 = load i32, i32* %scevgep5, align 4
  br label %34

; <label>:34                                      ; preds = %34, %.preheader.preheader
  %tmp1.04 = phi i32 [ %33, %.preheader.preheader ], [ %40, %34 ]
  %j.23 = phi i32 [ 0, %.preheader.preheader ], [ %41, %34 ]
  %35 = add i32 %32, %j.23
  %scevgep3 = getelementptr i32, i32* %A, i32 %35
  %scevgep = getelementptr i32, i32* %x, i32 %j.23
  %36 = load i32, i32* %scevgep3, align 4
  %37 = mul nsw i32 %36, %alpha
  %38 = load i32, i32* %scevgep, align 4
  %39 = mul nsw i32 %37, %38
  %40 = add nsw i32 %tmp1.04, %39
  %41 = add nsw i32 %j.23, 1
  %exitcond3 = icmp eq i32 %41, 32
  br i1 %exitcond3, label %.preheader, label %34

.preheader:                                       ; preds = %34
  %.lcssa = phi i32 [ %40, %34 ]
  store i32 %.lcssa, i32* %scevgep5, align 4
  %42 = add nsw i32 %i.35, 1
  %exitcond7 = icmp eq i32 %42, 32
  br i1 %exitcond7, label %43, label %.preheader.preheader

; <label>:43                                      ; preds = %.preheader
  ret void
}

;declare void @__legup_label(i8*) #1

attributes #0 = { noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin nounwind }
attributes #4 = { nobuiltin }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}

!0 =  !{ !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
