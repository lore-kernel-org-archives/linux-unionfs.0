From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Thu, 4 May 2017 14:59:03 +0300
Message-ID: <CAOQ4uxi_h8cs67GyT3XnnQD0CoZEAA-TqBiTCsjPxHGxN9ZK7A@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
 <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
 <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
 <CAJfpeguVxbEQLqnz6t1sjbG5J5hWpqgqOw7qdtEZGSxd7j+y4A@mail.gmail.com> <CAOQ4uxiwumOLyVgzoT4pR_Lv08aGreZQNN-xW4OEpYCyxBHffg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35766 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753385AbdEDL7F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 07:59:05 -0400
In-Reply-To: <CAOQ4uxiwumOLyVgzoT4pR_Lv08aGreZQNN-xW4OEpYCyxBHffg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, May 4, 2017 at 1:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, May 4, 2017 at 12:15 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> One more little detail: file handle byte order.  We store the fh in a
>> filesystem, which means it can be used by systems with different
>> endianness, which basically invalidates it. This scenario is highly
>> unlikely to happen in practice, so for simplicity perhaps we should
>> just store a bit into the origin structure indicating the byte order
>> used to create the file handle and verify it when using it.
>>
>> Thoughts?
>>
>
> Yes, just noticed this wrinkle myself.
>
> Ideal world though:
> file handles are exported over the network and should have been in
> network order.
> What if NFS server goes dead and a hot backup with different endianess
> takes over? (even less likely than our use case).
> Theoretically, filesystems could still be fixed to export (i.e.
> ino/generation) in
> network order, but that's not very practical for the question at hand.
>
> Practical thought:
> Instead of storing endieness bit in every single ovl_fh,
> Store this handle at upper root overlay.origin:
>
>
> #define OVL_ROOT_INO                2
>
> static const struct ovl_root_fh {
>        struct ovl_fh hdr;
>        ino_t ino;
> } root_fh = {
>     .hdr = {
>        .version = OVL_FH_VERSION,
>        .magic = OVL_FH_MAGIC,
>        .type = FILEID_ROOT,
>        .len = sizeof(struct ovl_fh) + sizeof(ino_t),
>     },
>     .ino = OVL_ROOT_INO,
> };
>
> I realize that storing an integer overlay.one is 'simpler',
> but I'm withdrawn to (my idea of) elegance...
>

If you do like the idea, let me know if you want me to send a patch on
top of v5.

Do you plan to push v5 (+ "else if" bugfix) to overlayfs-next?

If we go for my solution to endianess, we can add that patch
as a fix patch (same goes for null uuid).

Amir.
