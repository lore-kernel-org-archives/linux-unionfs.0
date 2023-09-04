Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF8ECA0FE3
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 08:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbjIDI6c (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 04:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbjIDI6a (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 04:58:30 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB1F10F4
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 01:58:08 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id ada2fe7eead31-44d3e4ad403so535767137.0
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 01:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693817887; x=1694422687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cy5yuAO4HJ7kpSkxNjdiqNmpGmIRgTc1Ek2lCeSz7iI=;
        b=W58hLdg6la4FnSjghgcHJnaiH2T8iL3m6ZyVfht/JPUAlARm7eK33+MBsApCb8qja5
         dx+7m7/8x9fHsxUQ+T8oaiZGKlHO18QyyUhlfGtyaIcfSH7EYdjC+FzNaA1jrI4LUdZ0
         0OujoDV2oWRzkNBs9uEi7ad4GUHqM7fIwSb8PWi7522aGfBNoODgLjhMDfYM7jdc1Yc6
         MtYa8KhZWL69GN3HrqnDCzFb1+Lh6s7XQOtFlT9bwcKidxYj7qCNHq2yOm+ohdgX4GHV
         1vduXI1Ov3To+ONjwHl+oDoJhlCJG8QTuOzVepnUdkmeVBne0PtYLbDrwdX5yBMCf6yL
         XEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693817887; x=1694422687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cy5yuAO4HJ7kpSkxNjdiqNmpGmIRgTc1Ek2lCeSz7iI=;
        b=Ua9oIAdST8eNjPmKzO87VxkHFtAck7OSFotQP/bkwOFIQezpLmnGBfxWzdnexww8t6
         I3E4BjfYkk1LL+taUpTztn4WJJZyT9cltA3uWVVTQuavg9UFzPOSpfNOgyfxRDyW5uUz
         rsyHGTrtNbJYUMfbojB27osr/fRX9uJtesEQwNXPN0rDWAyoRVds5g+gBCnLf35ENONx
         KYaRhclBkQTntEfB3SCynp5hFqzmh9dvtalIjbF9CX98NC3TzrpkpjKjyenGIjZUNvp/
         hI2SZh2nHfJjO1i1LC9UkuhM5drzLIOwcPVLt4m/xqMXfXKuFddDL1QlckChkB/89FhM
         aXMw==
X-Gm-Message-State: AOJu0YzPFxnLUZkSw6/ksjJUoTD8C0etyt3RMCL/mLVB4FQ0B2hjQDIk
        cuLDosJn+5v05b1QiqkxQmJW6pE9mzw5x2zYFNk=
X-Google-Smtp-Source: AGHT+IG8HRL1PFgQEgddkCTxqmX/C31v5N8PYiH265R2DYMA1iTjudxJNKZitbA9t0eTKUntPK8FS8MWiFjBZ0mRkwg=
X-Received: by 2002:a05:6102:1350:b0:44e:92dc:7f12 with SMTP id
 j16-20020a056102135000b0044e92dc7f12mr6181801vsl.30.1693817887697; Mon, 04
 Sep 2023 01:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
In-Reply-To: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Sep 2023 11:57:56 +0300
Message-ID: <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
Subject: Re: [potential issue, question] whiteout shows up in merged directory
To:     Jingbo Xu <jefflexu@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Xiang Gao <xiang@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 10:47=E2=80=AFAM Jingbo Xu <jefflexu@linux.alibaba.c=
om> wrote:
>
> Hi, all,
>
> I found an issue may be related to overlayfs on the latest master branch
> [1] when I'm developing tarfs mode for erofs-utils [2], which converts
> and merges tar layers into one merged erofs image with overlayfs-like mod=
el.
>
> The issue is that, the whiteout from lowerdir may still shows up in the
> merged directory.  Though this issue is initially found with erofs, it
> can also be reproduced with ext4.  Following is a simple reproducer with
> ext4.
>
> ```
> mkdir -p /mnt/lower1/dir /mnt/lower2
> mknod /mnt/lower1/file1 c 0 0
> mknod /mnt/lower1/dir/file2 c 0 0
> mount -t overlay none -olowerdir=3D/mnt/lower1:/mnt/lower2 /mnt2
>
> # ls  -l /mnt2/
> total 4
> drwxr-xr-x 2 root root 4096 Sep  4 14:40 dir
>
> # ls  -l /mnt2/dir
> ls: cannot access /mnt2/dir/file2: No such file or directory
> total 0
> c????????? ? ? ? ?            ? file2
> ```
>
> It seems that this issue is relevant to whether the parent directory of
> the whiteout is a merged directory or not.  In the above example, file1
> is hidden from the merged directory as expected (with its parent
> directory '/' a merged directory), while file2 shows up unexpectedly
> (with its parent directory '/dir' from lowerdir).
>
>
> I also noticed that this issue doesn't exist if the whiteout is created
> by overlayfs itself rather than handcrafted with mknod like:
>
> ```
> mkdir -p /mnt/lower/dir /mnt/upper /mnt/work
> touch /mnt/lower/file1
> touch /mnt/lower/dir/file2
> mount -t overlay none
> -olowerdir=3D/mnt/lower,upperdir=3D/mnt/upper,workdir=3D/mnt/work /mnt1
> rm /mnt1/file1
> rm /mnt1/dir/file2
> umount /mnt1
> mount -t overlay -olowerdir=3D/mnt/upper:/mnt/lower none /mnt2
>
> # ls -l /mnt2/
> total 8
> drwxr-xr-x 1 root root 4096 Sep  4 15:45 dir
>
> # ls -l /mnt2/dir/
> total 0
> ```
>
> I'm not sure if it's a known issue or not, or due to my mishandling.
> Appreciate if you could shed a light on this.
>

The case of whiteouts creates by overlayfs itself was reported
by zhangyi and handled by this patchs set:

https://lore.kernel.org/linux-unionfs/1509486350-21362-1-git-send-email-ami=
r73il@gmail.com/

so you could say that the problem is due to the way that you
created those layers.

There is a simple workaround for you though:

mkdir -p /mnt/lower1/dir /mnt/lower2/dir

Making 'dir' a merge dir avoids the problem.
Not sure if that helps.

The alternative way is:
setfattr -n "trusted.overlay.origin" /mnt/lower1/dir

Thanks,
Amir.
