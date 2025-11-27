; ModuleID = 'gaussian.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP14\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP18\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP22\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP37\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP38\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP40\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP49\00", align 1
@.str7 = private unnamed_addr constant [7 x i8] c"LOOP50\00", align 1
@.str8 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str9 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind
define void @gaussian(i32* nocapture readonly %c, i32* nocapture %A) #0 {
  br label %.loopexit.loopexit

.loopexit.loopexit.loopexit:                      ; preds = %20
  br label %.loopexit.loopexit

.loopexit.loopexit:                               ; preds = %.loopexit.loopexit.loopexit, %0
  %1 = phi i32 [ 0, %0 ], [ %8, %.loopexit.loopexit.loopexit ]
  %2 = mul i32 %1, 16
  %3 = add i32 %2, 33
  %4 = mul i32 %1, -1
  %5 = add i32 %4, 14
  %6 = add i32 %2, 17
  %7 = add i32 %1, 1
  %scevgep11 = getelementptr i32, i32* %c, i32 %7
  %8 = add i32 %1, 1
  ; call void @__legup_label(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0)) #3
  %exitcond = icmp eq i32 %1, 14
  br i1 %exitcond, label %.loopexit.loopexit.thread, label %.lr.ph.preheader

.lr.ph.preheader:                                 ; preds = %.loopexit.loopexit
  br label %.lr.ph

.lr.ph:                                           ; preds = %20, %.lr.ph.preheader
  %indvar4 = phi i32 [ %21, %20 ], [ 0, %.lr.ph.preheader ]
  %9 = mul i32 %indvar4, 16
  %10 = add i32 %3, %9
  ; call void @__legup_label(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str1, i32 0, i32 0)) #3
  br label %11

; <label>:11                                      ; preds = %11, %.lr.ph
  %indvar = phi i32 [ %19, %11 ], [ 0, %.lr.ph ], !legup.canonical_induction !2, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  %12 = add i32 %10, %indvar, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  %scevgep6 = getelementptr i32, i32* %A, i32 %12, !legup.pipeline.start_time !2, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3
  %13 = add i32 %6, %indvar, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  %scevgep = getelementptr i32, i32* %A, i32 %13, !legup.pipeline.start_time !2, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3
  ; call void @__legup_label(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str2, i32 0, i32 0)) #3, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  %14 = load i32, i32* %scevgep6, align 4, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !5, !legup.pipeline.stage !2
  %15 = load i32, i32* %scevgep11, align 4, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3
  %16 = load i32, i32* %scevgep, align 4, !legup.pipeline.start_time !2, !legup.pipeline.avail_time !4, !legup.pipeline.stage !3
  %17 = mul nsw i32 %15, %16, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !5, !legup.pipeline.stage !2
  %18 = sub nsw i32 %14, %17, !legup.pipeline.start_time !5, !legup.pipeline.avail_time !5, !legup.pipeline.stage !2
  store i32 %18, i32* %scevgep6, align 4, !legup.pipeline.start_time !5, !legup.pipeline.avail_time !6, !legup.pipeline.stage !2
  %19 = add i32 %indvar, 1, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  %exitcond2 = icmp eq i32 %19, 15, !legup.pipeline.start_time !2, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3
  br i1 %exitcond2, label %20, label %11, !legup.II !4, !legup.totalTime !7, !legup.maxStage !2, !legup.tripCount !8, !legup.pipeline.start_time !2, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3, !legup.loop_pipelined !2, !legup.label !9

; <label>:20                                      ; preds = %11
  %21 = add i32 %indvar4, 1
  %exitcond5 = icmp eq i32 %21, %5
  br i1 %exitcond5, label %.loopexit.loopexit.loopexit, label %.lr.ph

.loopexit.loopexit.thread:                        ; preds = %.loopexit.loopexit
  ret void
}

; declare void @__legup_label(i8*) #1

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!legup.pipeline = !{!1}

!0 =  !{ !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
!1 =  !{ !"II",  !"2"}
!2 =  !{ !"1"}
!3 =  !{ !"0"}
!4 =  !{ !"2"}
!5 =  !{ !"3"}
!6 =  !{ !"4"}
!7 =  !{ !"5"}
!8 =  !{ !"15"}
!9 =  !{ !"LOOP22"}
