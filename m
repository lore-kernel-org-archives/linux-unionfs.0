From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Wed, 10 May 2017 19:00:58 +0300
Message-ID: <CAOQ4uxi6PVnDGRS9x9uZPFhMZg=tqOgbR1PJbmAg_ruk4aF_TQ@mail.gmail.com>
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
 <CAOQ4uxhy0+XG-J5YUqyi0ZWnuc5m=z_Jy1JQfv=-5VfduAiERQ@mail.gmail.com>
 <CAJfpegug-JQdJxKcn93vWQdrFFJZ4dBm3SgAooF2V2i29UzRJw@mail.gmail.com>
 <CAOQ4uxipBEAsRQdUcWuDEZDutvG3Yrb4J2sHHRwu9Qgc5x4H2A@mail.gmail.com>
 <CAOQ4uxhZxzTNqRo4xZxHeE1wOM=SdNAVrAdLh=BFMbuRnRKt7Q@mail.gmail.com> <CAJfpegu3sWEGR1nkjSviFDXajqiMnJxXnDa4Qh2RjuP8AB8DLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35966 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbdEJQBA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 May 2017 12:01:00 -0400
In-Reply-To: <CAJfpegu3sWEGR1nkjSviFDXajqiMnJxXnDa4Qh2RjuP8AB8DLA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 10, 2017 at 12:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
[...]
>
> My plan is to send a pull request to Linus for the const ino stuff,
> and then leave the rest to 4.13.
>
> This is the list I have in my head for what's missing:
>
> - lookup origin dir for snapshots
> - const ino for non-samefs
> - correct d_ino for copied up entries
> - NFS export support
> - hardlink unbreaking
[...]
>
> The non-starred ones don't seem too hard and should aim for 4.13.
>

Just to clarify, did you mean that we should aim for NFS export and hardlinks
for 4.13 for samefs? or non-samefs?
Because I can see how non-samefs is possible, but complicates the reverse
inode map, so I rather start with samefs.

It turns out that constant d_ino wasn't that hard.
It's quite an isolated patch based on your old overlay.ino POC, see:
https://github.com/amir73il/linux/tree/ovl-constino

Basically, it's working and I also have xfstests to verify it,
which I will post those and the patch later.

I think that the toll on readdir performance is not such a big problem,
because stat'ing the dir entries is served from cache, so 'ls -lR' is
not going to suffer, only 'find -ino' with cold cache will suffer.

There is still room for optimization for iterating 'very pure upper' dirs
(with no copy ups in them).

Amir.
