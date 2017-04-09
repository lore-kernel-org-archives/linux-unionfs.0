From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: copy up questions
Date: Sun, 9 Apr 2017 11:43:12 +0300
Message-ID: <CAOQ4uxgWAOqUNHaNBTtL49PEshQuL9SAa9Ec0F63J-LM8KH7Uw@mail.gmail.com>
References: <CAL-1w2sXhnGVW5-3AyUgSjEy4ebk1ftDzoaadhn9n4_Qf7kD8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35735 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdDIInN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 9 Apr 2017 04:43:13 -0400
Received: by mail-oi0-f53.google.com with SMTP id l63so14343147oig.2
        for <linux-unionfs@vger.kernel.org>; Sun, 09 Apr 2017 01:43:13 -0700 (PDT)
In-Reply-To: <CAL-1w2sXhnGVW5-3AyUgSjEy4ebk1ftDzoaadhn9n4_Qf7kD8A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Richard Weinberger <richard@nod.at>

On Sat, Apr 8, 2017 at 3:45 PM, Rock Lee <rockdotlee@gmail.com> wrote:
>>> Hi:
>>>     I am reading the code of overlayfs and have some questions about co=
py-up.
>>> If a file which doesn't exist on upper directory is modified, this file=
 will
>>> be copied to work directory and then be renamed to upper directory.
>>>
>>> 1. It seems the whole file(in lower directory) will be copied, that wil=
l be
>>>     a big cost in time and space. Is there any way to just copy the
>>> modifed part?
>>>     Like "cp --reflink", keep the modified part in upper directory?

>> Already doing that since v4.10 see try to clone up in copy up data.
>
> Yes, this improvement is impressive. I was reading v4.9, because my
> raspberry pi is  still running this kernel. I am readling v4.10, but
> it seems only XFS and BTRFS support this clone operation.  I am a
> little surprised the UBIFS doesn't support clone, because like BTRFS=EF=
=BC=8C
> UBIFS uses b-tree to organize its data.

Well, that's a question for UBIFS folks [cc: Richard] , but I can tell
you this much
b-tree structure is a good starting point for reflink, but that
doesn't mean that
the implementation of reflink is trivial.

>>> 2. What's the purpose of renaming a file from work directory to upper d=
irectory?
>>>     Because rename is atomic?

>> Yes. Make new inode visible and persistent only after all data and metad=
ata
>> has been copied.

>>> 3. When you talk about "a persistent file handle", what's the exact
>>> form of "file handle",
>>>     is it "struct file * file"?

>>
>> Where do you see reference to persistent file handle?
>
> I got this in the subject -- overlayfs NFS export.
>

The the form is "struct file_handle", see:
http://man7.org/linux/man-pages/man2/open_by_handle_at.2.html

> One more question, when a file is copied up to upper directory, its
> inode number is changed(of course, it's a new file in upper), but this
> inode number change may be the nightmare for some applications.

Which applications? I know about issues with yum and tar in containers,
but judging by the way the community has dealt with this issues, I would't
say that the term "nightmare" applies.
I am not at all trying to convince that a fix is not needed, but if you kno=
w
about reasons that makes this specific behavior a show stopper for
some use cases, please do share this information.

> Is there any way to keep the inode number unchanged?

That's next on the TODO list:
https://github.com/amir73il/overlayfs/wiki/Overlayfs-TODO

Most recent ideas thrown around on this a few days ago:
http://www.spinics.net/lists/linux-unionfs/msg01745.html

The thing is that issues "constant ino" "consistent ro/rw fd" and
"persistent file handle" largely overlap, but are not equivalent.

I am currently focusing on a solution that will solve all 3 issue,
but only for access via nfsd.

Amir.
