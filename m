Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <3581e04c-f4c7-226a-f88b-ec0ea394aa8d@huawei.com>
References: <20171117054919.712-1-yi.zhang@huawei.com> <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
 <8d55fcce-ebbf-4779-87de-8406fe475073@huawei.com> <CAOQ4uxge7XzeJPDSdpQYEHH7iQwJD0-t78gHBbKtMUsO0dQrgw@mail.gmail.com>
 <3581e04c-f4c7-226a-f88b-ec0ea394aa8d@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 09:37:31 +0200
Message-ID: <CAOQ4uxh1ZXYyTiRXHGH1K9DyZrn8LLSdsqLvh+ueUwha_uYvxQ@mail.gmail.com>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 4:32 AM, yangerkun <yangerkun@huawei.com> wrote:
[...]
>>>
>>> In fsck.overlay, lower layer file/dir may be modified with there is not
>>> I_OVL_INUSE in lower layer, but we cannot check does lower layer mounted
>>> with I_OVL_INUSE.
>>>
>>
>> Can you list the possible modifications the fsck.overlay can do on lower
>> layer?
>> What exactly are we trying to protect from?
>
>
> A orphan whiteout and invalid redirect in lower layer will be removed
> automatic or ask user.
> Since we cannot change anything for lower layer when overlay has been
> mounted, so we need run fsck.overlay first before mount to ensure
> consistency.

FWIW, I don't think that removing orphan whiteouts and invalid redirects
from lower layer can cause any damage when overlayfs is mounted
(famous last words), but I agree that in principle we should avoid fsck
on layers while overlayfs is mounted.

How about this - by default, lower layers are considered read-only and
fsck -a won't modify them, only report errors. fsck -y can be used to force
fixing lower layers. Maybe another flag could be used to indicate that
lower layers could be modified.

>>
>>
>>> Maybe we need adopt another way? How about store pwd in ofs.config when
>>> we
>>> mount the overlay.
>>>
>>
>> I don't understand what that means.
>
>
> We can use the parameters passed in by fsck.overlay and current working
> directory to construct absolute path for lower layers and upper layer; but
> when we want to get the information about mounted overlayfs through
> mountinfo, we cannot construct the absolute path of lower layer and upper
> layer without the pwd when we mount an overlayfs.

I see. I think that dealing with paths is wrong. pwd is not enough,
you also need
to know the mount ns root path. It's just not good to use path as an identifier.

Thanks,
Amir.
