; ModuleID = 'getTanh.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"LOOP16\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"LOOP38\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"LOOP39\00", align 1

; Function Attrs: noinline nounwind
define void @getTanh(i32* nocapture %A, i32* nocapture readonly %addr) #0 {
  br label %1

; <label>:1                                       ; preds = %13, %0
  %i.01 = phi i32 [ 0, %0 ], [ %14, %13 ]
  %scevgep = getelementptr i32, i32* %addr, i32 %i.01
  ;call void @__legup_label(i8* getelementptr inbounds ([7 x i8]* @.str, i32 0, i32 0)) #2
  %2 = load i32, i32* %scevgep, align 4
  %3 = getelementptr inbounds i32, i32* %A, i32 %2
  %4 = load i32, i32* %3, align 4
  %5 = icmp sgt i32 %4, 0
  br i1 %5, label %13, label %6

; <label>:6                                       ; preds = %1
  %7 = mul nsw i32 %4, %4
  %8 = add nuw nsw i32 %7, 19
  %9 = mul nsw i32 %8, %4
  %10 = mul nsw i32 %9, %4
  %11 = add nsw i32 %10, 3
  %12 = mul nsw i32 %11, %4
  br label %13

; <label>:13                                      ; preds = %6, %1
  %result.0 = phi i32 [ %12, %6 ], [ 1, %1 ]
  store i32 %result.0, i32* %3, align 4
  %14 = add nsw i32 %i.01, 1
  %exitcond = icmp eq i32 %14, 1000
  br i1 %exitcond, label %15, label %1

; <label>:15                                      ; preds = %13
  ret void
}

;declare void @__legup_label(i8*) #1

attributes #0 = { noinline nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nobuiltin nounwind }
attributes #3 = { nobuiltin }

!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}

!0 =  !{ !"Ubuntu clang version 3.5.2-3ubuntu1 (tags/RELEASE_352/final) (based on LLVM 3.5.2)"}
