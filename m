From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 05/11] ovl: return dentry from ovl_create_real()
Date: Wed, 30 May 2018 10:28:54 +0200
Message-ID: <CAJfpeguYLeL6GCmtScw0fMGJFscCEWWUz=CQFrTBDssA9VKhWA@mail.gmail.com>
References: <20180529144143.16378-1-mszeredi@redhat.com> <20180529144143.16378-6-mszeredi@redhat.com>
 <CAOQ4uxh0XUgOZ-tZ_1jTxBLFAdWv53kamh-1=hTuLkVpEVA08w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxh0XUgOZ-tZ_1jTxBLFAdWv53kamh-1=hTuLkVpEVA08w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 5:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, May 29, 2018 at 5:41 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> From: Amir Goldstein <amir73il@gmail.com>
>>
>> Al Viro suggested to simplify callers of ovl_create_real() by
>> returning the created dentry (or ERR_PTR) from ovl_create_real().
>> This prep patch makes Al's patch change less callers.
>>
>> Also used ovl_create_temp() in ovl_create_index() instead of calling
>> ovl_do_mkdir() directly, so now all callers of ovl_do_mkdir() are routed
>> through ovl_create_real(), which paves the way for Al's fix for non-hashed
>> result from vfs_mkdir().
>>
>
> It's good that you split this patch from ovl_create_temp() patch, but
> the commit message it utterly not related to the patch anymore and
> possibly should retain Al's authorship cause there is no relic of my
> work in this patch.

Fixed headers and authorship assignments.

Thanks,
Miklos
