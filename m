Return-Path: <SRS0=acKK=4B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098E3C352A3
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Feb 2020 19:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E3C217F4
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Feb 2020 19:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="oTvIrUDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgBMTM5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 14:12:57 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46029 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbgBMTM5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Feb 2020 14:12:57 -0500
Received: by mail-il1-f194.google.com with SMTP id p8so5917469iln.12
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Feb 2020 11:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6d11/NahuqlMDkd3dC4NgOWFjrkMshXabstr5qgmvnc=;
        b=oTvIrUDgN1SdNm9+wEs18/VDA6iJyu7YJqbcMfQG/m6eNdaQaXoOnKlvB48UdXtDnl
         rgnvEzlfrRTI2ZY+8qAXFbCOaZlTZS6PpSyMO1uUuJx9AZUaT4jxGgDoYEUX3U05/CH2
         LS0dBMS1OWr7BY3iPPNeFrSbuuZKqaU7cvTUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6d11/NahuqlMDkd3dC4NgOWFjrkMshXabstr5qgmvnc=;
        b=HovUPuXk7iuFG9U9i9QDmIjMTx46JLSNH5ssr1DOUUFeN6Ti7noQoL/JxwPwkt744v
         3GtFyrUPoQz0Kxc+2H22CD8WZbDgeh5XlMby7P3xvq95hg5WPVOMCijD25I5iGxFTPEr
         MOwQ3/UhZ8hAFu8L+h/Ky3dodvNvbVobuM2sckSIZWNn6l/luj5lk8xqe3n5OTZqK+d/
         ZxIKKQwMkPcIz+FSWAjBTLQGIc5IakQ0dFp+Lw1bRnCQ2g65nWeTj7AafpqmwNPIFEm7
         jzfiXCkKekY4kciv3hmZX54sYVFXYzZdMMDdZf5e7wkDb0EcOude74Gh7hoZEvS9bo7o
         vzTw==
X-Gm-Message-State: APjAAAVv9P9Le42ty8jUlnRgKW3zqGMlQ5n6TtTecr5pgWlNg5LtDQry
        uiWN4gaeQWxneHeB7ApY/arBNLKEd+BKjm5ONZTR3Q==
X-Google-Smtp-Source: APXvYqznCGJJ9Kj0v6NhNlDp5BArqL7bsx+gnTClZ8XCAWhoV/EmtowF6cK5TJgBdtCml3WfLnufDvIXXX+7TxKOUeo=
X-Received: by 2002:a92:8847:: with SMTP id h68mr16882182ild.212.1581621176428;
 Thu, 13 Feb 2020 11:12:56 -0800 (PST)
MIME-Version: 1.0
References: <20200210031047.61211-1-cgxu519@mykernel.net>
In-Reply-To: <20200210031047.61211-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 13 Feb 2020 20:12:45 +0100
Message-ID: <CAJfpegvut0xPswJfy_s5EnHR9n6db+7GK9vFs+ZO8e1H6WziHg@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: copy-up on MAP_SHARED
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Feb 10, 2020 at 4:11 AM Chengguang Xu <cgxu519@mykernel.net> wrote:

>  static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>         struct file *realfile = file->private_data;
>         const struct cred *old_cred;
> +       struct inode *inode = file->f_inode;
> +       struct ovl_copy_up_work ovl_cuw;
> +       DEFINE_WAIT_BIT(wait, &ovl_cuw.flags, OVL_COPY_UP_PENDING);
> +       wait_queue_head_t *wqh;
>         int ret;
>
> +       if (vma->vm_flags & MAP_SHARED &&
> +                       ovl_copy_up_shared(file_inode(file)->i_sb)) {
> +               ovl_cuw.err = 0;
> +               ovl_cuw.flags = 0;
> +               ovl_cuw.dentry = file_dentry(file);
> +               set_bit(OVL_COPY_UP_PENDING, &ovl_cuw.flags);
> +
> +               wqh = bit_waitqueue(&ovl_cuw.flags, OVL_COPY_UP_PENDING);
> +               prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> +
> +               INIT_WORK(&ovl_cuw.work, ovl_copy_up_work_fn);
> +               schedule_work(&ovl_cuw.work);
> +
> +               schedule();
> +               finish_wait(wqh, &wait.wq_entry);

This just hides the bad lock dependency, it does not remove it.

The solution we've come up with is arguably more complex, but it does
fix this properly:  make overlay use its own address space operations
in case of a shared map.

Amir, I lost track, do you remember what's the status of this work?

Thanks,
Miklos
