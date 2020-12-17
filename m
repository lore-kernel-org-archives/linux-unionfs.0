Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A413C4361B
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 20:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DCA239FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 20:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgLQU0B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 15:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgLQU0B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 15:26:01 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB23EC0617B0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 12:25:20 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id m23so14034545ioy.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 12:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9InF5AX9RnmhRuG6A7VtjhBT7FM4uZS/FjiBjJOFlgA=;
        b=NEGfcUAUh8Q3n3smS6RWVO8bobwTIBMIqTLvZxoxK6+Wv00u7d/BxqWlS6do7eK7jV
         llLZX0/+JVlM0d4Ft3PSaPd2KWmMBzhwQHJfmOYRVI998lV5Hk5K1gFAdBYK7Sc4Mqu+
         552VWYzOmdmXZGaazAQ1RJ+Fl3VlXJ7sXi8hbJW1xc+NnlluQVU7zhrEFPSm5YPs+hUP
         bvZXsRvR/KC3GQ3MRKqJOjtZKHnYMpMPbJi0u8JUH7U7afl9c73xoA3dL0oPVHUSzd9V
         FsOsUlNdhCAImnKc2Qi0YcS55p/P+7CAWI6tsoIEWiOvE9scK1aI3geULPF5O8/64y3P
         9ZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9InF5AX9RnmhRuG6A7VtjhBT7FM4uZS/FjiBjJOFlgA=;
        b=ldVR69MYM3Nb5Qn/6eT550FHPzkTXUScJUxqjQnu0DV6QNmesZMV7n8JXiRpMx2oh+
         Ajy0BI4QWZar/H+VQSAey3gXsmQUD5CHcblWWIoNBFSIsNSKVkYwccvvsOkm7XTVTTPT
         Qkm/4fmNmC/HakJ4MjSVhlv3dgc+8QUjgg/DOqcL27nies/iF5yJ2bRytfEIRBJH4NxO
         YYCHEOQmOtCYmYNGEfd6CAEDJcUBQcdRayfu0MdxS39SdPpzHQU24FD2WW5ztodP5KXK
         cypWknaj6+1aGgvIl1rE/vpUkMM6fQTzbNJUVLhU/JgckYHT3Vbos40rU6icqNaDdB6/
         5MFQ==
X-Gm-Message-State: AOAM532IWChB1GULFkBPNygCz2A/zwsv9FULidOqadzRy2zv4LYmy68g
        CPOdX2Qj6+kSzNQzuwlg6fbVTxZFSXpU0v6py0Y=
X-Google-Smtp-Source: ABdhPJzcR8udmQcCnFEav1XCykIMCIMWPUzCMMMBcTW5fbh1Q83Upe/h1ydePEBc4omFWoKCUAf+WPbfKqNA8P5DBqc=
X-Received: by 2002:a02:9f19:: with SMTP id z25mr641147jal.30.1608236720147;
 Thu, 17 Dec 2020 12:25:20 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
 <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
 <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com>
 <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com> <CAOQxz3y8N6ny23iA1Fe0L4M1gR=FHP5xANZXquu4NSLoucorKw@mail.gmail.com>
In-Reply-To: <CAOQxz3y8N6ny23iA1Fe0L4M1gR=FHP5xANZXquu4NSLoucorKw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Dec 2020 22:25:08 +0200
Message-ID: <CAOQ4uxg++DkgcO9K6wkSn0p6QvvkwK0nvxBzSpNE6RdaCH3aQg@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael Labriola <michael.d.labriola@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Dec 17, 2020 at 9:46 PM Michael Labriola
<michael.d.labriola@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 1:07 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Thu, Dec 17, 2020 at 6:22 PM Michael Labriola
> *snip*
> > > On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so
> >
> > I honestly don't expect to find much in the existing overlay debug prints
> > but you never know..
> > I suspect you will have to add debug prints to find the problem.
>
> Ok, here goes.  I had to setup a new virtual machine that doesn't use
> overlayfs for its root filesystem because turning on dynamic debug
> gave way too much output for a nice controlled test.  It's exhibiting
> the same behavior as my previous tests (5.8 good, 5.9 bad).  The is
> with a freshly compiled 5.9.15 w/ CONFIG_OVERLAY_FS_XINO_AUTO turned
> off and CONFIG_DYNAMIC_DEBUG turned on.  Here's what we get:
>
>  echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
>  mount borky2.sqsh t
>  mount -t tmpfs tmp tt
>  mkdir -p tt/upper/{upper,work}
>  mount -t overlay -o \
>     lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
> [  164.505193] overlayfs: mkdir(work/work, 040000) = 0
> [  164.505204] overlayfs: tmpfile(work/work, 0100000) = 0
> [  164.505209] overlayfs: create(work/#3, 0100000) = 0
> [  164.505210] overlayfs: rename(work/#3, work/#4, 0x4)
> [  164.505216] overlayfs: unlink(work/#3) = 0
> [  164.505217] overlayfs: unlink(work/#4) = 0
> [  164.505221] overlayfs: setxattr(work/work,
> "trusted.overlay.opaque", "0", 1, 0x0) = 0
>
>  touch ttt/FOO
> touch: cannot touch 'ttt/FOO': No data available
> [  191.919498] overlayfs: setxattr(upper/upper,
> "trusted.overlay.impure", "y", 1, 0x0) = 0
> [  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
> [  191.919788] overlayfs: tmpfile(work/work, 0100644) = 0
>
> That give you any hints?  I'll start reading through the overlayfs
> code.  I've never actually looked at it, so I'll be planting printk
> calls at random.  ;-)

We have seen that open("FOO", O_WRONLY) fails
We know that FOO is lower at that time so that brings us to

ovl_open
  ovl_maybe_copy_up
    ovl_copy_up_flags
      ovl_copy_up_one
        ovl_do_copy_up
          ovl_set_impure
[  191.919498] overlayfs: setxattr(upper/upper,
"trusted.overlay.impure", "y", 1, 0x0) = 0
          ovl_copy_up_tmpfile
            ovl_do_tmpfile
[  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
            ovl_copy_up_inode
This must be were we fail and likely in:
              ovl_copy_xattr
                 vfs_getxattr
which can return -ENODATA, but it is not expected because the
xattrs returned by vfs_listxattr should exist...

So first guess would be to add a debug print for xattr 'name'
and return value of vfs_getxattr().

Good luck!
Thanks,
Amir.
