Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DD0C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Nov 2022 20:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKXUeJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 15:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKXUeI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2022 15:34:08 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66C9B70EC
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 12:34:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r26so1767985edc.10
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2022 12:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+zbdt+3aJ/puBsqwQA0QSSEIHoZCeyYKLKFOfyKPSpI=;
        b=QLUMjAXQ2fEkphOSVbRVLpIQyWa0NhYO3SAX0XGU1tP14KCRI6rg5di8LGjlRorP7u
         Fv6zFzIDcQfAy0wmSaWmoFXzVM0TTmzlS2Gsu2nyw8cvtfNzBliPOQeMV7qGPJfuFbLC
         Ulc8QldPJBMRfb9bpYCSt+MDLB+PP+cQJ+8W4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zbdt+3aJ/puBsqwQA0QSSEIHoZCeyYKLKFOfyKPSpI=;
        b=psXVfvxV01t34+3tipqTd18nSy2h0E8GDbYMkTptb0kH9Axpi1ejA/wVdUyTV6G6cj
         KbayjR2PCn+EpgR8WeFg0h33hL/wHa/kvCioVhPmktSv0IDgbbtwuATg7tuZu9OAK1TO
         FlX4z6MoGiCueNgRsTogL8twNQg+C6b9z1DfcBcY7thwMMUoMtzWcup6GcIX3bND1C9h
         UD5g/s4OZ7z/wbRa4FANOIp5HvdQK4NS68eGryP5fwgMObERMkBM4ZhvTv/+ZgkGIjWT
         TaFgA/pk5que6g03AXl9/ooeY7qx2rswPTIwUNghLIsqscQJ/Z/JesZ1doXsDCUbWt59
         9iZQ==
X-Gm-Message-State: ANoB5pn5X/nfDcEt4ePeVRhT+uqqUYRynvRmxCoeBAXAT0tKdqRdg6TW
        WqGZv6wfiiOqNYFgfGTrdcouSTDf/VeSko/UzFTETL7xXBg=
X-Google-Smtp-Source: AA0mqf6fdqwI0cS8RCosBZkrrlkXrH2sw8vgJawRYCTTkV6ECf84oA86pFY3q/0Ilo9qtsPH7028ypyDVo6RoIoCXC0=
X-Received: by 2002:a05:6402:e04:b0:469:e6ef:9164 with SMTP id
 h4-20020a0564020e0400b00469e6ef9164mr13510155edh.185.1669322045392; Thu, 24
 Nov 2022 12:34:05 -0800 (PST)
MIME-Version: 1.0
References: <2505800d-8625-dab0-576a-3a0221954ba3@leemhuis.info> <Y3+jz5CVA9S+h2+b@ZenIV>
In-Reply-To: <Y3+jz5CVA9S+h2+b@ZenIV>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 24 Nov 2022 21:33:54 +0100
Message-ID: <CAJfpeguqCrEbvv4d4jdOnczQ9VOf4u9sSghvnDOWvUb84fv6OQ@mail.gmail.com>
Subject: Re: [regression, bisected] Bug 216738 - Adding O_APPEND to O_RDWR
 with fcntl(fd, F_SETFL) does not work on overlayfs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Pierre Labastie <pierre.labastie@neuf.fr>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 24 Nov 2022 at 18:03, Al Viro <viro@zeniv.linux.org.uk> wrote:

> So basically we have this
> static int ovl_change_flags(struct file *file, unsigned int flags)
> {
>         struct inode *inode = file_inode(file);
>         int err;
>
>         flags &= OVL_SETFL_MASK;
>
>         if (((flags ^ file->f_flags) & O_APPEND) && IS_APPEND(inode))
>                 return -EPERM;
>
>         if ((flags & O_DIRECT) && !(file->f_mode & FMODE_CAN_ODIRECT))
>                 return -EINVAL;
>
>         if (file->f_op->check_flags) {
>                 err = file->f_op->check_flags(flags);
>                 if (err)
>                         return err;
>         }
>
>         spin_lock(&file->f_lock);
>         file->f_flags = (file->f_flags & ~OVL_SETFL_MASK) | flags;
>         spin_unlock(&file->f_lock);
>
>         return 0;
> }
> open-coding what setfl() would've done, without updating ->f_iocb_flags...
> Not hard to deal with...
>
> I could pick it in vfs.git #fixes, or Miklos could put it through his tree.
> Miklos, which way would you prefer that to go?

I'll pick this into #overlayfs-next, as a PR for this cycle is needed anyway.

Thanks,
Miklos
