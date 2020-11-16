Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF16C6369E
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 05:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A844C22450
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 05:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="Kjx6CArv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgKPFIU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 00:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgKPFIT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Nov 2020 00:08:19 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B26BC0613D1
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 21:08:19 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t9so17394139edq.8
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 21:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gSADVCrwuW6pljevvcMQIsFsXVk+O5kueFxo5o6oC2U=;
        b=Kjx6CArvtgoTb5cyfQ6FW3Kqfuqw16Cy4185JE92p8KAoyLxdIhPsivEB4Yvw2olBe
         awl9bIyCyt3Qo6ElD/B07owFpy8Q0SoGclEMCRSzXokKzv1q0/+r46IpE8rBoIvS6bue
         tBHkl2n+8FhDDjEt0tivyW+1XrIC0fqxPSj1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gSADVCrwuW6pljevvcMQIsFsXVk+O5kueFxo5o6oC2U=;
        b=sUzxBJTdjVntd9cundxUlbB4/y0bM2nAxDOyFVJDVMBHLJaRU8U9ujpV9toCsK4f2r
         N7VsxFm9H/8QbX3PuTTx9bYlmZav/jXbZLAYY5BsUgMa+OOV6k/ra+/xz1Iaqs+04nPz
         fPHF2TXmq82Ps4qhjLdDZKjJIQLaN3wmVIiQ+hcnTNMFb3PZ4VTDlZT/qzlELFHqa9gv
         aHbS+tcQq1wLABWxpesHds81qLbTVC3Gb0xJ0AB4KeU9dwvxvgsDeJhlbWdMy9lBG5hx
         ZO126qZ84M0drYq4Pz8A6nO9hutOeDtakFtoHO7aj5ww/6PhYEXwnWjZ/XHdOIxaN+aH
         RQjA==
X-Gm-Message-State: AOAM532k0fkbuev9YLUm5qGOA4mnuQppBL/Hc9LgFzt3YIa5VzFpo+tY
        igudXZ4ZiDO98qBnirlAYcYzp0kkq2oTZZbmtQvmeuV8TKM=
X-Google-Smtp-Source: ABdhPJz27VjxU1Y/RsC+srSnav3shAf1hUwEEUva0AB7XJzwN8AzkRknK5xznyNSo+DD/2o/HvQ/jRNh7/UIds/7kxU=
X-Received: by 2002:a50:cd09:: with SMTP id z9mr14409916edi.152.1605503297860;
 Sun, 15 Nov 2020 21:08:17 -0800 (PST)
MIME-Version: 1.0
References: <20201116045758.21774-1-sargun@sargun.me> <20201116045758.21774-2-sargun@sargun.me>
In-Reply-To: <20201116045758.21774-2-sargun@sargun.me>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Sun, 15 Nov 2020 21:07:42 -0800
Message-ID: <CAMp4zn88ggSTdaAA=Nj9xMDNbQVHXg1BPyZwO6g22TuMqhodog@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] fs: Add s_instance_id field to superblock for
 unique identification
To:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Nov 15, 2020 at 8:58 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> This assigns a per-boot unique number to each superblock. This allows
> other components to know whether a filesystem has been remounted
> since they last interacted with it.
>
> At every boot it is reset to 0. There is no specific reason it is set to 0,
> other than repeatability versus using some random starting number. Because
> of this, you must store it along some other piece of data which is
> initialized at boot time.
>
> This doesn't have any of the overhead of idr, and a u64 wont wrap any time
> soon. There is no forward lookup requirement, so an idr is not needed.
>
> In the future, we may want to expose this to userspace. Userspace programs
> can benefit from this if they have large chunks of dirty or mmaped memory
> that they're interacting with, and they want to see if that volume has been
> unmounted, and remounted. Along with this, and a mechanism to inspect the
> superblock's errseq a user can determine whether they need to throw away
> their cache or similar. This is another benefit in comparison to just
> using a pointer to the superblock to uniquely identify it.
>
> Although this doesn't expose an ioctl or similar yet, in the future we
> could add an ioctl that allows for fetching the s_instance_id for a given
> cache, and inspection of the errseq associated with that.
>
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-unionfs@vger.kernel.org
> ---
>  fs/super.c              | 3 +++
>  include/linux/fs.h      | 7 +++++++
>  include/uapi/linux/fs.h | 2 ++
>  3 files changed, 12 insertions(+)
>
> diff --git a/fs/super.c b/fs/super.c
> index 904459b35119..e47ace7f8c3d 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -42,6 +42,7 @@
>
>  static int thaw_super_locked(struct super_block *sb);
>
> +static u64 s_instance_id_counter;
>  static LIST_HEAD(super_blocks);
>  static DEFINE_SPINLOCK(sb_lock);
>
> @@ -546,6 +547,7 @@ struct super_block *sget_fc(struct fs_context *fc,
>         s->s_iflags |= fc->s_iflags;
>         strlcpy(s->s_id, s->s_type->name, sizeof(s->s_id));
>         list_add_tail(&s->s_list, &super_blocks);
> +       s->s_instance_id = s_instance_id_counter++;
>         hlist_add_head(&s->s_instances, &s->s_type->fs_supers);
>         spin_unlock(&sb_lock);
>         get_filesystem(s->s_type);
> @@ -625,6 +627,7 @@ struct super_block *sget(struct file_system_type *type,
>         s->s_type = type;
>         strlcpy(s->s_id, type->name, sizeof(s->s_id));
>         list_add_tail(&s->s_list, &super_blocks);
> +       s->s_instance_id = s_instance_id_counter++;
>         hlist_add_head(&s->s_instances, &type->fs_supers);
>         spin_unlock(&sb_lock);
>         get_filesystem(type);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index dbbeb52ce5f3..642847c3673f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1472,6 +1472,13 @@ struct super_block {
>         char                    s_id[32];       /* Informational name */
>         uuid_t                  s_uuid;         /* UUID */
>
> +       /*
> +        * ID identifying this particular instance of the superblock. It can
> +        * be used to determine if a particular filesystem has been remounted.
> +        * It may be exposed to userspace.
> +        */
> +       u64                     s_instance_id;
> +
>         unsigned int            s_max_links;
>         fmode_t                 s_mode;
>

Hit send a little too quickly. Please ignore this hunk as part of the RFC.
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index f44eb0a04afd..f2b126656c22 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -13,6 +13,7 @@
>  #include <linux/limits.h>
>  #include <linux/ioctl.h>
>  #include <linux/types.h>
> +#include <linux/uuid.h>
>  #ifndef __KERNEL__
>  #include <linux/fscrypt.h>
>  #endif
> @@ -203,6 +204,7 @@ struct fsxattr {
>
>  #define        FS_IOC_GETFLAGS                 _IOR('f', 1, long)
>  #define        FS_IOC_SETFLAGS                 _IOW('f', 2, long)
> +#define FS_IOC_GET_SB_INSTANCE         _IOR('f', 3, uuid_t)
>  #define        FS_IOC_GETVERSION               _IOR('v', 1, long)
>  #define        FS_IOC_SETVERSION               _IOW('v', 2, long)
>  #define FS_IOC_FIEMAP                  _IOWR('f', 11, struct fiemap)
> --
> 2.25.1
>
