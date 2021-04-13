Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE07FC433B4
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Apr 2021 08:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84765610FC
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Apr 2021 08:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhDMIs1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 04:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhDMIsZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Apr 2021 04:48:25 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A461C061574
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Apr 2021 01:48:04 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id s19so3892512uaq.4
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Apr 2021 01:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3SNcgq6ir9y6NlCfHueQciX33Dh9wtAzhePFLhXto1o=;
        b=X8gcGOsd5zYa8RqgHRh1LdqSvNcaEBsaW0VRpcBKsQpFWbnykWGB6mqUaashABxPGu
         0gGS9S2NXGawhcOiKTXuMRRGzGRWnMqDH3NrPzKCpDpXd3bG1w+O1qz5QxzEVjybxu7q
         40NUhOX6RRtKYwD0QO7w7Qd2Iuu4IZzjFTeH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3SNcgq6ir9y6NlCfHueQciX33Dh9wtAzhePFLhXto1o=;
        b=XPZuWnTkf1Vr6yqPuhMPyh+mf9QavjCuLP5huGeZ4xdLY/aV9Wq5gaVRD0p9AvfFnj
         6DR66sKWtoB7DotL/LKvZU+gfgp22LN6sZAsI3SdCfVpLwAKYtZdO1LjhvpWwT12cvz3
         N6p8eC8JglxHXa+6qUl9CUDLYVseymCJcKhv4dW47rzm9Lj/Oi6rsInnGXmbaIACC/7v
         oCakMuMjn2Gcviojq79/9KnRR1Q9dw14GapSAv/fch8JbkHKbrE5YFerlfnjKLI1cbAQ
         05UQVYid0Fb2ZKr1xKLyAPg6ehZqVB8mHSIIQExqdctcLh9pyHfDSqN7xKfHARTI5p25
         bj1g==
X-Gm-Message-State: AOAM533MeDG3IDcjXYu76osZKacBi55XTkugVMChFrNT/FOR/pcMM7n5
        KHJEOT+vD/8AlCrh64oF3pMBmBxpPaCkxkDa1rQjHg==
X-Google-Smtp-Source: ABdhPJx7g69uFERgS3ppZKHXGmfW4spR6EoFbaYyAxwAsMJARVzgxJIHmPOTiJGjMOcGnLWobjoGKVa95E5uxyTCP2M=
X-Received: by 2002:ab0:3570:: with SMTP id e16mr8547182uaa.13.1618303683811;
 Tue, 13 Apr 2021 01:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210408112042.2586996-1-cgxu519@mykernel.net>
 <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
 <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com>
 <178b1482b24.108404c2418483.4334767487912126386@mykernel.net>
 <CAJfpegvbrz3=nL2ETb+nY9G2cBTu4sC_sAhdxnVdHCN7Y1JFfg@mail.gmail.com> <178c943b8b6.cd81e26521858.1415503984601701317@mykernel.net>
In-Reply-To: <178c943b8b6.cd81e26521858.1415503984601701317@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 13 Apr 2021 10:47:53 +0200
Message-ID: <CAJfpegsKHRY=AxQMECwXNh2Rni_Ah0uo939aEfhRcQB3Rz-AGQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 13, 2021 at 5:26 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 23:03:39 Miklos S=
zeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > On Thu, Apr 8, 2021 at 1:40 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:29:55 Mik=
los Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
>  > >  > On Thu, Apr 8, 2021 at 1:28 PM Chengguang Xu <cgxu519@mykernel.ne=
t> wrote:
>  > >  > >
>  > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:20:4=
2 Chengguang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > >  > >  > In overlayfs copy-up, if open flag has O_TRUNC then upper
>  > >  > >  > file will truncate to zero size, in this case we should chec=
k
>  > >  > >  > VM_DENYWRITE mappings to keep compatibility with other files=
ystems.
>  > >  >
>  > >  > Can you provide a test case for the bug that this is fixing?
>  > >  >
>  > >
>  > > Execute binary file(keep running until open) in overlayfs which only=
 has lower && open the binary file with flag O_RDWR|O_TRUNC
>  > >
>  > > Expected result: open fail with -ETXTBSY
>  > >
>  > > Actual result: open success
>  >
>  > Worse,  it's possible to get a "Bus error" with just execute and write
>  > on an overlayfs file, which i_writecount is supposed to protect.
>  >
>  > The reason is that the put_write_access() call in __vma_link_file()
>  > assumes an already negative writecount, but because of the vm_file
>  > shuffle in ovl_mmap() that's not guaranteed.   There's even a comment
>  > about exactly this situation in mmap():
>  >
>  > /* ->mmap() can change vma->vm_file, but must guarantee that
>  > * vma_link() below can deny write-access if VM_DENYWRITE is set
>  > * and map writably if VM_SHARED is set. This usually means the
>  > * new file must not have been exposed to user-space, yet.
>  > */
>  >
>  > The attached patch fixes this, but not your original bug.
>  >
>  > That could be addressed by checking the writecount on *both* lower and
>  > upper for open for write/truncate.  Note: this could be checked before
>  > copy-up, but that's not reliable alone, because the copy up could
>  > happen due to meta-data update, for example, and then the
>  > open/truncate wouldn't trigger the writecount check.
>  >
>  > Something like the second attached patch?
>  >
>
> Yeah, I noticed that too just after posted my previous patch.
> However, rethink these two cases, in practice we share lower layers
> in most use cases especially in container use case. So if we check
> VM_DENYWRITE of lower file strictly, it may cause interferes between
> container instances. Maybe only checking upper file will be better
> option?

Yes.

My patch to fix the SIGBUS is also incomplete as there's still a race
window between releasing the temporary writecount and the __vma_link()
that acquires the final count.    This requires major surgery to fix
properly :(

Thanks,
Miklos
