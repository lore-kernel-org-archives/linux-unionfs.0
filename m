From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH] ovl: check lower ancestry on encode of lower dir
 file handle
Date: Fri, 16 Feb 2018 11:38:07 +0100
Message-ID: <CAJfpegv1CtAmBk-ZAXfymtkXLBnaWrq3yrD=NUUyxAZ1pGeVag@mail.gmail.com>
References: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
 <1517919700-29182-2-git-send-email-amir73il@gmail.com> <CAJfpegvqnhNiX3Cqux=Pa59TJ40ki5CEBDtjAnRravaTLgDzqg@mail.gmail.com>
 <CAOQ4uxgAtSi-OAkAfvBf+RQ0omNM1UtTbuQWPooM8ZJS++y9bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:42280 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933559AbeBPKiI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Feb 2018 05:38:08 -0500
Received: by mail-qk0-f196.google.com with SMTP id b130so3167061qkg.9
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Feb 2018 02:38:08 -0800 (PST)
In-Reply-To: <CAOQ4uxgAtSi-OAkAfvBf+RQ0omNM1UtTbuQWPooM8ZJS++y9bw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Feb 15, 2018 at 6:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Feb 15, 2018 at 6:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Feb 6, 2018 at 1:21 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>>> +static int ovl_dentry_connectable_layer(struct dentry *dentry)
>>> +{
>>> +       struct ovl_entry *oe = OVL_E(dentry);
>>> +
>>> +       /* We can get overlay root from root of any layer */
>>> +       if (dentry == dentry->d_sb->s_root)
>>> +               return oe->numlower;
>>> +
>>> +       /* We cannot get upper/overlay path from non-indexed lower dentry */
>>> +       if (ovl_dentry_upper(dentry) &&
>>
>> Code is contradicting comment.  I guess code is wrong?
>>
>
>
> This is patch v1, but already posted patch v2 with a bug fix.

I was actually reviewing the git commit (which should be v2), but
apparently found the wrong mail to reply to.

> patch v2 has a comment above this function:
> /* Return 0 for upper file handle, > 0 for lower file handle or < 0 on error. */
>
> N-connectable means you can get from layer <= N to overlay path.
> Returning 0 here mean 0-connected, meaning only upper file handle
> can be decoded.
>
> What do you find contradicting in code/comment?

The comment says "non-indexed lower dentry", the code says
"non-indexed upper dentry".

But I think I see what you meant: "non-indexed merge dir", right?

>
>>> +           !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>>> +               return 0;
>>> +
>>> +       /* Pure upper cannot be ancestor of non pure upper */

Not true.  We can have a redirected dir inside a non-merge dir (but we
don't call that pure, and it's not purity you are testing here, but
non-mergeness).

What cannot happen is that a lower dentry has a non-merge parent.

>>> +       if (WARN_ON(!oe->numlower))
>>> +               return 0;

But we've already returned zero for the non-merge upper case, without
any warning.  So in this form, the warning makes no sense (probably
should just be removed).

Other than this, I think the code is fine, only the comments are confusing.

Thanks,
Miklos
