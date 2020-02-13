Return-Path: <SRS0=acKK=4B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7564FC352A3
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Feb 2020 21:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4910020848
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Feb 2020 21:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tC6Wa+Xa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgBMV2V (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 16:28:21 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40975 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbgBMV2V (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Feb 2020 16:28:21 -0500
Received: by mail-io1-f68.google.com with SMTP id m25so8186449ioo.8
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Feb 2020 13:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IUJ+3dsyE5kQgJ6tlZAAMa/21qNmhTZOroCGoxIcyEU=;
        b=tC6Wa+Xa2XzwouER8i5xPb7oQRyvem0EJNmQ99tw7x44PG9hQXksLi3pmr0XYOM9J/
         fEAs2C3LYbq5PcPszCNnxBi0hbx3ftyhc25yY3bapRFe5OfIdWxTpqRo44bN6um5n6WU
         7jh1bk4RZvnb/V0IYRK6G2Zl1e7gEde6cbkI/qmMdPRrawuXKFByPSsz/M5ooubN/S1V
         g5RBfsFAahHg8rDY2KMNw/XUCux3oA0kBqRDcj82UEy6KhonrKYre4SKxNmlRUgPRLRK
         5aXXwJzz0k9p2sVSWmMfkj7Rbv9mIqLhz5kgsg7UqpWVu+Id3WCAyNQVHctFwvzUYEsh
         VcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IUJ+3dsyE5kQgJ6tlZAAMa/21qNmhTZOroCGoxIcyEU=;
        b=DI2l/aEpCdub98lglQoza8vw7DIiZyVFXuWYidOMTpksXqCeUupN4Pocpo+dz7EHP9
         PgNJLQQ3teY/58z1FFbkECf0AmJm5BgAP3iunEpioXpyT8tyshTB47BmiDD/JDTEPkZI
         2/H/u7kQQAp0OEF7GvUAxzZPCZ1wx3SRWayDas3PzKXmdP1xnlbQPBTRWu0rL3rcN/Ar
         XQ0jkx+ne5fWZiioXGM7g70zdVm9yUbfqBdPcpThfiRlvuzCgW+lwTt1SgK0Iq7iKqHa
         pkfrHnRxqIMlt/tmzIyDGha1TqO6qi9bp0sNFvOmMLBMq1z/FI+Npf2I5JEmjHkAiAmF
         qlHA==
X-Gm-Message-State: APjAAAXme2XJ3V0Ubs3hKQmA44grphCClWhls84GR1xw2XVPS3062bWC
        XIERq1VpDxRNPRJZxp2VUSxlttxyTvLlrMzBXJk=
X-Google-Smtp-Source: APXvYqwRF5HwnL9Z0iO8AdESz64otFJgYXhhAaIaOHxQpzDVpYdlz1fv2SL5zNCXQPgWVKpchSiMETOiuOzK00eJfoI=
X-Received: by 2002:a5d:9c8c:: with SMTP id p12mr24016514iop.72.1581629301060;
 Thu, 13 Feb 2020 13:28:21 -0800 (PST)
MIME-Version: 1.0
References: <20200210031047.61211-1-cgxu519@mykernel.net> <CAJfpegvut0xPswJfy_s5EnHR9n6db+7GK9vFs+ZO8e1H6WziHg@mail.gmail.com>
In-Reply-To: <CAJfpegvut0xPswJfy_s5EnHR9n6db+7GK9vFs+ZO8e1H6WziHg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Feb 2020 23:28:10 +0200
Message-ID: <CAOQ4uxi0MLwer8-+jprx6Tn2==TZUzqS5qptQyy5ZYa+d+4uBQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: copy-up on MAP_SHARED
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Feb 13, 2020 at 9:12 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Feb 10, 2020 at 4:11 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> >  static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> >         struct file *realfile = file->private_data;
> >         const struct cred *old_cred;
> > +       struct inode *inode = file->f_inode;
> > +       struct ovl_copy_up_work ovl_cuw;
> > +       DEFINE_WAIT_BIT(wait, &ovl_cuw.flags, OVL_COPY_UP_PENDING);
> > +       wait_queue_head_t *wqh;
> >         int ret;
> >
> > +       if (vma->vm_flags & MAP_SHARED &&
> > +                       ovl_copy_up_shared(file_inode(file)->i_sb)) {
> > +               ovl_cuw.err = 0;
> > +               ovl_cuw.flags = 0;
> > +               ovl_cuw.dentry = file_dentry(file);
> > +               set_bit(OVL_COPY_UP_PENDING, &ovl_cuw.flags);
> > +
> > +               wqh = bit_waitqueue(&ovl_cuw.flags, OVL_COPY_UP_PENDING);
> > +               prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> > +
> > +               INIT_WORK(&ovl_cuw.work, ovl_copy_up_work_fn);
> > +               schedule_work(&ovl_cuw.work);
> > +
> > +               schedule();
> > +               finish_wait(wqh, &wait.wq_entry);
>
> This just hides the bad lock dependency, it does not remove it.
>
> The solution we've come up with is arguably more complex, but it does
> fix this properly:  make overlay use its own address space operations
> in case of a shared map.
>
> Amir, I lost track, do you remember what's the status of this work?
>

I'm afraid it is still standing at the side of the road where we left it...
I haven't had any time to work on it since.

The latest WIP branch is at:
https://github.com/amir73il/linux/commits/ovl-aops-wip

And summary of what it contains is at:
https://lore.kernel.org/linux-unionfs/CAJfpegsyA4SjmtAEpkMoKsvgmW0CiEwWEAbU7v3yJztLKmC0Eg@mail.gmail.com/

Problem is, this WIP doesn't even solve the MAP_SHARED case yet,
but it is a big step in the direction of the design you laid out here:
https://lore.kernel.org/linux-unionfs/CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com/

Chengguang,

If you are up for the task, feel free to pick up the WIP branch
and bring it into shape for merging.
Then we can also discuss the next steps for fixing MAP_SHARED.

BTW, you did not mention why MAP_SHARED case is important
in your workload. I'm just curious how important is it to solve it.

Thanks,
Amir.
