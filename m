From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs snapshots pre announce
Date: Tue, 6 Dec 2016 13:14:02 +0200
Message-ID: <CAOQ4uxjuFvsnSp_=m9cT4UnBCxiOrTfHCH9irF7JuH+-oZbv4A@mail.gmail.com>
References: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
 <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com>
 <CAJfpegtJ7pZNZA3op7iZwCPynYcSCGB6EZ3rZrmdc3zSKucdpA@mail.gmail.com>
 <CAOQ4uxi1-aC8YiBSxSvCzu7-8TJRGjwAn6DBgV3wWF+Vpwf5Ww@mail.gmail.com>
 <CAOQ4uxh-ZNDcv7sAxX-yaCN=_LLK6qRWpA6w3LScsL6K5S0vWA@mail.gmail.com> <CAJfpegva_u_PnhM+GtopuRF1-Oj9sq7orK3Ao3MLwtHiASPXqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36070 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbcLFLXC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Dec 2016 06:23:02 -0500
Received: by mail-wm0-f52.google.com with SMTP id g23so124898558wme.1
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Dec 2016 03:22:54 -0800 (PST)
In-Reply-To: <CAJfpegva_u_PnhM+GtopuRF1-Oj9sq7orK3Ao3MLwtHiASPXqg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Dec 6, 2016 at 12:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Dec 5, 2016 at 2:39 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> FYI, I implemented ./run --sn=N test
>> for recycling N snapshot as described above.
>>
>> 3 directory rename tests (rename-move-dir, rename-pop-dir,
>> rename-new-pop-dir) fail on snapshot consistency after 1 recycle
>> due to a problem I failed to anticipate - redirect by file handle skips
>> all middle layers and goes directly to master.
>
> Not sure I understand.   How does redirect/fh skip middle layers?  We
> need to merge contents of all layers, so skipping middle layers does
> not sound correct.
>

OK. it's easy enough to understand it if you realize why snapshots
MUST use redirect_fh and not as optimization.

With standard overlay, when you rename a dir in upper you must set
redirect (path and/or fh) *before* the first rename and never have to
deal with it on subsequent renames.

With reverse overlay, the same trick won't work. It is not feasible
to update redirect (by path) on upper dir on every rename of lower dir.
And there is no way to do it atomically with the lower rename.
So redirect_fh comes to the rescue. upper dir gets the lower fh
*before* the first lower dir rename. Then all subsequent lower dir
renames are invariant to the stored fh. snapshot lookup can always
find lower dir by fh, regardless on how many times it was renamed.
Removal of lower dir, BTW, will result in ESTALE which translates to
ENOENT in layers lookup, so result is pure upper dir for snapshot.

All this works quite well for a single snapshot, but breaks with the
second snapshot. upper/0 is rotated to the top level of the snapshots
stack and upper/1 becomes the 'master' snapshot.
Subsequent renames of lower dir will trigger copy up to upper/1 with
storing of lower dir fh. But the new directory created in upper/1 is not
referenced by fh from upper/0. The lower directory is.

As for solution. *If* we had an efficient way to lookup
"which inode in this layer represents inode X in lower layer",
then we would have a solution for:
1. Reverse redirect dir (lookup the inode in upper/1 which represents
    the lower dir inode that we have from fh stored in upper/0)
2. Hardlinks copy up (did we already copy up another alias of inode X
    to this layer)
3. Stable file handles for NFS export (lookup the upper most
    representation of lower inode X)
4. Optimized readdir d_ino (requires the opposite map "which inode
    in lower is the base for inode Y in this layer).

So as far as I can tell, all the problem above are bound together
by the need for inode map indexing. Not sure if you think that's a good
idea, whether you can think of another idea or what's the best way
to implement such a map would be.

As usual, hope I was able to clarify rather then complicate further..
Amir.
