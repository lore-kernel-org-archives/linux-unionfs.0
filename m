From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/3] Overlayfs restoring of origin fh
Date: Thu, 9 Nov 2017 13:33:19 +0200
Message-ID: <CAOQ4uxg7e5KvuTdeAd=H-hEz6+SYUS96TDDEOLtYg+egyAZtkQ@mail.gmail.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com> <CAJfpegu__w=VnxxVhm=FtGCUFkNdjLdB56S2tQ6mMTwwEqPV0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:45900 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753619AbdKILdU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 06:33:20 -0500
Received: by mail-yw0-f194.google.com with SMTP id c186so2382113ywb.2
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Nov 2017 03:33:19 -0800 (PST)
In-Reply-To: <CAJfpegu__w=VnxxVhm=FtGCUFkNdjLdB56S2tQ6mMTwwEqPV0w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Nov 9, 2017 at 12:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Nov 7, 2017 at 10:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This series is complementary to the whiteouts expose patches.
>> Patch 2 restores origin xattr on lookup of merge dir (that was copied up
>> before v4.12).
>> Patch 3 sets a 'null' origin fh on dir if we happen to iterate an 'impure'
>> dir and find a whiteout while looking for copy ups. This is expected to
>> happen if merge dir was copied up before v4.12, but files inside it were
>> copied up after v4.12.
>
> Applied 1/3.
>
> Does the other two patches have any real usecase?   AFAICS this is not
> fixing a backward compatibility issue, so I'm sceptical of the value.

No real usecase for me. I don't mind if they stay out, but I'll
explain why I posted them.

Patch 2/3 is just pieces from 'verify_dir' patches, so I figured it
may be useful
on its own for this purpose.

Patch 3/3 is just something I saw as 'low hanging' - if we lookup impure files
anyway and detect a whiteouts - there is a proper response, so why not use it?

All copy ups since v4.12 mark the parent dir "impure", but not "origin"
what's the logic in taking care of impurity of parent on copy up and not taking
care of parent whiteouts?

So I see these patches as "consistent behavior" patches, rather than any MUST.

Could be handled by fsck.overlayfs, which should also handle migration of
origin file handles to new location anyway.

Cheers,
Amir.
