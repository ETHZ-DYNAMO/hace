; ModuleID = 'kmp.bc'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [6 x i8] c"loop1\00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"loop2\00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"loop3\00", align 1
@.str3 = private unnamed_addr constant [6 x i8] c"loop4\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"LOOP50\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"LOOP51\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"LOOP56\00", align 1
@.str7 = private unnamed_addr constant [14 x i8] c"RESULT: PASS\0A\00", align 1

; Function Attrs: noinline nounwind
define void @kmp(i32* nocapture readonly %pattern, i32* nocapture readonly %input, i32* nocapture %kmpNext) #0 {
  store i32 0, i32* %kmpNext, align 4
  br label %1

; <label>:1                                       ; preds = %14, %0
  %indvar = phi i32 [ %3, %14 ], [ 0, %0 ]
  %k.016 = phi i32 [ 0, %0 ], [ %k.2, %14 ]
  %2 = add i32 %indvar, 1
  %scevgep6 = getelementptr i32, i32* %pattern, i32 %2
  %scevgep5 = getelementptr i32, i32* %kmpNext, i32 %2
  %3 = add i32 %indvar, 1
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str, i32 0, i32 0)) #3
  %4 = load i32, i32* %scevgep6, align 4
  %5 = icmp sgt i32 %k.016, 0
  br i1 %5, label %.lr.ph14.preheader, label %.thread

.lr.ph14.preheader:                               ; preds = %1
  br label %.lr.ph14

.lr.ph14:                                         ; preds = %9, %.lr.ph14.preheader
  %k.113 = phi i32 [ %10, %9 ], [ %k.016, %.lr.ph14.preheader ]
  %6 = getelementptr inbounds i32, i32* %pattern, i32 %k.113
  %7 = load i32, i32* %6, align 4
  %8 = icmp eq i32 %7, %4
  br i1 %8, label %.thread.thread.loopexit, label %9

; <label>:9                                       ; preds = %.lr.ph14
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str1, i32 0, i32 0)) #3
  %10 = load i32, i32* %scevgep5, align 4
  %11 = icmp sgt i32 %10, 0
  br i1 %11, label %.lr.ph14, label %.thread.loopexit

.thread.loopexit:                                 ; preds = %9
  %.lcssa3 = phi i32 [ %10, %9 ]
  br label %.thread

.thread:                                          ; preds = %.thread.loopexit, %1
  %k.1.lcssa = phi i32 [ %k.016, %1 ], [ %.lcssa3, %.thread.loopexit ]
  %.phi.trans.insert = getelementptr inbounds i32, i32* %pattern, i32 %k.1.lcssa
  %.pre = load i32, i32* %.phi.trans.insert, align 4
  %12 = icmp eq i32 %.pre, %4
  br i1 %12, label %.thread.thread, label %14

.thread.thread.loopexit:                          ; preds = %.lr.ph14
  %k.113.lcssa = phi i32 [ %k.113, %.lr.ph14 ]
  br label %.thread.thread

.thread.thread:                                   ; preds = %.thread.thread.loopexit, %.thread
  %k.13739 = phi i32 [ %k.1.lcssa, %.thread ], [ %k.113.lcssa, %.thread.thread.loopexit ]
  %13 = add nsw i32 %k.13739, 1
  br label %14

; <label>:14                                      ; preds = %.thread.thread, %.thread
  %k.2 = phi i32 [ %13, %.thread.thread ], [ %k.1.lcssa, %.thread ]
  store i32 %k.2, i32* %scevgep5, align 4
  %exitcond8 = icmp eq i32 %3, 3
  br i1 %exitcond8, label %.preheader.preheader.preheader, label %1

.preheader.preheader.preheader:                   ; preds = %14
  br label %.preheader.preheader

.preheader.preheader:                             ; preds = %.preheader, %.preheader.preheader.preheader
  %i.012 = phi i32 [ %31, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %q.111 = phi i32 [ %q.4, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %n_matches.010 = phi i32 [ %n_matches.1, %.preheader ], [ 0, %.preheader.preheader.preheader ]
  %scevgep = getelementptr i32, i32* %input, i32 %i.012
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str2, i32 0, i32 0)) #3
  %15 = load i32, i32* %scevgep, align 4
  %16 = icmp sgt i32 %q.111, 0
  br i1 %16, label %.lr.ph.preheader, label %.thread2

.lr.ph.preheader:                                 ; preds = %.preheader.preheader
  br label %.lr.ph

.lr.ph:                                           ; preds = %20, %.lr.ph.preheader
  %q.29 = phi i32 [ %22, %20 ], [ %q.111, %.lr.ph.preheader ]
  %17 = getelementptr inbounds i32, i32* %pattern, i32 %q.29
  %18 = load i32, i32* %17, align 4
  %19 = icmp eq i32 %18, %15
  br i1 %19, label %thread-pre-split.loopexit, label %20

; <label>:20                                      ; preds = %.lr.ph
  ;call void @__legup_label(i8* getelementptr inbounds ([6 x i8]* @.str3, i32 0, i32 0)) #3
  %21 = getelementptr inbounds i32, i32* %kmpNext, i32 %q.29
  %22 = load i32, i32* %21, align 4
  %23 = icmp sgt i32 %22, 0
  br i1 %23, label %.lr.ph, label %.thread2.loopexit

.thread2.loopexit:                                ; preds = %20
  %.lcssa = phi i32 [ %22, %20 ]
  br label %.thread2

.thread2:                                         ; preds = %.thread2.loopexit, %.preheader.preheader
  %q.2.lcssa = phi i32 [ %q.111, %.preheader.preheader ], [ %.lcssa, %.thread2.loopexit ]
  %.phi.trans.insert32 = getelementptr inbounds i32, i32* %pattern, i32 %q.2.lcssa
  %.pre33 = load i32, i32* %.phi.trans.insert32, align 4
  %24 = icmp eq i32 %.pre33, %15
  br i1 %24, label %thread-pre-split, label %.preheader

thread-pre-split.loopexit:                        ; preds = %.lr.ph
  %q.29.lcssa = phi i32 [ %q.29, %.lr.ph ]
  br label %thread-pre-split

thread-pre-split:                                 ; preds = %thread-pre-split.loopexit, %.thread2
  %q.23540 = phi i32 [ %q.2.lcssa, %.thread2 ], [ %q.29.lcssa, %thread-pre-split.loopexit ]
  %25 = add nsw i32 %q.23540, 1
  %26 = icmp sgt i32 %q.23540, 2
  br i1 %26, label %27, label %.preheader

; <label>:27                                      ; preds = %thread-pre-split
  %28 = add nsw i32 %n_matches.010, 1
  %29 = getelementptr inbounds i32, i32* %kmpNext, i32 %q.23540
  %30 = load i32, i32* %29, align 4
  br label %.preheader

.preheader:                                       ; preds = %27, %thread-pre-split, %.thread2
  %n_matches.1 = phi i32 [ %28, %27 ], [ %n_matches.010, %thread-pre-split ], [ %n_matches.010, %.thread2 ]
  %q.4 = phi i32 [ %30, %27 ], [ %25, %thread-pre-split ], [ %q.2.lcssa, %.thread2 ]
  %31 = add nsw i32 %i.012, 1
  %exitcond5 = icmp eq i32 %31, 1000
  br i1 %exitcond5, label %32, label %.preheader.preheader

; <label>:32                                      ; preds = %.preheader
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
