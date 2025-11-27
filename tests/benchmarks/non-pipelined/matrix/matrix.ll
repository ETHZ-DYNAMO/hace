; ModuleID = 'matrix.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [6 x i8] c"loop1\00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"loop2\00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"loop3\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"LOOP42\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP43\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP44\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP54\00", align 1
@.str7 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind
define void @matrix(i32* nocapture readonly %in_a, i32* nocapture readonly %in_b, i32* nocapture %out_c) #0 {
  br label %1

; <label>:1                                       ; preds = %16, %0
  %i.04 = phi i32 [ 0, %0 ], [ %17, %16 ]
  %2 = mul i32 %i.04, 32
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str, i32 0, i32 0)) #3
  br label %3

; <label>:3                                       ; preds = %14, %1
  %j.03 = phi i32 [ 0, %1 ], [ %15, %14 ]
  %4 = add i32 %2, %j.03
  %scevgep4 = getelementptr i32, i32* %out_c, i32 %4
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str1, i32 0, i32 0)) #3
  br label %5

; <label>:5                                       ; preds = %5, %3
  %sum_mult.02 = phi i32 [ 0, %3 ], [ %12, %5 ], !legup.pipeline.start_time !2, !legup.pipeline.avail_time !2, !legup.pipeline.stage !2
  %k.01 = phi i32 [ 0, %3 ], [ %13, %5 ], !legup.canonical_induction !3, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !4, !legup.pipeline.stage !4
  %6 = add i32 %2, %k.01, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !4, !legup.pipeline.stage !4
  %scevgep2 = getelementptr i32, i32* %in_a, i32 %6, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  %7 = mul i32 %k.01, 32, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !4, !legup.pipeline.stage !4
  %8 = add i32 %j.03, %7, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !4, !legup.pipeline.stage !4
  %scevgep = getelementptr i32, i32* %in_b, i32 %8, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str2, i32 0, i32 0)) #3, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !4, !legup.pipeline.stage !4
  %9 = load i32, i32* %scevgep2, align 4, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3
  %10 = load i32, i32* %scevgep, align 4, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !2, !legup.pipeline.stage !3
  %11 = mul nsw i32 %9, %10, !legup.pipeline.start_time !2, !legup.pipeline.avail_time !5, !legup.pipeline.stage !2
  %12 = add nsw i32 %sum_mult.02, %11, !legup.pipeline.start_time !5, !legup.pipeline.avail_time !5, !legup.pipeline.stage !5
  %13 = add nsw i32 %k.01, 1, !legup.pipeline.start_time !4, !legup.pipeline.avail_time !4, !legup.pipeline.stage !4
  %exitcond2 = icmp eq i32 %13, 32, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3
  br i1 %exitcond2, label %14, label %5, !legup.II !3, !legup.totalTime !6, !legup.maxStage !5, !legup.tripCount !7, !legup.pipeline.start_time !3, !legup.pipeline.avail_time !3, !legup.pipeline.stage !3, !legup.loop_pipelined !3, !legup.label !8

; <label>:14                                      ; preds = %5
  %.lcssa = phi i32 [ %12, %5 ]
  store i32 %.lcssa, i32* %scevgep4, align 4
  %15 = add nsw i32 %j.03, 1
  %exitcond6 = icmp eq i32 %15, 32
  br i1 %exitcond6, label %16, label %3

; <label>:16                                      ; preds = %14
  %17 = add nsw i32 %i.04, 1
  %exitcond = icmp eq i32 %17, 32
  br i1 %exitcond, label %18, label %1

; <label>:18                                      ; preds = %16
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
!2 =  !{ !"2"}
!3 =  !{ !"1"}
!4 =  !{ !"0"}
!5 =  !{ !"3"}
!6 =  !{ !"4"}
!7 =  !{ !"32"}
!8 =  !{ !"loop3"}
!9 =  !{ !"LOOP44"}
!10 =  !{ !"1024"}
!11 =  !{ !"LOOP54"}
