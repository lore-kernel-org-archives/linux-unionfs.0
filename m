Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34484 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728806AbeLMMQr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Dec 2018 07:16:47 -0500
MIME-Version: 1.0
References: <20181213115717.p7ncktng2ihxw5md@merlin> <20181213121000.GM2217@ZenIV.linux.org.uk>
In-Reply-To: <20181213121000.GM2217@ZenIV.linux.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Dec 2018 14:16:35 +0200
Message-ID: <CAOQ4uxjcX0UYptiGjwpQHSEQW0o85Jbxzgp+5t_SODM5DBeC0g@mail.gmail.com>
Subject: Re: [PATCH] fs: Evaluate O_WRONLY | O_RDWR to O_RDWR
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, zohar@linux.ibm.com, syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com, linux-integrity@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Dec 13, 2018 at 2:10 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Dec 13, 2018 at 05:57:17AM -0600, Goldwyn Rodrigues wrote:
> > A user can open(O_WRONLY | O_RDWR) and the options are valid.
> > However, OPEN_FMODE() evaluates both FMODE_READ and FMODE_WRITE,
> > as negative. We also need to protect the lower layers from this
> > anomaly.
> >
> > Solve it by dropping O_WRONLY, so O_RDWR takes precedence.
>
> Congratulations, you've broken fdutils...  Passing 3 in lower bits
> of open() flags is *not* the same as O_RDWR; behaiviour is
> different and deliberately chosen by existing userland code.
>
> IOW, NAK.

Yap, sorry, I missed FMODE_WRITE_IOCTL when I made this suggestion.
open mode 3 seems to be reserved to some special case of ioctl to floppy
block device.

I guess it would be simpler for you to accommodate for the special case
in ima_calc_file_hash() by masking out O_ACCMODE from flags before
adding O_RDONLY.

Thanks,
Amir.
