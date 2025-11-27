; ModuleID = 'covariance.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP20\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP35\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP38\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP51\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP52\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP53\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP62\00", align 1
@.str7 = private unnamed_addr constant [7 x i8] c"LOOP63\00", align 1
@.str8 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str9 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str10 = private unnamed_addr constant [7 x i8] c"LOOP69\00", align 1

; Function Attrs: noinline nounwind
define internal fastcc void @covariance(i32* nocapture %data, i32* nocapture %symmat, i32* nocapture %mean) #0 {
  br label %1

; <label>:1                                       ; preds = %8, %0
  %j.011 = phi i32 [ 0, %0 ], [ %10, %8 ]
  %scevgep16 = getelementptr i32* %mean, i32 %j.011
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0)) #3
  br label %2

; <label>:2                                       ; preds = %2, %1
  %x.010 = phi i32 [ 0, %1 ], [ %6, %2 ]
  %i.09 = phi i32 [ 0, %1 ], [ %7, %2 ]
  %3 = mul i32 %i.09, 32
  %4 = add i32 %j.011, %3
  %scevgep13 = getelementptr i32* %data, i32 %4
  %5 = load i32* %scevgep13, align 4
  %6 = add nsw i32 %x.010, %5
  %7 = add nsw i32 %i.09, 1
  %exitcond18 = icmp eq i32 %7, 32
  br i1 %exitcond18, label %8, label %2

; <label>:8                                       ; preds = %2
  %.lcssa1 = phi i32 [ %6, %2 ]
  %9 = sdiv i32 %.lcssa1, 32
  store i32 %9, i32* %scevgep16, align 4
  %10 = add nsw i32 %j.011, 1
  %exitcond20 = icmp eq i32 %10, 32
  br i1 %exitcond20, label %.preheader1.preheader.preheader, label %1

.preheader1.preheader.preheader:                  ; preds = %8
  br label %.preheader1.preheader

.preheader1.preheader:                            ; preds = %.preheader1, %.preheader1.preheader.preheader
  %i.18 = phi i32 [ %18, %.preheader1 ], [ 0, %.preheader1.preheader.preheader ]
  %11 = mul i32 %i.18, 32
  br label %12

; <label>:12                                      ; preds = %12, %.preheader1.preheader
  %j.17 = phi i32 [ 0, %.preheader1.preheader ], [ %17, %12 ]
  %13 = add i32 %11, %j.17
  %scevgep8 = getelementptr i32* %data, i32 %13
  %scevgep9 = getelementptr i32* %mean, i32 %j.17
  %14 = load i32* %scevgep9, align 4
  %15 = load i32* %scevgep8, align 4
  %16 = sub nsw i32 %15, %14
  store i32 %16, i32* %scevgep8, align 4
  %17 = add nsw i32 %j.17, 1
  %exitcond = icmp eq i32 %17, 32
  br i1 %exitcond, label %.preheader1, label %12

.preheader1:                                      ; preds = %12
  %18 = add nsw i32 %i.18, 1
  %exitcond16 = icmp eq i32 %18, 32
  br i1 %exitcond16, label %.preheader.preheader.preheader, label %.preheader1.preheader

.preheader.preheader.preheader:                   ; preds = %.preheader1
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %.preheader.preheader.backedge, %.preheader.preheader.preheader
  %j1.06 = phi i32 [ 0, %.preheader.preheader.preheader ], [ %j1.06.be, %.preheader.preheader.backedge ]
  %exitcond294 = icmp eq i32 %j1.06, 32
  br i1 %exitcond294, label %.preheader.preheader.backedge, label %.lr.ph.preheader

.preheader.preheader.backedge:                    ; preds = %.preheader, %.preheader.preheader
  %j1.06.be = phi i32 [ %37, %.preheader ], [ 33, %.preheader.preheader ]
  br label %.preheader.preheader

.lr.ph.preheader:                                 ; preds = %.preheader.preheader
  %19 = sub i32 32, %j1.06
  %20 = mul i32 %j1.06, 33
  br label %.lr.ph

.lr.ph:                                           ; preds = %35, %.lr.ph.preheader
  %indvar = phi i32 [ %36, %35 ], [ 0, %.lr.ph.preheader ]
  %21 = add i32 %j1.06, %indvar
  %22 = add i32 %20, %indvar
  %scevgep6 = getelementptr i32* %symmat, i32 %22
  %23 = mul i32 %indvar, 32
  %24 = add i32 %20, %23
  %scevgep5 = getelementptr i32* %symmat, i32 %24
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str1, i32 0, i32 0)) #3
  br label %25

; <label>:25                                      ; preds = %25, %.lr.ph
  %x1.03 = phi i32 [ 0, %.lr.ph ], [ %33, %25 ]
  %i.22 = phi i32 [ 0, %.lr.ph ], [ %34, %25 ]
  %26 = mul i32 %i.22, 32
  %27 = add i32 %21, %26
  %scevgep = getelementptr i32* %data, i32 %27
  %28 = mul i32 %i.22, 32
  %29 = add i32 %j1.06, %28
  %scevgep3 = getelementptr i32* %data, i32 %29
  %30 = load i32* %scevgep3, align 4
  %31 = load i32* %scevgep, align 4
  %32 = mul nsw i32 %30, %31
  %33 = add nsw i32 %x1.03, %32
  %34 = add nsw i32 %i.22, 1
  %exitcond3 = icmp eq i32 %34, 32
  br i1 %exitcond3, label %35, label %25

; <label>:35                                      ; preds = %25
  %.lcssa = phi i32 [ %33, %25 ]
  store i32 %.lcssa, i32* %scevgep6, align 4
  store i32 %.lcssa, i32* %scevgep5, align 4
  %36 = add i32 %indvar, 1
  %exitcond8 = icmp eq i32 %36, %19
  br i1 %exitcond8, label %.preheader, label %.lr.ph

.preheader:                                       ; preds = %35
  %37 = add nsw i32 %j1.06, 1
  %exitcond30 = icmp eq i32 %37, 32
  br i1 %exitcond30, label %38, label %.preheader.preheader.backedge

; <label>:38                                      ; preds = %.preheader
  ret void
}

declare void @__legup_label(i8*) #1

; Function Attrs: noinline nounwind
define i32 @main() #0 {
  %data = alloca [1 x [1024 x i32]], align 4
  %symmat = alloca [1 x [1024 x i32]], align 4
  %mean = alloca [1 x [32 x i32]], align 4
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str2, i32 0, i32 0)) #3
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str3, i32 0, i32 0)) #3
  br label %1

; <label>:1                                       ; preds = %6, %0
  %y.05 = phi i32 [ 0, %0 ], [ %7, %6 ]
  %2 = mul i32 %y.05, 32
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str4, i32 0, i32 0)) #3
  br label %3

; <label>:3                                       ; preds = %3, %1
  %x.04 = phi i32 [ 0, %1 ], [ %5, %3 ]
  %4 = add i32 %2, %x.04
  %scevgep6 = getelementptr [1 x [1024 x i32]]* %data, i32 0, i32 0, i32 %4
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str5, i32 0, i32 0)) #3
  store i32 1, i32* %scevgep6, align 4
  %5 = add nsw i32 %x.04, 1
  %exitcond8 = icmp eq i32 %5, 32
  br i1 %exitcond8, label %6, label %3

; <label>:6                                       ; preds = %3
  %7 = add nsw i32 %y.05, 1
  %exitcond10 = icmp eq i32 %7, 32
  br i1 %exitcond10, label %8, label %1

; <label>:8                                       ; preds = %6
  %9 = getelementptr inbounds [1 x [1024 x i32]]* %data, i32 0, i32 0, i32 0
  %10 = getelementptr inbounds [1 x [1024 x i32]]* %symmat, i32 0, i32 0, i32 0
  %11 = getelementptr inbounds [1 x [32 x i32]]* %mean, i32 0, i32 0, i32 0
  call fastcc void @covariance(i32* %9, i32* %10, i32* %11) #4
  br label %12

; <label>:12                                      ; preds = %19, %8
  %i2.03 = phi i32 [ 0, %8 ], [ %21, %19 ]
  %13 = mul i32 %i2.03, 32
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str6, i32 0, i32 0)) #3
  br label %14

; <label>:14                                      ; preds = %14, %12
  %j.02 = phi i32 [ 0, %12 ], [ %18, %14 ]
  %15 = add i32 %13, %j.02
  %scevgep2 = getelementptr [1 x [1024 x i32]]* %symmat, i32 0, i32 0, i32 %15
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str7, i32 0, i32 0)) #3
  %16 = load i32* %scevgep2, align 4
  %17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str8, i32 0, i32 0), i32 %16) #4
  %18 = add nsw i32 %j.02, 1
  %exitcond4 = icmp eq i32 %18, 32
  br i1 %exitcond4, label %19, label %14

; <label>:19                                      ; preds = %14
  %20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str9, i32 0, i32 0)) #4
  %21 = add nsw i32 %i2.03, 1
  %exitcond = icmp eq i32 %21, 32
  br i1 %exitcond, label %.preheader.preheader, label %12

.preheader.preheader:                             ; preds = %19
  br label %.preheader

.preheader:                                       ; preds = %.preheader, %.preheader.preheader
  %i3.01 = phi i32 [ %24, %.preheader ], [ 0, %.preheader.preheader ]
  %scevgep = getelementptr [1 x [32 x i32]]* %mean, i32 0, i32 0, i32 %i3.01
  call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str10, i32 0, i32 0)) #3
  %22 = load i32* %scevgep, align 4
  %23 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str8, i32 0, i32 0), i32 %22) #4
  %24 = add nsw i32 %i3.01, 1
  %exitcond2 = icmp eq i32 %24, 32
  br i1 %exitcond2, label %25, label %.preheader

; <label>:25                                      ; preds = %.preheader
  %26 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str9, i32 0, i32 0)) #4
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #2

attributes #0 = { noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin nounwind }
attributes #4 = { nobuiltin }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
