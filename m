From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 16 Jan 2017 15:15:51 +0100
Message-ID: <CAJfpegvQrCHpxpy+Yw7z=P3jexrvFhSpq41w2NT2KXq46kOo-w@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
 <1484488652-611-2-git-send-email-amir73il@gmail.com> <CAJfpegtj7Hmxfmbm=GcNQRgXzpO88pzi5cqk-O1V6QGgCgLMWw@mail.gmail.com>
 <CAOQ4uxiPbLCadeRXa19kwF82PVsU75HRCUksjytwkH3qa-ZewQ@mail.gmail.com>
 <CAJfpegt67Zadny1evdpebdAQ3_QWvFYQgRNkP0O9+7iJta3qpQ@mail.gmail.com> <CAOQ4uxi040SvV=kQUy+pB7CFAjbQPfMVmKRFDjuuL3jeV_fMWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33737 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdAPOP5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:15:57 -0500
Received: by mail-oi0-f66.google.com with SMTP id j15so12651855oih.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Jan 2017 06:15:52 -0800 (PST)
In-Reply-To: <CAOQ4uxi040SvV=kQUy+pB7CFAjbQPfMVmKRFDjuuL3jeV_fMWA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 16, 2017 at 3:04 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> What I tried to do at first is leave d_alloc inside vfs_tmpfile()
> and return dentry, but I did not want this interface to deal with struct file
> as well.

Agreed, I think you should do that.

>
> so do_tmpfile() is very roughly equivalent to:
> path_lookupat()
> mnt_want_write()
> vfs_tmpfile() (including d_alloc)
> dentry_open()
> inode->i_state |= I_LINKABLE
>
> So I can set LINKABLE inside vfs_tmpfile() only if I also pass
> it open_flag

Yes.

> and then it would also happen before open returns
> success.

It doesn't matter.  If open fails the temporary file will be deleted,
dentry, inode and all.

Thanks,
Miklos
