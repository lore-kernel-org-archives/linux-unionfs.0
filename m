From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix EIO from lookup of non-indexed upper
Date: Tue, 24 Oct 2017 13:15:58 +0300
Message-ID: <CAOQ4uxiJ8L_x4Jsc-Fsf47Zc15x9zpCOr3TGt4Ws40r3CUhpFA@mail.gmail.com>
References: <1507824184-6244-1-git-send-email-amir73il@gmail.com> <CAJfpegsLbJN84S=-KoBOpV-b_8p9AyoEWbc66nSSX_SRzeuiLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsLbJN84S=-KoBOpV-b_8p9AyoEWbc66nSSX_SRzeuiLQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Oct 24, 2017 at 12:59 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Oct 12, 2017 at 6:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Commit fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
>> attempt to avoid the condition of non-indexed upper inode with lower
>> hardlink as origin. If this condition is found, lookup returns EIO.
>>
>> The protection of commit mentioned above does not cover the case of lower
>> that is not a hardlink when it is copied up (with either index=off/on)
>> and then lower is hardlinked while overlay is offline.
>>
>> Changes to lower layer while overlayfs is offline should not result in
>> unexpected behavior, so a permanent EIO error after creating a link in
>> lower layer should not be considered as correct behavior.
>>
>> This fix replaces EIO error with a warning in cases where upper has
>> origin but no index is found, or index is found that does not match upper
>> inode. In those cases, lookup will not fail and the returned overlay
>> inode will be hashed by upper inode instead of by lower origin inode.
>>
>> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
>> Cc: <stable@vger.kernel.org> # v4.13
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Miklos,
>>
>> Following a discussion with Vivek about metacopy feature and the option
>> of setting ORIGIN for non-indexed lower hardlinks on copy up, I came to
>> a conclusion that the current EIO behavior is not quite tollerant to lower
>> changes as one would hope and that it should be fixed in stable kernels.
>
> Okay, but I started wondering if we really should be writing warnings
> to the kernel log if this situation is considered normal.
>
> Is it worth warning about these?
>

No I guess it is not worth it for plain index=on case, but it may be worth
it for upcoming index=all, which implies a complete index.
Although we can defer the warning to file handle encode time when that
matters.

BTW, I just sent a patch to remove the backward compatibility disclaimer
about OVERLAY_FS_INDEX  from Kconfig following the EIO change.
Maybe I was being too brave?...

Let me know if you want me to send a new patch for EIO behavior
or you will sort it out yourself (remember there is also the ENOENT case).

Amir.
