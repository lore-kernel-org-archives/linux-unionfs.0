Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvWHJvqwFEHm+rJC9GP_rKPw_2q6YXKwM7_PBTDTBErfQ@mail.gmail.com>
References: <1523472268-16707-1-git-send-email-amir73il@gmail.com> <CAJfpegvWHJvqwFEHm+rJC9GP_rKPw_2q6YXKwM7_PBTDTBErfQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Apr 2018 15:52:55 +0300
Message-ID: <CAOQ4uxhpWbQDK7QnUODVJautejPQ9xK2Xo+2zQqK-8QkUfA2Eg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: set lower layer st_dev only if setting lower st_ino
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 12, 2018 at 1:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 11, 2018 at 8:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> For broken hardlinks, we do not return lower st_ino, so we should
>> also not return lower pseudo st_dev.
>>
>> Fixes: a0c5ad307ac0 ("ovl: relax same fs constraint for constant st_ino")
>> Cc: <stable@vger.kernel.org> #v4.15
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/inode.c | 24 +++++++++++++++---------
>>  1 file changed, 15 insertions(+), 9 deletions(-)
>>
>> Miklos,
>>
>> This is the bug fix on top of current overlayfs-next.
>> Since this patch will not apply to v4.15, I will send
>> backported v1 to stable after this is merged.
>>
>> If you prefer to rebase xino patches over v1 bugfix,
>> you can use this one as conflict resolution.
>
> Rebased and gone for a slightly different resolution, bug AFAIK the
> same result in terms of functionality.
>
> Please verify.
>

Looks good and verified.

Thanks,
Amir.
