while True:
    S = None
    try:
        S = input()
    except:
        exit()
    # 00000000: 037f010060010501000000016d736100  .asm.......`....
    start = len("00000000: ")
    end = start + len("037f010060010501000000016d736100")
    S = S[start:end]
    
    print(S[24:32].replace(" ", "0"))
    print(S[16:24].replace(" ", "0"))
    print(S[8 :16].replace(" ", "0"))
    print(S[0 : 8].replace(" ", "0"))
