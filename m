Return-Path: <SRS0=6c+a=5X=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E0BC2BABC
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 09:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29876206C0
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 09:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="DYKH4zEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgDGJ0B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:26:01 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25316 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbgDGJ0B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Apr 2020 05:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586251537;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=ge97WhC2OlbXqkMuBLqKoky9Kemyljg1+A6t2NKk9jQ=;
        b=DYKH4zEGs2xYwBGkiZoaNAD/J/SLbhlj7BxfwR5ZP98Bh4eRi8Z3e6V2JXv3GjHC
        SNJzkOLZv22N6LQYpAcrUCABMklRV2GJxrM8qG4CQPxqUR8anP8SBK0+yxlXaXNHNml
        3dQq7+EdFfXTBTFtgG/1aBfUwfJ7nz30WZFXVGCQ=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 158625153456928.917152916801797; Tue, 7 Apr 2020 17:25:34 +0800 (CST)
Date:   Tue, 07 Apr 2020 17:25:34 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Hou Tao" <houtao1@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <17153f590e5.13f80af2342991.2831629093514707476@mykernel.net>
In-Reply-To: <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
 <17153e5b537.c827c90942921.7568518513045332175@mykernel.net> <CAOQ4uxiHwQ4_rGLZeKS8VwP84YoUDZcju76KeYugt+SOAKVGKQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-07 17:19:03 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Tue, Apr 7, 2020 at 12:08 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-03 17:18:06 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Fri, Apr 3, 2020 at 9:45 AM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
 > >  > >
 > >  > > Sharing inode with different whiteout files for saving
 > >  > > inode and speeding up delete operation.
 > >  > >
 > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  >
 > >  > A few more nits.
 > >  > Please wait with v3 until I fix my patches, so you can test in top =
of
 > >  > them.
 > >  > Please run the overlay xfstests to test your patch.
 > >  >
 > >  > I suspect this part of test overlay/031 will fail and will need to =
fix
 > >  > the test to expect at most single whiteout 'residue' in work dir:
 > >  >
 > >  > # try to remove test dir from overlay dir, trigger ovl_remove_and_w=
hiteout,
 > >  > # it will not clean up the dir and lead to residue.
 > >  > rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 > >  > ls $workdir/work
 > >
 > > It seems no effect to current test case, I passed all test cases in ov=
erlay dir
 > > except nfs_export and mmap related cases.
 > >
 >=20
 > mmap test fails in baseline.
 > did nfs_export tests fail with my recent branch (c1fe7dcb3db8)?
 > because I had a bug that caused nfs_export tests to fail.
 >=20
 >=20
 > ...
 >=20

Actually, it is "not run" not fail. I'm not very familiar how to run with n=
fs_export,
is it needing some special options?=20

test log below:

overlay/068     [not run] overlay feature 'nfs_export' cannot be enabled on=
 /mnt/scratch
overlay/069     [not run] overlay feature 'nfs_export' cannot be enabled on=
 /mnt/scratch
overlay/070     [not run] overlay feature 'nfs_export' cannot be enabled on=
 /mnt/scratch
overlay/071     [not run] overlay feature 'nfs_export' cannot be enabled on=
 /mnt/scratch

overlay/050 4s ... [not run] overlay feature 'nfs_export' cannot be enabled=
 on /mnt/scratch
overlay/051 3s ... [not run] overlay feature 'nfs_export' cannot be enabled=
 on /mnt/scratch
overlay/052 1s ... [not run] overlay feature 'nfs_export' cannot be enabled=
 on /mnt/scratch
overlay/053 2s ... [not run] overlay feature 'nfs_export' cannot be enabled=
 on /mnt/scratch
overlay/054 1s ... [not run] overlay feature 'nfs_export' cannot be enabled=
 on /mnt/scratch
overlay/055 1s ... [not run] overlay feature 'nfs_export' cannot be enabled=
 on /mnt/scratch


Thanks,
cgxu


