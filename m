Return-Path: <SRS0=Z+t6=5L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B137EC43331
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFAF2070A
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Bur/elFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCZFp4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 01:45:56 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25399 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgCZFpz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Mar 2020 01:45:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585201516;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=T8F3usnxHoavm8O9Dmg6T6ww/LaZY7nDMZF9nz1SEe0=;
        b=Bur/elFV1EzGRJAdfUhLc5u7xm/IshT+IQIex5XLUTbaSAVvDPxH/p3yT0eIx1Tb
        LjN1SGFDdiRjJkM5LVA/LA6PyJ57LDo/jIye5xemijQ79HH0LL7V4UkDmOOOPCNpDHZ
        tY++OhM4oT3Ra/x9GcLu1z6URw8GIO2S9aWnoifM=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1585201512372678.8879789313831; Thu, 26 Mar 2020 13:45:12 +0800 (CST)
Date:   Thu, 26 Mar 2020 13:45:12 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Cc:     "miklos" <miklos@szeredi.hu>, "amir73il" <amir73il@gmail.com>,
        "cgxu519" <cgxu519@mykernel.net>
Message-ID: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
In-Reply-To: 
Subject: Inode limitation for overlayfs
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

=E2=80=8BHello,

On container use case, in order to prevent inode exhaustion on host file sy=
stem by particular containers,  we would like to add inode limitation for c=
ontainers.
However,  current solution for inode limitation is based on project quota i=
n specific underlying filesystem so it will also count deleted files(char t=
ype files) in overlay's upper layer.
Even worse, users may delete some lower layer files for getting more usable=
 free inodes but the result will be opposite (consuming more inodes).

It is somewhat different compare to disk size limitation for overlayfs, so =
I think maybe we can add a limit option just for new files in overlayfs. Wh=
at do you think?
If you guys think it is reasonable solution I can post a RFC patch for revi=
ew.


Thanks,
cgxu
