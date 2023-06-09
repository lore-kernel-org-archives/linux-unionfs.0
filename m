Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB58C7EE29
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 15:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjFIPAv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 11:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241594AbjFIPAu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 11:00:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA283AAD
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 08:00:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5149e65c244so2697899a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 08:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686322837; x=1688914837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqLLtcWMoIT9yxSsvz4XlOega2forMJ82wIx7ZfQvvM=;
        b=DxPTH8rPEX1ZNIZB1bXWyUkHEosjQD4BxzETHz46GQxSKuLVYyMbNXZ6fqXbzAJphV
         SVj3Cr2FmyZ8djDYTio3jmkwWWr3dohzIYRZU/xPtlyfZPJGPec8+S9wRNxNP9BDXM5z
         EN9Fe8dAtMJc3AvJrlW57ZLrbhNpA5SNkfqjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686322837; x=1688914837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqLLtcWMoIT9yxSsvz4XlOega2forMJ82wIx7ZfQvvM=;
        b=jiMOCiUATJdxBrp9f2X9Zqqqd9Lq+Ds7dHxnmZtVydBv+wpQJMQysX0cMqyYV2yXC0
         6P6KhwfDFEcfLM0tEb63kZGQnR8pwxG7engKWQkgjSLZEtKU7sdvR/2FtGgJthXX1s0I
         6N5Cpc6km8dsjkTrZK/ibetBlp8LiWfmdoAHYZvf5ysR7XMvcCM999Iex3cC4Y+O9U5m
         2CxsoyDqFEyKZKoFIygkXAILUBCtkk/HoaFUhnZVv0RQGv+xXlLlXnsIaYu3kuS2o/04
         tNhqJWr/OtbMw1UztycsS8AXvIVHJkd5bqYwzBqA7uVHNNrEFogcP11giC5xWxa43lLA
         K0eQ==
X-Gm-Message-State: AC+VfDxUXgm/j+HFghfDsWfOxLEHjxfvFi77WuHlYkMo9D9b46jSxq2n
        bbZ3Of7J0Pg4AmOz8hwQI7MYAU/zMldZ1ipuFbIF5A==
X-Google-Smtp-Source: ACHHUZ5EAZ2zcYeqHRqTmgpE+joGJb2p4YsWwg1cT9a1hSJnfsMvKg+u/2fk7YHp2+aKO4lzJKs5TAZIOLjC+7ZfNLg=
X-Received: by 2002:a17:907:dab:b0:939:e870:2b37 with SMTP id
 go43-20020a1709070dab00b00939e8702b37mr2220268ejc.70.1686322836850; Fri, 09
 Jun 2023 08:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230609073239.957184-1-amir73il@gmail.com> <CAJfpegvDoSWPRaoa_i_Do3JDdaXrhohDtfQNObSJ7tNhhuHAKw@mail.gmail.com>
 <CAOQ4uxh=KfY2mNW1jQk6-wjoGWzi5LdCN=H9LzfCSx2o69K36A@mail.gmail.com> <CAOQ4uxgk3sAubfx84FKtNSowgT-aYj0DBX=hvAApre_3a8Cq=g@mail.gmail.com>
In-Reply-To: <CAOQ4uxgk3sAubfx84FKtNSowgT-aYj0DBX=hvAApre_3a8Cq=g@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Jun 2023 17:00:25 +0200
Message-ID: <CAJfpegtt48eXhhjDFA1ojcHPNKj3Go6joryCPtEFAKpocyBsnw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Reduce impact of overlayfs fake path files
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 9 Jun 2023 at 16:42, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jun 9, 2023 at 5:28=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
> >
> > On Fri, Jun 9, 2023 at 4:15=E2=80=AFPM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> > >
> > > On Fri, 9 Jun 2023 at 09:32, Amir Goldstein <amir73il@gmail.com> wrot=
e:
> > > >
> > > > Miklos,
> > > >
> > > > This is the solution that we discussed for removing FMODE_NONOTIFY
> > > > from overlayfs real files.
> > > >
> > > > My branch [1] has an extra patch for remove FMODE_NONOTIFY, but
> > > > I am still testing the ovl-fsnotify interaction, so we can defer
> > > > that step to later.
> > > >
> > > > I wanted to post this series earlier to give more time for fsdevel
> > > > feedback and if these patches get your blessing and the blessing of
> > > > vfs maintainers, it is probably better that they will go through th=
e
> > > > vfs tree.
> > > >
> > > > I've tested that overlay "fake" path are still shown in /proc/self/=
maps
> > > > and in the /proc/self/exe and /proc/self/map_files/ symlinks.
> > > >
> > > > The audit and tomoyo use of file_fake_path() is not tested
> > > > (CC maintainers), but they both look like user displayed paths,
> > > > so I assumed they's want to preserve the existing behavior
> > > > (i.e. displaying the fake overlayfs path).
> > >
> > > I did an audit of all ->vm_file  and found a couple of missing ones:
> >
> > Wait, but why only ->vm_file?

Because we don't get to intercept vm_ops, so anything done through
mmaps will not go though overlayfs.   That would result in apparmor
missing these, for example.

> > We were under the assumption the fake path is only needed
> > for mapped files, but the list below suggests that it matters
> > to other file operations as well...
> >
> > >
> > > dump_common_audit_data
> > > ima_file_mprotect
> > > common_file_perm (I don't understand the code enough to know whether
> > > it needs fake dentry or not)
> > > aa_file_perm
> > > __file_path_perm
> > > print_bad_pte
> > > file_path
> > > seq_print_user_ip
> > > __mnt_want_write_file
> > > __mnt_drop_write_file
> > > file_dentry_name
> > >
> > > Didn't go into drivers/ and didn't follow indirect calls (e.g.
> > > f_op->fsysnc).  I also may have missed something along the way, but m=
y
> > > guess is that I did catch most cases.
> >
> > Wow. So much for 3-4 special cases...
> >
> > Confused by some of the above.
> >
> > Why would we want __mnt_want_write_file on the fake path?
> > We'd already taken __mnt_want_write on overlay and with
> > real file we need __mnt_want_write on the real path.

It's for write faults on memory maps.   The code already branches on
file->f_mode, I don't think it would be a big performance hit to check
FMODE_FAKE_PATH.

> >
> > For IMA/LSMs, I'd imagine that like fanotify, they would rather get
> > the real path where the real policy is stored.
> > If some log files end with relative path instead of full fake path
> > it's probably not the worst outcome.
> >
> > Thoughts?
>
> Considering the results of your audit, I think I prefer to keep
> f_path fake and store real_path in struct file_fake for code
> that wants the real path.
>
> This will keep all logic unchanged, which is better for my health.
> and only fsnotify (for now) will start using f_real_path() to
> generate events on real fs objects.

That's also an option.

I think f_fake_path() would still be a move in the right direction.
We have 46 instances of file_dentry() currently and of those special
cases most are cosmetic, while missing file_dentry() ones are
crashable.

Thanks,
Miklos
