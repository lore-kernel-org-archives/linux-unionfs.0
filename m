From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Thu, 4 May 2017 23:03:15 +0200
Message-ID: <CAJfpegtZHOO2oB8YSeQoEHiXK-aTYOw_083riABQmiZ_75m92Q@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
 <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
 <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
 <CAJfpeguVxbEQLqnz6t1sjbG5J5hWpqgqOw7qdtEZGSxd7j+y4A@mail.gmail.com>
 <CAOQ4uxiwumOLyVgzoT4pR_Lv08aGreZQNN-xW4OEpYCyxBHffg@mail.gmail.com>
 <CAOQ4uxi_h8cs67GyT3XnnQD0CoZEAA-TqBiTCsjPxHGxN9ZK7A@mail.gmail.com>
 <CAJfpegsDnUuPped_LJY_QfS1zqqoQ5=dW5H5yjU55mxkAawHCQ@mail.gmail.com> <CAOQ4uxiYF3QxB2ksQRJDqSrxJ3Lm8MfEe8AF+mp0v7dBrSopLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36305 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdEDVDR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 17:03:17 -0400
Received: by mail-io0-f180.google.com with SMTP id p80so37138785iop.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 14:03:17 -0700 (PDT)
In-Reply-To: <CAOQ4uxiYF3QxB2ksQRJDqSrxJ3Lm8MfEe8AF+mp0v7dBrSopLA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, May 4, 2017 at 4:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> One minor review comment.
>
> I used uuid_le_cmp(*uuid, NULL_UUID_LE) arbitrarily in my original patch,
> but if we want to stick to semantic sb->s_uuid is probably more accurately
> described as uuid_be, because filesystems most likely copy it in raw format
> from disk.
>
> This is purely semantic of course, but if you think that matters, may as well
> replace uuid_le with uuid_be.

Okay.

More changes:

  - use vfs_getattr() to get the lower inode number instead of
lower->d_inode->i_ino.  For one i_ino is 32bit on 32bit archs, while
kstat.ino is always 64bit

  - merge the dir and non-dir getattr, they look very similar now

Pushed to overlayfs-constino.v7

Thanks,
Miklos
