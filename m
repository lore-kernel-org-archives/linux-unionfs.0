Return-Path: <SRS0=nzN1=CJ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B735DC433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BEAC20719
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRj0O96S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgHaPwJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 11:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgHaPwH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Aug 2020 11:52:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE6CC061573
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2020 08:52:07 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q14so1542284ilm.2
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2020 08:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5cx8jEInzJ088LS4lCDwkjF1TX5xD6OaOExDN2mWg+Y=;
        b=YRj0O96Sm//n2h4jCYaI8sE3WnrKByrK7lz5jy3yK5dEoddSGL5hj3V1IuXC23D929
         ipLVpQlQ+5SQtXNBVpTI9awk53eF5MEr/VKtKSk8yp3qksSiaraSE+B94c5gqz112gWJ
         5aww7zKR+els4RcxbXjBXT/WiMYcbt9OQ7VndLoqZdFcgMpbSO++oDDIRgK9KlDYu2RV
         Gs2JQa0pEtjh9nRfIWIoCFY0TAa0rO4ipRmL+9OdkdK9LSRQtNzreoSA8+ZUGDFnrrLb
         uYDzCGd1Txl4t4o0otpaM/7/l6J9N3aQ+2/CJTrnEcLpvO1hLS1+LP+208cGQ4nV4lKC
         whFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5cx8jEInzJ088LS4lCDwkjF1TX5xD6OaOExDN2mWg+Y=;
        b=g/7Mo8yCszu1KKtucedEvL2vKnYP7uNKcIFxsLVMdwnllBauM2UbYVqBZPxjKrSbIn
         eZNUshRAj48u7jyIVhu4qjNkN+aTAk1AGj2IzeJxS+JfVxprIHnSl58BGvTIKIY/Keyl
         4UO9XFW7mqcC36k6MJHqRK9ui0B8ygjQla/JnDlJ/5/VvWLYBSicshTrKcKI5hRlmrvJ
         w9zvcgRXV6W7dOr2zMupaJH+ZyOWYSxtzjeBnOSZ0g8GrT5Ais6Mj9NO5ctA5FL6jJu6
         F5G9ykoPHNCVLYpO9jCg7j+jkxRq1KGtLusHy3LrL0VX0/YATEjXuS/ot9U4Tapsnn+0
         wJ4A==
X-Gm-Message-State: AOAM532Hu9xXIi1s1fpXd7tuVQS6SVBxLjru3j8wnaxZOpea8hrPHtLA
        B9MHRpWp8q4cwpwy6/3vvPiIEKgzZM3D037aj+8uiltr858=
X-Google-Smtp-Source: ABdhPJxJevGLzNtbz24KByBtfIQyHa/j5GPI0wRb53VnGAbMBixg163JUb0m6kxbHz1z4FvhyItbZfF4wWIlROeMyv8=
X-Received: by 2002:a92:da0a:: with SMTP id z10mr1819057ilm.275.1598889126287;
 Mon, 31 Aug 2020 08:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200829095101.25350-1-cgxu519@mykernel.net> <20200829095101.25350-4-cgxu519@mykernel.net>
 <CAOQ4uxisdtoccDoQe_fYUA-jXTfy0yk=gNcMSrmbkCYaeOEPuQ@mail.gmail.com> <e1e2c8f0-a3b8-0a3d-3093-6188b1a829f0@mykernel.net>
In-Reply-To: <e1e2c8f0-a3b8-0a3d-3093-6188b1a829f0@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 31 Aug 2020 18:51:54 +0300
Message-ID: <CAOQ4uxgn5gKXdwjYjuUrt29uHi3cNVApTnODiW-kp-DkzKLVMw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ovl: implement stacked mmap for shared map
To:     cgxu <cgxu519@mykernel.net>
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

On Mon, Aug 31, 2020 at 4:47 PM cgxu <cgxu519@mykernel.net> wrote:
>
> On 8/30/20 7:33 PM, Amir Goldstein wrote:
> > On Sat, Aug 29, 2020 at 12:51 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
> >>
> >> Implement stacked mmap for shared map to keep data
> >> consistency.
> >>
> >> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> >> ---
> >>   fs/overlayfs/file.c | 120 +++++++++++++++++++++++++++++++++++++++++---
> >>   1 file changed, 114 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> >> index 14ab5344a918..db5ab200d984 100644
> >> --- a/fs/overlayfs/file.c
> >> +++ b/fs/overlayfs/file.c
> >> @@ -21,9 +21,17 @@ struct ovl_aio_req {
> >>          struct fd fd;
> >>   };
> >>
> >> +static vm_fault_t ovl_fault(struct vm_fault *vmf);
> >> +static vm_fault_t ovl_page_mkwrite(struct vm_fault *vmf);
> >> +
> >> +static const struct vm_operations_struct ovl_vm_ops = {
> >> +       .fault          = ovl_fault,
> >> +       .page_mkwrite   = ovl_page_mkwrite,
> >> +};
> >> +
> >
> > Interesting direction, not sure if this is workable.
> > I don't know enough about mm to say.
> >
> > But what about the rest of the operations?
> > Did you go over them and decide that overlay doesn't need to implement them?
> > I doubt it, but if you did, please document that.
>
> I did some check for rest of them, IIUC ->fault will be enough for this
> special case (shared read-only mmap with no upper), I will remove
> ->page_mkwrite in v2.

Ok I suppose you checked that ->map_pages is not relevant?

>
> # I do not consider support ->huge_fault in current stage due to many fs
> cannot support DAX properly.
>
> BTW, do you know who should I add to CC list for further deep review of
> this code? fadevel-list?
>

fsdevel would be good, but I would wait for initial feedback from Miklos
before you post v2...

>
>
> >
> >>   struct ovl_file_entry {
> >>          struct file *realfile;
> >> -       void *vm_ops;
> >> +       const struct vm_operations_struct *vm_ops;
> >>   };
> >>
> >>   struct file *ovl_get_realfile(struct file *file)
> >> @@ -40,14 +48,15 @@ void ovl_set_realfile(struct file *file, struct file *realfile)
> >>          ofe->realfile = realfile;
> >>   }
> >>
> >> -void *ovl_get_real_vmops(struct file *file)
> >> +const struct vm_operations_struct *ovl_get_real_vmops(struct file *file)
> >>   {
> >>          struct ovl_file_entry *ofe = file->private_data;
> >>
> >>          return ofe->vm_ops;
> >>   }
> >>
> >> -void ovl_set_real_vmops(struct file *file, void *vm_ops)
> >> +void ovl_set_real_vmops(struct file *file,
> >> +                       const struct vm_operations_struct *vm_ops)
> >>   {
> >>          struct ovl_file_entry *ofe = file->private_data;
> >>
> >> @@ -493,11 +502,104 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> >>          return ret;
> >>   }
> >>
> >> +vm_fault_t ovl_fault(struct vm_fault *vmf)
> >> +{
> >> +       struct vm_area_struct *vma = vmf->vma;
> >> +       struct file *file = vma->vm_file;
> >> +       struct file *realfile;
> >> +       struct file *fpin, *tmp;
> >> +       struct inode *inode = file_inode(file);
> >> +       struct inode *realinode;
> >> +       const struct cred *old_cred;
> >> +       bool retry_allowed;
> >> +       vm_fault_t ret;
> >> +       int err = 0;
> >> +
> >> +       if (fault_flag_check(vmf, FAULT_FLAG_TRIED)) {
> >> +               realfile = ovl_get_realfile(file);
> >> +
> >> +               if (!ovl_has_upperdata(inode) ||
> >> +                   realfile->f_inode != ovl_inode_upper(inode) ||
> >> +                   !realfile->f_op->mmap)
> >> +                       return VM_FAULT_SIGBUS;
> >> +
> >> +               if (!ovl_get_real_vmops(file)) {
> >> +                       old_cred = ovl_override_creds(inode->i_sb);
> >> +                       err = call_mmap(realfile, vma);
> >> +                       revert_creds(old_cred);
> >> +
> >> +                       vma->vm_file = file;
> >> +                       if (err) {
> >> +                               vma->vm_ops = &ovl_vm_ops;
> >> +                               return VM_FAULT_SIGBUS;
> >> +                       }
> >> +                       ovl_set_real_vmops(file, vma->vm_ops);
> >> +                       vma->vm_ops = &ovl_vm_ops;
> >> +               }
> >> +
> >> +               retry_allowed = fault_flag_check(vmf, FAULT_FLAG_ALLOW_RETRY);
> >> +               if (retry_allowed)
> >> +                       vma->vm_flags &= ~FAULT_FLAG_ALLOW_RETRY;
> >> +               vma->vm_file = realfile;
> >> +               ret = ovl_get_real_vmops(file)->fault(vmf);
> >> +               vma->vm_file = file;
> >> +               if (retry_allowed)
> >> +                       vma->vm_flags |= FAULT_FLAG_ALLOW_RETRY;
> >> +               return ret;
> >> +
> >> +       } else {
> >> +               fpin = maybe_unlock_mmap_for_io(vmf, NULL);
> >> +               if (!fpin)
> >> +                       return VM_FAULT_SIGBUS;
> >> +
> >> +               ret = VM_FAULT_RETRY;
> >> +               if (!ovl_has_upperdata(inode)) {
> >> +                       err = ovl_copy_up_with_data(file->f_path.dentry);
> >> +                       if (err)
> >> +                               goto out;
> >> +               }
> >> +
> >> +               realinode = ovl_inode_realdata(inode);
> >> +               realfile = ovl_open_realfile(file, realinode);
> >> +               if (IS_ERR(realfile))
> >> +                       goto out;
> >> +
> >> +               tmp = ovl_get_realfile(file);
> >> +               ovl_set_realfile(file, realfile);
> >> +               fput(tmp);
> >> +
> >> +out:
> >> +               fput(fpin);
> >> +               return ret;
> >> +       }
> >> +}
> >
> >
> > Please add some documentation to explain the method used.
> > Do we need to retry if real_vmops are already set?
> >
>
> Good catch, actually retry is not needed in that case.
>
> Basically, we unlock(mmap_lock)->copy-up->open when
> detecting no upper inode then retry fault operation.
> However, we need to check fault retry flag carefully
> for avoiding endless retry.

That much I got, but the details of setting ->vm_file and vmops
look subtle, so better explain them.

Thanks,
Amir.
