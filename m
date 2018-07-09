Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <c4e00432009d22aa4ffd7bd0f2c3ea031872f552.camel@kernel.org>
References: <CALLuPvo2sS4Lv02EFwcYGJyoSdFEra_7_Mj1cE239-c0JrQuJQ@mail.gmail.com>
 <CAOQ4uxhrvavKkrPLrdSPSm6fze_aaDSrEp2c2VS5OkYaU4Ti6w@mail.gmail.com>
 <100530df1e875091b22ba05bbd578bc5b53db93c.camel@kernel.org>
 <CAOQ4uxhC2cu=MXBO82+_g2q4u6xko6X_NPkGBwO4iUPNfeGAyg@mail.gmail.com>
 <CALLuPvr-ajdTwkeN1UOSxdxWsXNPLP3V-cCFtC9xgBnb+mah3g@mail.gmail.com>
 <CAOQ4uxju2=ozN7t4xUs4m0VFCbiqroUg8Qu=UbCwHo9xBY39xw@mail.gmail.com>
 <CALLuPvqEvAP-TmGArvToXpBM-o4CyO9OkWAALg0t4fkk_FXMiw@mail.gmail.com>
 <de1a0d2657adc3100f184dd5f7657352bdff7d29.camel@kernel.org>
 <CAOQ4uxg0TMmidCW1+=ukCX-Ji6s4Mo9poA-f2=Rm0C6i1ytczw@mail.gmail.com> <c4e00432009d22aa4ffd7bd0f2c3ea031872f552.camel@kernel.org>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Mon, 9 Jul 2018 20:57:21 +0800
Message-ID: <CALLuPvpNAetW2u6++WVrbbtm4avMd1fRt82NuhLKea1HpMQwYw@mail.gmail.com>
Subject: Re: Leaked POSIX lock warning and crash
Content-Type: text/plain; charset="UTF-8"
To: Jeff Layton <jlayton@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

2018-07-09 19:52 GMT+08:00 Jeff Layton <jlayton@kernel.org>:
> On Mon, 2018-07-09 at 14:22 +0300, Amir Goldstein wrote:
>> Eddie,
>>
>> This is NFS v4. Right?
>
> I think he said v3, which means NLM (lockd).
>
>> Do you wait until Android build completes before closing the
>> first reproducer fd?
>>
>> I suspect you can replace the effect of Android build with
>> drop_caches on the server.
>>
>> Jeff,
>>
>> Does knfsd hold a reference on the file/dentry/inode when
>> a lock is taken?
>>
>
> Given that he's using v3, it would actually be lockd in this case, but
> yes, it should hold a struct file reference by virtue of a nlm_file
> reference.
>
>> Assuming this is indeed a bug reproduced only with NFS+overlayfs
>> it sounds like overlay decode file handle fails to return the same
>> inode that knfd holds with the lock.
>
> That's a possibility.
> --
> Jeff Layton <jlayton@kernel.org>

Hi Jeff and Amir,
Thanks your addressing on this case.
Clairify couples of setup about my usage:
1. client is nfs v3
2. Without using overlay, the problem is not happening,
Compiling android over nfs v3 with server fs is ext4 is very common
use case in my working environment, so supposed overlay is the major
difference to produce this issue.
3. the simple reproducer waits android build completes then close the fd.
4. drop-caches instead of android build does not reproduce
I'll keep try it by your suggestions.

Thanks,
Eddie
