From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Wed, 10 May 2017 13:09:55 +0300
Message-ID: <CAOQ4uxjojOMj8XO8xdshdDSwbbDZo48M5FTDfgE=MKT_EEZ5hQ@mail.gmail.com>
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
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35981 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdEJKJ4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 May 2017 06:09:56 -0400
In-Reply-To: <CAJfpegu3sWEGR1nkjSviFDXajqiMnJxXnDa4Qh2RjuP8AB8DLA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 10, 2017 at 12:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, May 10, 2017 at 10:58 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> Is it too soon to nudge you about the pull request? ;-)
>
> I'll have a look.
>
> My plan is to send a pull request to Linus for the const ino stuff,
> and then leave the rest to 4.13.
>

Sure, no rush about verify_lower, I just meant to nudge about the pull
request for const ino.

> This is the list I have in my head for what's missing:
>
> - lookup origin dir for snapshots
> - const ino for non-samefs
> - correct d_ino for copied up entries
> - NFS export support
> - hardlink unbreaking
> - sharing pages for reflink (*)
> - ro/rw correctness for samefs with temp reflink (**)
> - sharing pages in the general case (*)
>

Just updated TODO with the a similar list yesterday ;)
https://github.com/amir73il/overlayfs/wiki/Overlayfs-TODO

> (*) very preliminary design
> (**) need to check overhead: I have a feeling that it's a heavyweight
> solution for a tiny problem
>

I am hoping to reduce the code complexity (of rocopyup) after
we have the workdir/inodes/ index, because taking care of
rocopyup/rwcopyup races can be similar to taking care of
link/unlink/link races... we'll see how it goes.

The read pages performance overhead should be reasonable with
sharing pages.

The inode create/delete overhead is something we will need to measure,
but from my experience with xfs, I suspect that the cost is going to be
fair enough that some people would like to pay it to get the "tiny" problem
solved.

Also, the "tiny" problem is also going to be manifested with hardlinks
copy up, where it may need to be fixed anyway.
see this commit message for the details:
https://github.com/amir73il/linux/commit/62a16f3389187d3c3efa22293bf65cdb7bd619c5



> The non-starred ones don't seem too hard and should aim for 4.13.
>

Indeed. I am going to start with hardlinks and const d_ino soon.
The case of non-dir is easier to handle first because:
1. workdir/inodes/#lower_ino is a hard link to upper,
    so fewer follow by file handles involved
2. const d_ino for directory is not very interesting -
    'find' always uses stat() to get inode number of directory,
    so 'find -ino N' is not affected by non-const dir d_ino.

Cheers,
Amir.
