while True:
    S = None
    try:
        S = input()
    except:
        exit()
    # 00000000: 037f010060010501000000016d736100  .asm.......`....
    start = len("00000000: ")
    end = start + len("037f010060010501000000016d736100")
    S = S[start:end + 1]
    
    print(S[24:31].replace(" ", "0"))
    print(S[16:23].replace(" ", "0"))
    print(S[8 :15].replace(" ", "0"))
    print(S[0 : 7].replace(" ", "0"))