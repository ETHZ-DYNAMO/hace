; ModuleID = 'kernel_3mm.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP18\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP27\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP35\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP38\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP57\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP58\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP59\00", align 1
@.str7 = private unnamed_addr constant [7 x i8] c"LOOP74\00", align 1
@.str8 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str9 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str10 = private unnamed_addr constant [7 x i8] c"LOOP79\00", align 1
@.str11 = private unnamed_addr constant [7 x i8] c"LOOP84\00", align 1

; Function Attrs: noinline nounwind
define void @kernel_3mm(i32* nocapture readonly %A, i32* nocapture readonly %B, i32* nocapture readonly %C, i32* nocapture readonly %D, i32* nocapture %E, i32* nocapture %F, i32* nocapture %G) #0 {
  br label %1

; <label>:1                                       ; preds = %17, %0
  %i.013 = phi i32 [ 0, %0 ], [ %18, %17 ]
  %2 = mul i32 %i.013, 8
  br label %3

; <label>:3                                       ; preds = %15, %1
  %j.012 = phi i32 [ 0, %1 ], [ %16, %15 ]
  %4 = add i32 %2, %j.012
  %scevgep24 = getelementptr i32, i32* %E, i32 %4
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0)) #3
  %5 = load i32, i32* %scevgep24, align 4
  br label %6

; <label>:6                                       ; preds = %6, %3
  %tmp.011 = phi i32 [ %5, %3 ], [ %13, %6 ]
  %k.010 = phi i32 [ 0, %3 ], [ %14, %6 ]
  %7 = add i32 %2, %k.010
  %scevgep21 = getelementptr i32, i32* %A, i32 %7
  %8 = mul i32 %k.010, 8
  %9 = add i32 %j.012, %8
  %scevgep20 = getelementptr i32, i32* %B, i32 %9
  %10 = load i32, i32* %scevgep21, align 4
  %11 = load i32, i32* %scevgep20, align 4
  %12 = mul nsw i32 %10, %11
  %13 = add nsw i32 %tmp.011, %12
  %14 = add nsw i32 %k.010, 1
  %exitcond27 = icmp eq i32 %14, 8
  br i1 %exitcond27, label %15, label %6

; <label>:15                                      ; preds = %6
  %.lcssa2 = phi i32 [ %13, %6 ]
  store i32 %.lcssa2, i32* %scevgep24, align 4
  %16 = add nsw i32 %j.012, 1
  %exitcond30 = icmp eq i32 %16, 8
  br i1 %exitcond30, label %17, label %3

; <label>:17                                      ; preds = %15
  %18 = add nsw i32 %i.013, 1
  %exitcond33 = icmp eq i32 %18, 8
  br i1 %exitcond33, label %.preheader1.preheader.preheader, label %1

.preheader1.preheader.preheader:                  ; preds = %17
  br label %.preheader1.preheader

.preheader1.preheader:                            ; preds = %.preheader1, %.preheader1.preheader.preheader
  %i.19 = phi i32 [ %34, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ]
  %19 = mul i32 %i.19, 8
  br label %20

; <label>:20                                      ; preds = %32, %.preheader1.preheader
  %j.18 = phi i32 [ 0, %.preheader1.preheader ], [ %33, %32 ]
  %21 = add i32 %19, %j.18
  %scevgep15 = getelementptr i32, i32* %F, i32 %21
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str1, i32 0, i32 0)) #3
  %22 = load i32, i32* %scevgep15, align 4
  br label %23

; <label>:23                                      ; preds = %23, %20
  %tmp1.07 = phi i32 [ %22, %20 ], [ %30, %23 ]
  %k.16 = phi i32 [ 0, %20 ], [ %31, %23 ]
  %24 = add i32 %19, %k.16
  %scevgep12 = getelementptr i32, i32* %C, i32 %24
  %25 = mul i32 %k.16, 8
  %26 = add i32 %j.18, %25
  %scevgep11 = getelementptr i32, i32* %D, i32 %26
  %27 = load i32, i32* %scevgep12, align 4
  %28 = load i32, i32* %scevgep11, align 4
  %29 = mul nsw i32 %27, %28
  %30 = add nsw i32 %tmp1.07, %29
  %31 = add nsw i32 %k.16, 1
  %exitcond15 = icmp eq i32 %31, 8
  br i1 %exitcond15, label %32, label %23

; <label>:32                                      ; preds = %23
  %.lcssa1 = phi i32 [ %30, %23 ]
  store i32 %.lcssa1, i32* %scevgep15, align 4
  %33 = add nsw i32 %j.18, 1
  %exitcond18 = icmp eq i32 %33, 8
  br i1 %exitcond18, label %.preheader1, label %20

.preheader1:                                      ; preds = %32
  %34 = add nsw i32 %i.19, 1
  %exitcond23 = icmp eq i32 %34, 8
  br i1 %exitcond23, label %.preheader.preheader.preheader, label %.preheader1.preheader

.preheader.preheader.preheader:                   ; preds = %.preheader1
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %.preheader, %.preheader.preheader.preheader
  %i.25 = phi i32 [ %50, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %35 = mul i32 %i.25, 8
  br label %36

; <label>:36                                      ; preds = %48, %.preheader.preheader
  %j.24 = phi i32 [ 0, %.preheader.preheader ], [ %49, %48 ]
  %37 = add i32 %35, %j.24
  %scevgep6 = getelementptr i32, i32* %G, i32 %37
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str2, i32 0, i32 0)) #3
  %38 = load i32, i32* %scevgep6, align 4
  br label %39

; <label>:39                                      ; preds = %39, %36
  %tmp2.03 = phi i32 [ %38, %36 ], [ %46, %39 ]
  %k.22 = phi i32 [ 0, %36 ], [ %47, %39 ]
  %40 = add i32 %35, %k.22
  %scevgep4 = getelementptr i32, i32* %E, i32 %40
  %41 = mul i32 %k.22, 8
  %42 = add i32 %j.24, %41
  %scevgep = getelementptr i32, i32* %F, i32 %42
  %43 = load i32, i32* %scevgep4, align 4
  %44 = load i32, i32* %scevgep, align 4
  %45 = mul nsw i32 %43, %44
  %46 = add nsw i32 %tmp2.03, %45
  %47 = add nsw i32 %k.22, 1
  %exitcond4 = icmp eq i32 %47, 8
  br i1 %exitcond4, label %48, label %39

; <label>:48                                      ; preds = %39
  %.lcssa = phi i32 [ %46, %39 ]
  store i32 %.lcssa, i32* %scevgep6, align 4
  %49 = add nsw i32 %j.24, 1
  %exitcond8 = icmp eq i32 %49, 8
  br i1 %exitcond8, label %.preheader, label %36

.preheader:                                       ; preds = %48
  %50 = add nsw i32 %i.25, 1
  %exitcond = icmp eq i32 %50, 8
  br i1 %exitcond, label %51, label %.preheader.preheader

; <label>:51                                      ; preds = %.preheader
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
