; RUN: llvm-as < %s | opt -argpromotion -instcombine | llvm-dis | not grep load

%QuadTy = type { i32, i32, i32, i32 }
@G = constant %QuadTy {
    i32 0, 
    i32 0, 
    i32 17, 
    i32 25 }            ; <%QuadTy*> [#uses=1]

define internal i32 @test(%QuadTy* %P) {
        %A = getelementptr %QuadTy* %P, i64 0, i32 3            ; <i32*> [#uses=1]
        %B = getelementptr %QuadTy* %P, i64 0, i32 2            ; <i32*> [#uses=1]
        %a = load i32* %A               ; <i32> [#uses=1]
        %b = load i32* %B               ; <i32> [#uses=1]
        %V = add i32 %a, %b             ; <i32> [#uses=1]
        ret i32 %V
}

define i32 @caller() {
        %V = call i32 @test( %QuadTy* @G )              ; <i32> [#uses=1]
        ret i32 %V
}

