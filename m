From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Fri, 5 May 2017 12:58:48 +0300
Message-ID: <CAOQ4uxipBEAsRQdUcWuDEZDutvG3Yrb4J2sHHRwu9Qgc5x4H2A@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
 <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
 <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
 <CAJfpeguVxbEQLqnz6t1sjbG5J5hWpqgqOw7qdtEZGSxd7j+y4A@mail.gmail.com>
 <CAOQ4uxiwumOLyVgzoT4pR_Lv08aGreZQNN-xW4OEpYCyxBHffg@mail.gmail.com>
 <CAOQ4uxi_h8cs67GyT3XnnQD0CoZEAA-TqBiTCsjPxHGxN9ZK7A@mail.gmail.com>
 <CAJfpegsDnUuPped_LJY_QfS1zqqoQ5=dW5H5yjU55mxkAawHCQ@mail.gmail.com>
 <CAOQ4uxiYF3QxB2ksQRJDqSrxJ3Lm8MfEe8AF+mp0v7dBrSopLA@mail.gmail.com>
 <CAJfpegtZHOO2oB8YSeQoEHiXK-aTYOw_083riABQmiZ_75m92Q@mail.gmail.com>
 <CAOQ4uxitv9FcZO9Ch-3dx0vPZTpZMxcRo=WmCRxj7fUqNJqCGg@mail.gmail.com>
 <CAOQ4uxhy0+XG-J5YUqyi0ZWnuc5m=z_Jy1JQfv=-5VfduAiERQ@mail.gmail.com> <CAJfpegug-JQdJxKcn93vWQdrFFJZ4dBm3SgAooF2V2i29UzRJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34051 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdEEJ6u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2017 05:58:50 -0400
In-Reply-To: <CAJfpegug-JQdJxKcn93vWQdrFFJZ4dBm3SgAooF2V2i29UzRJw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, May 5, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, May 5, 2017 at 9:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, May 5, 2017 at 10:25 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>> You also forgot to mention in changes since v6:
>>>
>>>    - store 'null' fh instead of 'invalid' fh
>>
>> And w.r.t. that change, the following comment in ovl_get_origin()
>> is a bit confusing now, because the comment referring to
>> 'invalid' file handles was removed from the function.
>>
>> /* Treat empty origin as "invalid" */
>
> Okay, with cosmetic fixes pushed to overlayfs-next.

Looks good.

>
> I renamed OVL_TYPE_COPYUP to OVL_TYPE_ORIGIN, because, like you said,
> the meaning is slightly different.  COPYUP means it has been copied
> up, ORIGIN means we have a dentry pointing to the origin.
>

Ack.

Thanks,
Amir.
