Return-Path: <SRS0=ptUf=DZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B50C433E7
	for <linux-unionfs@archiver.kernel.org>; Sun, 18 Oct 2020 07:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24AA208FE
	for <linux-unionfs@archiver.kernel.org>; Sun, 18 Oct 2020 07:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KeLK/C0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJRHxg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 18 Oct 2020 03:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgJRHxf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 18 Oct 2020 03:53:35 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB3DC061755
        for <linux-unionfs@vger.kernel.org>; Sun, 18 Oct 2020 00:53:35 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id n6so9253537ioc.12
        for <linux-unionfs@vger.kernel.org>; Sun, 18 Oct 2020 00:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ymMeEvGUB3+BPfwOj9ipwo3sqmtvJTUpPOyaGdPZg48=;
        b=KeLK/C0fVHkCQRr0PVNW5sVmnzYhiK2AhZwPGRA4JTRnoNEJLVqWMA4ycbE5AlQPCv
         8vC3tT/DFb4L0GVoaFxwnzRWGT4nbKoJ+w+R9YAYmGk8PdtzotKOaMLHW4cKw190FJCS
         vXwK3NZDcZxymsr66qZvrzI/tQUhsfeTod3THNOmdykLv9zLZilkS9zNcxNYB8Nn2Nar
         GDip7ElJDdquKCXtSiMc886ADg3WpDzzQIG24vITX6EIr4/MFErpj9tipbBz0F9Xr3r/
         /JniicXem5IcnC1IltcYg7DjL7AE9jmD8SuRakMioFSogNGJ6IIUX1Qqfrj6Efm2g4iE
         P9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ymMeEvGUB3+BPfwOj9ipwo3sqmtvJTUpPOyaGdPZg48=;
        b=Ohj0ccMbliMIm9TRrlX750uQjhtc9kyj4p9noNSdkZuwqzExyvUaD6bJLglxsjTc5+
         6tWpqPalV4PurvPum2h+yQXrw5GfLSzJMhgabVwxn/7zBfuZMlTxk+7jGMw6ohN7wioK
         lxlROAEaPp+CtAq3BzMWcBwPuW7r634d93VUWtRrRN+dj6PBaVDjenu7tJV8Y2+bfkDi
         MfErURbi26r5hBSyFytl4JOm2tmzGan4ElG2RyHXkVTqJT2PuzLpSjrm+m872nwAcDW2
         ecadji54Sc5kNT8rYbflL3S7i2Lpv5CMHR8IM7q6poiqts9nIC+n7uwQcdgAnGbgMo+t
         mKvg==
X-Gm-Message-State: AOAM533iGNPcbL6WSSA9zbwsW8Ysl/U+dg35kEaEAaCuLX0/iq7RVwCi
        5ncmQM48PwPwQx1DPOmq+/U5CoD0A7KlHHVtUFU=
X-Google-Smtp-Source: ABdhPJxE52+oxcbjlqHoa90w0+/sProkMU8NvKNr9E4jURtZ9+7cSu2LqO0u1MAb1K7GqNb1AQcHGqa5lFEeoUhYaxQ=
X-Received: by 2002:a6b:6b09:: with SMTP id g9mr7377422ioc.203.1603007614547;
 Sun, 18 Oct 2020 00:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201016155745.2876-1-cgxu519@mykernel.net>
In-Reply-To: <20201016155745.2876-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 18 Oct 2020 10:53:23 +0300
Message-ID: <CAOQ4uxha5-88Rzi9D_zy4aDG76qthfQgo3LrR=DmJYgM-vfbEQ@mail.gmail.com>
Subject: Re: (RESEND) [PATCH] ovl: stacked file operation for mmap
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 16, 2020 at 7:38 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Currently only mmap does not behave as stacked file operation,
> although in practice there is less change to open a file in
> RDONLY mode and take long time to do mmap but the fix looks
> reasonable.

I suppose you do not have a real life use case where this fix
is relevant?

The thing is that this change is not without consequence.
It could result in 2 overlapping mmaps on the same RDONLY fd
mapping a different file and it can be even more confusing
than different fd mapping different files.

It is not clear which non-standard behavior is preferred, so without
any evidence that one strange behavior is preferred over the other
I don't think we should change anything.

Thanks,
Amir.

>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> Hi Miklos,
>
> I'm sorry that I did a mistake about signed-off-by tag in previous
> email, so I resend this patch.
>
>  fs/overlayfs/file.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 3582c3ae819c..f98b1c0c975b 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -461,6 +461,7 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>         struct file *realfile = file->private_data;
>         const struct cred *old_cred;
> +       struct fd real;
>         int ret;
>
>         if (!realfile->f_op->mmap)
> @@ -469,7 +470,11 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>         if (WARN_ON(file != vma->vm_file))
>                 return -EIO;
>
> -       vma->vm_file = get_file(realfile);
> +       ret = ovl_real_fdget(file, &real);
> +       if (ret)
> +               return ret;
> +
> +       vma->vm_file = get_file(real.file);
>
>         old_cred = ovl_override_creds(file_inode(file)->i_sb);
>         ret = call_mmap(vma->vm_file, vma);
> @@ -477,13 +482,14 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>
>         if (ret) {
>                 /* Drop reference count from new vm_file value */
> -               fput(realfile);
> +               fput(real.file);
>         } else {
>                 /* Drop reference count from previous vm_file value */
>                 fput(file);
>         }
>
>         ovl_file_accessed(file);
> +       fdput(real);
>
>         return ret;
>  }
> --
> 2.26.2
>
>
