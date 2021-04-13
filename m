Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD10C433B4
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Apr 2021 03:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BC9613AD
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Apr 2021 03:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhDMD02 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 23:26:28 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25311 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239428AbhDMD02 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Apr 2021 23:26:28 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618284363; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=kvHfpeqkpJwWrVeYWPa04E2AVI3VFNxfYc2ytxZ6VODJ+iD5mXJC57dX3u/stASzgX/vFGRqMfIOMX3xfs3wK5vf/sYvKoC3/bjF2toKCQyDla6xKDWRHbrePFH4PAEjzI/LIBg0DLUEHqirrF1z3j03cydS7T3b87Gz5sezRlI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1618284363; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=wZ0HjyC48sVr6I9JlTN8ye/fLpZBqycHxNuA1O7RNqA=; 
        b=eRdEBkqJfb2UXD2ZS1EkqeVAOqBKd/JkISdYkYXFhYa5JoE0WAqshqDlqzSBA1W9/4N0wnDO71TaqD1y4HHNh4Ty9b3lan5K8wxRPY+aMbarvneF6jGewTyb4ecVGyvX9g7BKxjh7d6cOEDgoDIN07GTslDJvX01v0wMh41wcnI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1618284363;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=wZ0HjyC48sVr6I9JlTN8ye/fLpZBqycHxNuA1O7RNqA=;
        b=CD3+AwyNGFkC/zux7MnfqM7RX9cUkJlDDaZ+xhzsoBOmBFwf1ewhYzf5FM53d/D2
        pAqtqvNOTaChdw2RKztRYE0rqRp/l+mfBd19v84/CX1gQ/+hTv1GJixeVTv/unInRIv
        mZ2VdZ3Q/qEaRyNNvk3cCzcpB/mXIqe4/OiVWUoI=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1618284361913189.4814741120705; Tue, 13 Apr 2021 11:26:01 +0800 (CST)
Date:   Tue, 13 Apr 2021 11:26:01 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <178c943b8b6.cd81e26521858.1415503984601701317@mykernel.net>
In-Reply-To: <CAJfpegvbrz3=nL2ETb+nY9G2cBTu4sC_sAhdxnVdHCN7Y1JFfg@mail.gmail.com>
References: <20210408112042.2586996-1-cgxu519@mykernel.net>
 <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
 <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com> <178b1482b24.108404c2418483.4334767487912126386@mykernel.net> <CAJfpegvbrz3=nL2ETb+nY9G2cBTu4sC_sAhdxnVdHCN7Y1JFfg@mail.gmail.com>
Subject: Re: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 23:03:39 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Thu, Apr 8, 2021 at 1:40 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:29:55 Miklo=
s Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > On Thu, Apr 8, 2021 at 1:28 PM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:20:42 =
Chengguang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > >  > >  > In overlayfs copy-up, if open flag has O_TRUNC then upper
 > >  > >  > file will truncate to zero size, in this case we should check
 > >  > >  > VM_DENYWRITE mappings to keep compatibility with other filesys=
tems.
 > >  >
 > >  > Can you provide a test case for the bug that this is fixing?
 > >  >
 > >
 > > Execute binary file(keep running until open) in overlayfs which only h=
as lower && open the binary file with flag O_RDWR|O_TRUNC
 > >
 > > Expected result: open fail with -ETXTBSY
 > >
 > > Actual result: open success
 >=20
 > Worse,  it's possible to get a "Bus error" with just execute and write
 > on an overlayfs file, which i_writecount is supposed to protect.
 >=20
 > The reason is that the put_write_access() call in __vma_link_file()
 > assumes an already negative writecount, but because of the vm_file
 > shuffle in ovl_mmap() that's not guaranteed.   There's even a comment
 > about exactly this situation in mmap():
 >=20
 > /* ->mmap() can change vma->vm_file, but must guarantee that
 > * vma_link() below can deny write-access if VM_DENYWRITE is set
 > * and map writably if VM_SHARED is set. This usually means the
 > * new file must not have been exposed to user-space, yet.
 > */
 >=20
 > The attached patch fixes this, but not your original bug.
 >=20
 > That could be addressed by checking the writecount on *both* lower and
 > upper for open for write/truncate.  Note: this could be checked before
 > copy-up, but that's not reliable alone, because the copy up could
 > happen due to meta-data update, for example, and then the
 > open/truncate wouldn't trigger the writecount check.
 >=20
 > Something like the second attached patch?
 >=20

Yeah, I noticed that too just after posted my previous patch.
However, rethink these two cases, in practice we share lower layers
in most use cases especially in container use case. So if we check
VM_DENYWRITE of lower file strictly, it may cause interferes between
container instances. Maybe only checking upper file will be better
option?

Thanks,
Chengguang





