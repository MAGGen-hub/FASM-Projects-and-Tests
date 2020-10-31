macro calculate
{
    fld [powx] ;st(1) powx
    fld [x] ; st(0) x
    fmulp ; x^(n+1)  st(0) = powx*x
    fstp [powx] ;st(0) = curent sign

    fld [fact] ;st(1) fact
    fild [counter] ; st(0) curent n number
    fmulp ; x^(n+1)  st(0) = fact(n-1)*n
    fstp [fact] ;st(0) = curent sign

    fld [powx]
    fld [fact]
    fdivp ; st(0) = powx/fact = cur_(cos or sin)
    fmul st0,st1 ;st(1) = curent sign;  st(0) = cur_(cos or sin)*(cur_singn)

    inc [counter] ; counter for factorial +1
}