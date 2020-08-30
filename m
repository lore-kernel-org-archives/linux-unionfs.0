Return-Path: <SRS0=vlVb=CI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D54C433E6
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB5E207DA
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 11:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qTI3n78Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgH3Ld2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 07:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgH3LdZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Aug 2020 07:33:25 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA74C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 04:33:23 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id k4so4248756ilr.12
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 04:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iiFFxC5gMkxwxc2psHpScg1tLsy+yg77+1+dF7n2gmQ=;
        b=qTI3n78YnhNXnZLw+gaFRBk2FR4zPEaRZZ0DQxI6pE3gbGwgWaYTgbVpcqg/qjl8+a
         OYwQSxGagsR4XUY/qjtVF/eKaRREJCA+rvyl2qFu7K0947/Hekg9UgKJ9Ntkyzi7n3hh
         HA9RGK1qt+e4kiQ3vRuicwrb/lnme+NvpvCTJ8+lX4uwOjfKNFeRO65EKsYoNYp+KVUy
         2pg0d22eUqL03Qbamb/n4IWNyzo+9I3jGmOJFVcOQuY3t+kJR90t+KKBR2s3lHx+LhbM
         oZdVNnmwuoe4pB3T0E+yHtyKXKTvWFhiO+ROOaqHWAzdEiOFY3B/5VqKm3W5F9HqT+Gt
         8YYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iiFFxC5gMkxwxc2psHpScg1tLsy+yg77+1+dF7n2gmQ=;
        b=RGIgl8DBidUelNgAB0NVG4xbp8MSbRDEQn4yHXslCuYfcyIgf4b3Wdpg/AH3R8p4Gf
         rTHAlo4sS/9XB8oBnprH6uTj0tsD/YGxp9MRkgqCZHIt2fM5DLsdL3pfnsTBRPqCAyFS
         pud/8+VRfXnH02NEch+VFgXJMKBdO0nXPTzDRIGujnZUHWXUL6gky6qw4U5jRABcKWVp
         /yD99r9R0TNKiehbNZxsQVczOjB9eR0lqPvU/NkpPZkZxtRBjl76M1Fba+Z4MiIhzzM4
         KNwV4/ElmUEtLbOHf7qkdwJ4tW/8iLI1tuc+5UMgveWMhUNO6SSz95j8/Sp1SjD5WmlU
         vHkg==
X-Gm-Message-State: AOAM530+cdoZrQ9LIGK3Pp7IuPl0vI6yFwNGd/hxVTFjn1PcCnrHS4ku
        PimCpfD7MRtLUPyELQ7pmx/HbiyJSJUmznWWZyWm+rWIqQ4=
X-Google-Smtp-Source: ABdhPJwZI+70r45tNENdIy2arTw/QQW8GetUSbK6aH5MWtEHEUQUQH4B4Hngt81DJyXhQa0oeoJXQ7ykQkNlkud8dTo=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr5560446ilj.137.1598787194995;
 Sun, 30 Aug 2020 04:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200829095101.25350-1-cgxu519@mykernel.net> <20200829095101.25350-4-cgxu519@mykernel.net>
In-Reply-To: <20200829095101.25350-4-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 30 Aug 2020 14:33:04 +0300
Message-ID: <CAOQ4uxisdtoccDoQe_fYUA-jXTfy0yk=gNcMSrmbkCYaeOEPuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ovl: implement stacked mmap for shared map
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 29, 2020 at 12:51 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Implement stacked mmap for shared map to keep data
> consistency.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/file.c | 120 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 114 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 14ab5344a918..db5ab200d984 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -21,9 +21,17 @@ struct ovl_aio_req {
>         struct fd fd;
>  };
>
> +static vm_fault_t ovl_fault(struct vm_fault *vmf);
> +static vm_fault_t ovl_page_mkwrite(struct vm_fault *vmf);
> +
> +static const struct vm_operations_struct ovl_vm_ops = {
> +       .fault          = ovl_fault,
> +       .page_mkwrite   = ovl_page_mkwrite,
> +};
> +

Interesting direction, not sure if this is workable.
I don't know enough about mm to say.

But what about the rest of the operations?
Did you go over them and decide that overlay doesn't need to implement them?
I doubt it, but if you did, please document that.

>  struct ovl_file_entry {
>         struct file *realfile;
> -       void *vm_ops;
> +       const struct vm_operations_struct *vm_ops;
>  };
>
>  struct file *ovl_get_realfile(struct file *file)
> @@ -40,14 +48,15 @@ void ovl_set_realfile(struct file *file, struct file *realfile)
>         ofe->realfile = realfile;
>  }
>
> -void *ovl_get_real_vmops(struct file *file)
> +const struct vm_operations_struct *ovl_get_real_vmops(struct file *file)
>  {
>         struct ovl_file_entry *ofe = file->private_data;
>
>         return ofe->vm_ops;
>  }
>
> -void ovl_set_real_vmops(struct file *file, void *vm_ops)
> +void ovl_set_real_vmops(struct file *file,
> +                       const struct vm_operations_struct *vm_ops)
>  {
>         struct ovl_file_entry *ofe = file->private_data;
>
> @@ -493,11 +502,104 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         return ret;
>  }
>
> +vm_fault_t ovl_fault(struct vm_fault *vmf)
> +{
> +       struct vm_area_struct *vma = vmf->vma;
> +       struct file *file = vma->vm_file;
> +       struct file *realfile;
> +       struct file *fpin, *tmp;
> +       struct inode *inode = file_inode(file);
> +       struct inode *realinode;
> +       const struct cred *old_cred;
> +       bool retry_allowed;
> +       vm_fault_t ret;
> +       int err = 0;
> +
> +       if (fault_flag_check(vmf, FAULT_FLAG_TRIED)) {
> +               realfile = ovl_get_realfile(file);
> +
> +               if (!ovl_has_upperdata(inode) ||
> +                   realfile->f_inode != ovl_inode_upper(inode) ||
> +                   !realfile->f_op->mmap)
> +                       return VM_FAULT_SIGBUS;
> +
> +               if (!ovl_get_real_vmops(file)) {
> +                       old_cred = ovl_override_creds(inode->i_sb);
> +                       err = call_mmap(realfile, vma);
> +                       revert_creds(old_cred);
> +
> +                       vma->vm_file = file;
> +                       if (err) {
> +                               vma->vm_ops = &ovl_vm_ops;
> +                               return VM_FAULT_SIGBUS;
> +                       }
> +                       ovl_set_real_vmops(file, vma->vm_ops);
> +                       vma->vm_ops = &ovl_vm_ops;
> +               }
> +
> +               retry_allowed = fault_flag_check(vmf, FAULT_FLAG_ALLOW_RETRY);
> +               if (retry_allowed)
> +                       vma->vm_flags &= ~FAULT_FLAG_ALLOW_RETRY;
> +               vma->vm_file = realfile;
> +               ret = ovl_get_real_vmops(file)->fault(vmf);
> +               vma->vm_file = file;
> +               if (retry_allowed)
> +                       vma->vm_flags |= FAULT_FLAG_ALLOW_RETRY;
> +               return ret;
> +
> +       } else {
> +               fpin = maybe_unlock_mmap_for_io(vmf, NULL);
> +               if (!fpin)
> +                       return VM_FAULT_SIGBUS;
> +
> +               ret = VM_FAULT_RETRY;
> +               if (!ovl_has_upperdata(inode)) {
> +                       err = ovl_copy_up_with_data(file->f_path.dentry);
> +                       if (err)
> +                               goto out;
> +               }
> +
> +               realinode = ovl_inode_realdata(inode);
> +               realfile = ovl_open_realfile(file, realinode);
> +               if (IS_ERR(realfile))
> +                       goto out;
> +
> +               tmp = ovl_get_realfile(file);
> +               ovl_set_realfile(file, realfile);
> +               fput(tmp);
> +
> +out:
> +               fput(fpin);
> +               return ret;
> +       }
> +}


Please add some documentation to explain the method used.
Do we need to retry if real_vmops are already set?

Thanks,
Amir.
