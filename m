Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4178DC6FA82
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Sep 2022 17:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiIURmM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Sep 2022 13:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiIURmL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Sep 2022 13:42:11 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6A79E2CB
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Sep 2022 10:42:10 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id m65so7595920vsc.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Sep 2022 10:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=t8UYCJ1HocJaNmriH1sjH3VKARBnYLphoJUiry92idc=;
        b=oKTb/4F7iGCUlW8r9U5xAxo39xvAwa19Ee+Elk1ekZ8eJGgA09r8C3bv6qo1LQ1oLg
         03U6VX2pZ+P/BXT067ZCX3XLLg8at8/qMIU/No1tpEfD/9Ycpvqc2KeHjga+cPzj5iIZ
         ZGzSUwZryt6c0P7KDn35BbUZ2E7r1xQ+FrG6pS2JeNv6VA1pODS09eWckwEqzKzud+xQ
         F+ybc6sUk3Lss1t8XRCeSqT5Dp6rQXLh4WXj6f4mrYsNH+I2+94KvIU99fE0IY18pTEj
         O1iAi6bP+w5GMsw1ljnufAh4zQjuRZ8+IJ4aDlvw+rghG/u8EW0ry/xar6i5D/52OHHO
         02+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=t8UYCJ1HocJaNmriH1sjH3VKARBnYLphoJUiry92idc=;
        b=iV08ZNIp6v0dl9fCF7oWgBeL9+I48oReoqp3jIYgUEzG8JGcBdg7+YFeHkzCxd7FX8
         lHN333ODH+3+4hx0nExtZ6DQAW8cWaA2hL4ojrjL3uKmi5fhEljVorX/qvZvpVpKUvyd
         QwzS5XhZzuU2syVQrmudYd+FKtLLh6/Ns41QAH5tq8HCMeruB9Sd2vRNHIoAWKpkzWSF
         sxYwMhdirNpAXIJdmnEla32MgP8OFSIBoP9NQhv5If3Q0R3hI5M+oScKvENwIwYWirQL
         TJJxeApVlCZOvflgQ2Y+7I+7tt53RUOxotVVrKCESIR4QG3ZefIzt8EdEOcqTx928sWm
         pE9Q==
X-Gm-Message-State: ACrzQf0DhUfSsXgCscTlcU4nO3RyovVcut0Tg2GfX2Ptv0vKRr46gww5
        aCwg1tPO1HcsFbCVKvMXet0LJpHLK/gpxBdXHF8=
X-Google-Smtp-Source: AMsMyM7RlFwyXvuPa2Gp6mZqVT15Z20Oowk5AlPm/L1niLLEdt4muOV5MoelS200p64nEkhmapkcrEoq0dHD86IV9l0=
X-Received: by 2002:a67:a247:0:b0:39a:c318:3484 with SMTP id
 t7-20020a67a247000000b0039ac3183484mr9576673vsh.2.1663782129435; Wed, 21 Sep
 2022 10:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
 <CAOQ4uxj1V8EvJuEthaiZK102P8PX4idFmC0BSTuhabPQo6kD0g@mail.gmail.com> <MWHPR11MB191913944274BE566826A4BEF14F9@MWHPR11MB1919.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB191913944274BE566826A4BEF14F9@MWHPR11MB1919.namprd11.prod.outlook.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Sep 2022 20:41:57 +0300
Message-ID: <CAOQ4uxjFeV9CP7xLrCsWNMbZ3F1CKcea-Tr7Wnx95YLpkvUkzw@mail.gmail.com>
Subject: Re: Does overlay driver work if built in to the kernel?
To:     "Jie, Keyon" <keyon.jie@intel.com>
Cc:     Keyon Jie <yang.jie@linux.intel.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 21, 2022 at 5:48 PM Jie, Keyon <keyon.jie@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Amir Goldstein <amir73il@gmail.com>
> > Sent: Tuesday, September 20, 2022 11:50 PM
> > To: Keyon Jie <yang.jie@linux.intel.com>
> > Cc: Miklos Szeredi <miklos@szeredi.hu>; overlayfs <linux-
> > unionfs@vger.kernel.org>; Jie, Keyon <keyon.jie@intel.com>
> > Subject: Re: Does overlay driver work if built in to the kernel?
> >
> > On Wed, Sep 21, 2022 at 3:32 AM Keyon Jie <yang.jie@linux.intel.com>
> > wrote:
> > >
> > > Hi all,
> > >
> > > I am new to the overlayfs, I am hitting issues to make kernel modules
> > > work in a container environment where the Kubernetes feature really
> > need
> > > the overlayfs support.
> > >
> > > I figured out to make overlay driver built-in to the VM kernel (and then
> > > shared to the container), but looks like the Kubernetes always fail when
> > > trying to create overlayfs mounts, with errors like 'permission denied'.
> > >
> >
> > Usually, you want to look at the kernel log to see the reason for failure.
> > That is likely because the container is "unprivileged"
> > meaning not using the same uid 0 as the host.
> >
> > Don't know which kernel you are running, but overlayfs can be mounted
> > inside unprivileged container since kernel v5.11:
> >
> > https://lore.kernel.org/linux-
> > fsdevel/20201217142025.GB1236412@miu.piliscsaba.redhat.com/
>
> Thank you Amir.
> I am using v5.10 kernel, so looks I can try to backport some of the patches and try it again.
> I assume take the 10-commits series from Miklos should be enough?
>       vfs: move cap_convert_nscap() call into vfs_setxattr()
>       vfs: verify source area in vfs_dedupe_file_range_one()
>       ovl: check privs before decoding file handle
>       ovl: make ioctl() safe
>       ovl: simplify file splice
>       ovl: user xattr
>       ovl: do not fail when setting origin xattr
>       ovl: do not fail because of O_NOATIME
>       ovl: do not get metacopy for userxattr
>       ovl: unprivieged mounts
> https://lore.kernel.org/linux-fsdevel/1725e01a-4d4d-aecb-bad6-54aa220b4cd2@i-love.sakura.ne.jp/T/
>

Not sure you can try.
There may be other bug fixes that need backporting.
It is not recommended to backport such a feature by yourself.
You would be much better off taking or build a newer LTS kernel (e.g. 5.15.y)

Thanks,
Amir.
