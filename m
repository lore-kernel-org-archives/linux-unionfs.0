Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:53449 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbeK1BNG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 27 Nov 2018 20:13:06 -0500
Received: by mail-it1-f195.google.com with SMTP id g85so34361279ita.3
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Nov 2018 06:15:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj3s=17xB7Nkcav3cXZRQVFkiep0wqQXR9FG_NEE9onDg@mail.gmail.com>
References: <20181126163847.xy3acvltyeb75nb4@merlin> <1543320309.3902.137.camel@linux.ibm.com>
 <CAOQ4uxj3s=17xB7Nkcav3cXZRQVFkiep0wqQXR9FG_NEE9onDg@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 27 Nov 2018 15:14:41 +0100
Message-ID: <CACT4Y+YWPAVh3PFEfk6MBf3Wvi3_mdZDx__XcbG0JFfo4Yquhw@mail.gmail.com>
Subject: Re: [PATCH] IMA: Mask O_RDWR if FMODE_READ is set
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com, Mimi Zohar <zohar@linux.vnet.ibm.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, linux-integrity@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 27, 2018 at 3:06 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Nov 27, 2018 at 2:05 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>>
>> On Mon, 2018-11-26 at 10:38 -0600, Goldwyn Rodrigues wrote:
>> > A file can be opened with open(O_WRONLY | O_RDWR), so a FMORE_READ
>> > will not be set, and overlayfs will consider another copy_up() on the same
>> > file leading to a deadlock on mnt_want_write(). Fix it by masking
>> > O_RDWR while opening the file in read-only mode.
>>
>> Shouldn't the open itself fail if both O_WRONLY and O_RDWR are
>> specified?
>>
>
> Well, open doesn't fail, so what can you do? prove that no app out there
> is using this bizarre flag combination and return -EINVAL?
> You can try...
>
> BTW, the freakish thing about O_WRONLY | O_RDWR, is that it actually
> translates to !f->f_mode & FMODE_READ && !f->f_mode & FMODE_WRITE:
> OPEN_FMODE(1|2) = (3+1) & 3 = 0
>
> It would make more sense if O_WRONLY | O_RDWR would have the
> same result as O_RDWR, which is exactly what happens with
> ACC_MODE(flags) in build_open_flags().
> build_open_flags() would be a good place to check and fix this abnormality.

Good idea. Breaking userspace is not an option, but isolating lower
kernel levels from this sounds reasonable.
