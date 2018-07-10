Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjLwpu63pDcRSSnwNkGobhHHf0pJ=Kea=0_c1SQGTiQVQ@mail.gmail.com>
References: <CALLuPvo2sS4Lv02EFwcYGJyoSdFEra_7_Mj1cE239-c0JrQuJQ@mail.gmail.com>
 <CAOQ4uxhrvavKkrPLrdSPSm6fze_aaDSrEp2c2VS5OkYaU4Ti6w@mail.gmail.com>
 <100530df1e875091b22ba05bbd578bc5b53db93c.camel@kernel.org>
 <CAOQ4uxhC2cu=MXBO82+_g2q4u6xko6X_NPkGBwO4iUPNfeGAyg@mail.gmail.com>
 <CALLuPvr-ajdTwkeN1UOSxdxWsXNPLP3V-cCFtC9xgBnb+mah3g@mail.gmail.com>
 <CAOQ4uxju2=ozN7t4xUs4m0VFCbiqroUg8Qu=UbCwHo9xBY39xw@mail.gmail.com>
 <CALLuPvqEvAP-TmGArvToXpBM-o4CyO9OkWAALg0t4fkk_FXMiw@mail.gmail.com>
 <de1a0d2657adc3100f184dd5f7657352bdff7d29.camel@kernel.org>
 <CAOQ4uxg0TMmidCW1+=ukCX-Ji6s4Mo9poA-f2=Rm0C6i1ytczw@mail.gmail.com>
 <c4e00432009d22aa4ffd7bd0f2c3ea031872f552.camel@kernel.org>
 <CAOQ4uxgAzB37NM7JeZr-UfVTmpJgQsstq4r8RJ8V-3NxJ7+0kg@mail.gmail.com>
 <05e12bd95a8c46c29ab1e4571142e15125533ed5.camel@kernel.org> <CAOQ4uxjLwpu63pDcRSSnwNkGobhHHf0pJ=Kea=0_c1SQGTiQVQ@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Tue, 10 Jul 2018 13:18:19 +0800
Message-ID: <CALLuPvr3oXs5uTjvjkB0aF9cBM66keGvj4JJHhqkR34QBMz1HA@mail.gmail.com>
Subject: Re: Leaked POSIX lock warning and crash
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

2018-07-10 0:08 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
> Well, Miklos' changes should make it "just work".
>
> However, I audited the file_inode() instances in nfsd/lockd and
> the following "patch" may "just as well work":
>
> sed -i 's/\<file_inode\>/locks_inode/g' fs/nfsd/nfs4state.c
> include/linux/lockd/lockd.h fs/lockd/*.c
>
> Eddie,
>
> Will you give this a try?
> If it work I will post it for v4.18 and for stable.
>

This sed replacement patch works like a charm, based on v4.18 with
the patch, there's no Leaked message nor lock failure any more through
android builds.

Thanks,
Eddie
