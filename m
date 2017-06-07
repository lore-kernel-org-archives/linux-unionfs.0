From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/20] Overlayfs inodes index
Date: Wed, 7 Jun 2017 10:58:40 +0300
Message-ID: <CAOQ4uxiQ6y-_toUG9Hg3Nwi2-=1y-=4PZgkh6dXc6j66kedw1w@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com> <CAJfpegtumk2vqzaNge-W=1PB2C8wv7Zds6XUpLot9CMreiFW_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33756 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdFGH6m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:58:42 -0400
In-Reply-To: <CAJfpegtumk2vqzaNge-W=1PB2C8wv7Zds6XUpLot9CMreiFW_w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jun 7, 2017 at 10:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jun 7, 2017 at 9:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This set is an independent series a top of current overlayfs-next.
>> I yanked all the dependencies from previous postings (consistent d_ino,
>> dir_lock, verify_lower) and included everything needed in this posting.
>>
>> This work introcuding the inodes index opt-in feature, which provides:
>> - Hardlinks are not broken on copy up
>> - Infrastructure for overlayfs NFS export
>>
>> Hardlink copy up tests including concurrent copy up of lower hardlinks
>> are available on my xfstests dev branch [1].
>>
>> There are some more TODO items before this is ready for v4.13, but I'd
>> love to hear what you think about the direction this has taken so far.
>
> Do you have a public branch for this?

https://github.com/amir73il/linux/commits/ovl-hardlinks

(it includes 4 unrelated vfs/tmpfs patches)

Thanks,
Amir.
