Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1966FC433E6
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF94F206CD
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wx/53u3x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgIAIWl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 04:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAIWk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 04:22:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD26BC061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 01:22:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c6so427313ilo.13
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 01:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JjqRoV/IP1g3y0qsYcyMqiUMxpbtdgRb5Ko4b7BN84=;
        b=Wx/53u3x7jYwDd7jmDrDg+7wslrhgpTcAzCrRyf4RW5iKIzsOhV0XCgyPrja4Jaobj
         xtvT/Rbt8ahKP/YbSXwVu1N69Af9QmRcgPUHdli2cMdpP8WHvSE9igSjxpDvUlHKgKtW
         gTNIzUudAJaXAUIiy+8H5/eBswIPd38qxRDCBabX3JKQaQVpbRC6P+6/rDaWTzZFLTIZ
         rrkku90VcS739KvoLQEH8BwLAv+wRWytbGgsDzbMW9sEPVbMMEbTmIvJhYrsMPtlttG8
         irqBvrooi7uI71Oww5ARHor+wKzmSfCMdLXRgqmKC5RQBpgFoH+sjESppfXULNA6PxML
         yBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JjqRoV/IP1g3y0qsYcyMqiUMxpbtdgRb5Ko4b7BN84=;
        b=dLneCvXz3QIx8JQDEaGUUh1rqYM8W/8yVhU/OizcfSZS8NWP9in+LdPeTtMhydpqCs
         vj5IsC6QNbbRAUVSSSAaIKnK6dOinhDiskgZ7XwzpaKvIHZX51x4yCGNJWkjmPlifvY5
         hhsud3PW5IBXTARIzG30jTXrUzEtFaQTPuNalb0et+r28h8B8oa5l3etdBSNMmb+UCsv
         PS668L7KC04JVH4ZzndnXM+bR5TcWFIoHOGu/x3h+mqz16q2zLoLNRkaWqP8LVJ3rgfJ
         hyU0GYv4+ftS2pT8W2Dmj44/QMfR4lGFz6Q6nfG5lipeinOUX7qAud0ydFKwHx6UXsHr
         7VXQ==
X-Gm-Message-State: AOAM531NpebxJJgFwt8Ylsvw5n/di+/65sQek8VgH/JJS4lhFsbyHvzg
        txrwflVbodH/Ax0X1KomMtAT/VnrR78TObp9+A0=
X-Google-Smtp-Source: ABdhPJy7Uvo1kSfipTY/TmifQ0yREsyAj/D7Ueegca35o5Z1vHbMAXIYc1hBZ0lbZ71YQlMRRtZ9JYIqFWaTQbTAlLk=
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr393757ils.72.1598948557648;
 Tue, 01 Sep 2020 01:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com>
In-Reply-To: <20200831181529.GA1193654@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Sep 2020 11:22:26 +0300
Message-ID: <CAOQ4uxi6Hc4gNwCiogBG+FeeW-bAUd-ZsW2X=TPJ+6JZCbodVQ@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 31, 2020 at 9:15 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Container folks are complaining that dnf/yum issues too many sync while
> installing packages and this slows down the image build. Build
> requirement is such that they don't care if a node goes down while
> build was still going on. In that case, they will simply throw away
> unfinished layer and start new build. So they don't care about syncing
> intermediate state to the disk and hence don't want to pay the price
> associated with sync.
>
> So they are asking for mount options where they can disable sync on overlay
> mount point.
>
> They primarily seem to have two use cases.
>
> - For building images, they will mount overlay with nosync and then sync
>   upper layer after unmounting overlay and reuse upper as lower for next
>   layer.
>
> - For running containers, they don't seem to care about syncing upper
>   layer because if node goes down, they will simply throw away upper
>   layer and create a fresh one.
>
> So this patch provides a mount option "volatile" which disables all forms
> of sync. Now it is caller's responsibility to throw away upper if
> system crashes or shuts down and start fresh.
>
> With "volatile", I am seeing roughly 20% speed up in my VM where I am just
> installing emacs in an image. Installation time drops from 31 seconds to
> 25 seconds when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
>
> Giuseppe is also looking to cut down on number of iops done on the
> disk. He is complaining that often in cloud their VMs are throttled
> if they cross the limit. This option can help them where they reduce
> number of iops (by cutting down on frequent sync and writebacks).
>
> Changes from v6:
> - Got rid of logic to check for volatile/dirty file. Now Amir's
>   patch checks for presence of incomat/volatile directory and errors
>   out if present. User is now required to remove volatile
>   directory. (Amir).
>
> Changes from v5:
> - Added support to detect that previous overlay was mounted with
>   "volatile" option and fail mount. (Miklos and Amir).
>
> Changes from v4:
> - Dropped support for sync=fs (Miklos)
> - Renamed "sync=off" to "volatile". (Miklos)
>
> Changes from v3:
> - Used only enums and dropped bit flags (Amir Goldstein)
> - Dropped error when conflicting sync options provided. (Amir Goldstein)
>
> Changes from v2:
> - Added helper functions (Amir Goldstein)
> - Used enums to keep sync state (Amir Goldstein)
>
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

See one suggestion below, but you may ignore it...


> +/*
> + * Creates $workdir/work/incompat/volatile/dirty file if it is not
> + * already present.
> + */
> +static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
> +{
> +       struct dentry *parent, *child;
> +       char *name;
> +       int i, len, err;
> +       char *dirty_path[] = {OVL_WORKDIR_NAME, "incompat", "volatile", "dirty"};

Technically, you are calling this right after creating OVL_WORKDIR_NAME, so you
could start from ofs->workdir and drop the first level, but as you wrote it this
function could also be called also after the assignment ovl->workdir =
ovl->indexdir
so it is probably safer to start with ofs->workbasedir as you did.

> +       int nr_elems = ARRAY_SIZE(dirty_path);
> +
> +       err = 0;
> +       parent = ofs->workbasedir;
> +       dget(parent);
> +
> +       for (i = 0; i < nr_elems; i++) {
> +               name = dirty_path[i];
> +               len = strlen(name);
> +               inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> +               child = lookup_one_len(name, parent, len);
> +               if (IS_ERR(child)) {
> +                       err = PTR_ERR(child);
> +                       goto out_unlock;
> +               }
> +
> +               if (!child->d_inode) {
> +                       unsigned short ftype;
> +
> +                       ftype = (i == (nr_elems - 1)) ? S_IFREG : S_IFDIR;
> +                       child = ovl_create_real(parent->d_inode, child,
> +                                               OVL_CATTR(ftype | 0));
> +                       if (IS_ERR(child)) {
> +                               err = PTR_ERR(child);
> +                               goto out_unlock;
> +                       }
> +               }
> +
> +               inode_unlock(parent->d_inode);
> +               dput(parent);
> +               parent = child;
> +               child = NULL;
> +       }
> +
> +       dput(parent);
> +       return err;
> +
> +out_unlock:
> +       inode_unlock(parent->d_inode);
> +       dput(parent);
> +       return err;
> +}
> +

I think a helper ovl_test_create() along the lines of the helper found on
my ovl-features branch could make this code a lot easier to follow.
Note that the helper in that branch in not ready to be cherry-picked
as is - it needs changes, so take it or leave it.

Thanks,
Amir.
